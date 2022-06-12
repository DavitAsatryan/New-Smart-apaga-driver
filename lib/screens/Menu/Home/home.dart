import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_apaga/Cubit/Internet/cubit/internet_cubit.dart';
import 'package:new_apaga/Enum/internetEnum.dart';
import 'package:new_apaga/bloc/Notification/bloc/notification_bloc.dart';
import 'package:new_apaga/bloc/QRCounterAndReason/bloc/qr_counter_reason_bloc.dart';
import 'package:new_apaga/bloc/QrCodeSend/bloc/qr_send_bloc.dart';
import 'package:new_apaga/bloc/SeeMorde/bloc/see_more_bloc.dart';
import 'package:new_apaga/screens/Menu/scrolltohide.dart';
import 'package:new_apaga/screens/notification/notification.dart';
import 'package:new_apaga/showdIalogs.dart';
import '../../../bloc/Auth_Bloc/bloc/auth_bloc.dart';
import '../../../bloc/Confirm/bloc/confirm_bloc.dart';
import '../../../bloc/Order_bloc/order_bloc.dart';
import '../../../repository.dart';
import '../../QR_code/qr_code.dart';

import 'aboutmore.dart';
import 'filtr.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  HomeState createState() => HomeState(
        auth: AuthBloc(),
        userRepository: UserRepository(),
      );
}

class HomeState extends State<Home> {
  TextEditingController _controllerId = TextEditingController();
  UserRepository userRepository;
  AuthBloc auth;
  var blocOrder;
  bool isFinish = true;
  bool dd = true;
  HomeState({required this.auth, required this.userRepository});
  final key = GlobalKey();
  final _scrollController = ScrollController();
  bool isChecked = false;
  List<String> sendSectionsList = [];
  List section = [
    "Աջափնյակ",
    "Արաբկիր",
    "Lennakan",
    "Դավիթաշեն",
    "Էրեբունի",
    "Քանաքեռ-Զեյթուն",
    "Կենտրոն",
    "Մալաթիա-Սեբաստիա",
    "Նորք-Մարաշ",
    "Նոր Նորք",
    "Նուբարաշեն",
    "Շենգավիթ"
  ];

  @override
  void initState() {
    blocOrder = BlocProvider.of<ListBloc>(context);
    blocOrder.add(FetchEvent());
    //acceptFinish = BlocProvider.of<AcceptfinishCubit>(context);
    super.initState();
  }

  _onConfirmButtonPressed(int id) {
    BlocProvider.of<ConfirmBloc>(context).add(
      ConfirmButtonPressed(
        pickupId: id,
      ),
    );
  }

  // _onSeeMorePressed(int id) {
  //   BlocProvider.of<SeeMoreBloc>(context).add(
  //     SeeMoreEventPressed(id: id),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(232, 232, 232, 1)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 0,
              stretch: true,
              backgroundColor: const Color.fromRGBO(12, 128, 64, 1),
              floating: false,
              pinned: true,
              primary: true,
              snap: false,
              centerTitle: true,
              title: const Text(
                "Օրվա հավաք",
                style: TextStyle(
                    color: Color.fromRGBO(232, 232, 232, 1), fontSize: 20),
              ),
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground
                ],
                background: Stack(children: [
                  Image.asset(
                    "assets/notificaion.png",
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 75, right: 23.3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                          create: (context) => NotificationBloc(
                                              authenticationBloc:
                                                  BlocProvider.of<AuthBloc>(
                                                      context),
                                              repository: userRepository),
                                          child: const NotificationNew(),
                                        )));
                          },
                          icon:
                              SvgPicture.asset("assets/icon/notification.svg"),
                          //Image.asset("")
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100, left: 21),
                    child: IconButton(
                        icon: SvgPicture.asset("assets/icon/filtr.svg"),
                        tooltip: 'Increase volume by 10',
                        onPressed: () {
                          isChecked = false;
                          sendSectionsList.clear();
                          dialog(context).then((value) {
                            print("then section  $sendSectionsList");
                            if (sendSectionsList.isNotEmpty) {
                              blocOrder = BlocProvider.of<ListBloc>(context);
                              blocOrder.add(SectionButtonPressed(
                                  section: sendSectionsList));
                            } else if (sendSectionsList.isEmpty) {
                              print("empty section list");
                              blocOrder = BlocProvider.of<ListBloc>(context);
                              blocOrder.add(FetchEvent());
                            }
                          });
                        }),
                  )
                ]),
              ),
              expandedHeight: MediaQuery.of(context).size.height * 0.155,
            ),
          ];
        },
        body: MultiBlocListener(
            child: BlocBuilder<ListBloc, ListState>(builder: (context, state) {
              if (state is InitialState) {
                return Center(
                    child: Container(
                        child: CircularProgressIndicator(color: Colors.green)));
              } else if (state is LoadingState) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.green));
              } else if (state is FetchSuccses) {
                if (state.orders.isNotEmpty) {
                  return gridViewOrder(
                      state, state.orders.length, state.orders);
                } else if (state.orders.isEmpty) {
                  return Container(
                    child: const Center(child: Text("Հավաքներ չեն գտնվել")),
                  );
                }
                return gridViewOrder(state, state.orders.length, state.orders);
              } else if (state is SectionsSuccses) {
                if (state.orders.isNotEmpty) {
                  return gridViewOrder(
                      state, state.orders.length, state.orders);
                } else if (state.orders.isEmpty) {
                  return Container(
                    child: const Center(child: Text("Հավաքներ չեն գտնվել")),
                  );
                }
              }

              return Container(
                child: const Center(child: Text("Հավաքներ չեն գտնվել")),
              );
            }),
            listeners: [
              BlocListener<ConfirmBloc, ConfirmState>(
                listener: (cont, state) {
                  if (state is ConfirmInitial) {
                    print("confirm loading");

                    Container(
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is ConfirmLoading) {
                    print("confirm sucsses");

                    showDialog(
                        context: cont,
                        builder: (context) {
                          return AlertDialog(
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        const Color.fromRGBO(159, 205, 79, 1),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    minimumSize:
                                        const Size(100, 36), //////// HERE
                                  ),
                                  onPressed: () {
                                    blocOrder = BlocProvider.of<ListBloc>(cont);
                                    blocOrder.add(FetchEvent());

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Լավ',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: 16,
                                      )),
                                ),
                              ],
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 144, 138, 137)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              content: StatefulBuilder(
                                builder: (context, setState) => Container(
                                  child: const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 1),
                                    child: Text("Գործընթացը հաջողվեց"),
                                  ),
                                ),
                              ));
                        });
                  }
                  if (state is ConfirmFailure) {
                    print("confirm felure");

                    ShowDialogs().showFailure(context);
                  }
                },
                // child: BlocListener<SeeMoreBloc, SeeMoreState>(
                //   listener: (context, state) {
                //     if (state is SeeMoreInitialState) {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (_) => MultiBlocProvider(
                //                     providers: [
                //                       BlocProvider<ConfirmBloc>(
                //                         create: (context) => ConfirmBloc(
                //                           authenticationBloc: AuthBloc(),
                //                           userRepository: UserRepository(),
                //                         ),
                //                       ),
                //                       BlocProvider<InternetCubit>(
                //                           create: (context) => InternetCubit(
                //                               connectivity: Connectivity())),
                //                     ],
                //                     child: AboutMore(
                //                       cancelPick: false,
                //                       pickTrue: false,
                //                     ),
                //                   )));
                //     }
                //     if (state is SeeMoreError) {
                //       showDialog(
                //         context: context,
                //         builder: (context) {
                //           return AlertDialog(
                //             shape: const RoundedRectangleBorder(
                //               side: BorderSide(
                //                   color: Color.fromARGB(255, 144, 138, 137)),
                //             ),
                //             content: StatefulBuilder(
                //               builder: (context, setState) => Container(
                //                 child: const Padding(
                //                   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                //                   child: Text("
                //                 ),
                //               ),
                //             ),
                //           );
                //         },
                //       );
                //       Future.delayed(const Duration(seconds: 2))
                //           .then((value) => Navigator.of(context).pop());
                //     }
                //   },
              ),
            ]),
      ),
    );
  }

  Future<dynamic> dialog(BuildContext context) {
    return showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.only(top: 10),
              child: Stack(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 84, bottom: 49),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: Color.fromRGBO(255, 255, 255, 1)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 11, right: 18, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset("assets/icon/filtr.svg"),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: const [
                                    Text(
                                      "Ըստ  տարածաշրջանի",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromRGBO(12, 128, 64, 1)),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  addAutomaticKeepAlives: false,
                                  scrollDirection: Axis.vertical,
                                  itemCount: section.length,
                                  itemBuilder: (context, index) {
                                    return StatefulBuilder(builder:
                                        (context, StateSetter setState) {
                                      return Row(
                                        children: [
                                          Checkbox(
                                              value: isChecked,
                                              onChanged: (checked) {
                                                setState(() {
                                                  isChecked = checked!;
                                                });
                                                if (isChecked == true) {
                                                  sendSectionsList
                                                      .add(section[index]);
                                                  print(sendSectionsList);
                                                }
                                              }),
                                          Text("${section[index]}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      75, 75, 75, 1))),
                                        ],
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ));
        });
  }

  Widget gridViewOrder(dynamic state, int itemCount, List<OrderModel> order) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        order[index].paper = 0;
        order[index].plastic = 0;
        order[index].glass = 0;
        order[index].bagsCounter = order[index].waste_type!.length;
        for (var i = 0; i < order[index].waste_type!.length; i++) {
          if (order[index].waste_type![i] == "paper") {
            order[index].paper++;
          }
          if (order[index].waste_type![i] == "plastic") {
            order[index].plastic++;
          }
          if (order[index].waste_type![i] == "glass") {
            order[index].glass++;
          }
        }
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 22),
          child: Stack(children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                // borderRadius: BorderRadius.circular(3),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              height: 126,
              width: MediaQuery.of(context).size.width,
              //color: const Color.fromRGBO(255, 255, 255, 1),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 12),
                    child: Container(
                      width: double.infinity,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(232, 232, 232, 1)),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: Text(
                          "${order[index].customer_address}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12, 0, 10, 11),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SvgPicture.asset(
                              "assets/icon/bag.svg",
                              height: 18,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5.9, 0, 0, 0),
                              child: Text(
                                "${order[index].bagsCounter}",
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  23, 0, 0, 0),
                              child: SvgPicture.asset(
                                "assets/icon/Path 19826.svg",
                                height: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5.9, 0, 0, 0),
                              child: Text(
                                '${order[index].quantity}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              '${order[index].order_start_time}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              ' - ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${order[index].order_time_end}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 86),
              child: Container(
                width: double.infinity,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: const Color.fromRGBO(242, 242, 242, 1),
                          ),
                          child: const Center(
                              child: Text(
                            'Տեսնել ավելին',
                            style: TextStyle(
                                color: Color.fromRGBO(12, 128, 64, 1)),
                          )),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider<ConfirmBloc>(
                                      create: (context) => ConfirmBloc(
                                        authenticationBloc: AuthBloc(),
                                        userRepository: UserRepository(),
                                      ),
                                    ),
                                    BlocProvider<QrSendBloc>(
                                      create: (context) => QrSendBloc(
                                        authenticationBloc:
                                            BlocProvider.of<AuthBloc>(context),
                                        userRepository: UserRepository(),
                                      ),
                                    ),
                                    BlocProvider<InternetCubit>(
                                        create: (context) => InternetCubit(
                                            connectivity: Connectivity())),
                                    BlocProvider<SeeMoreBloc>(
                                        create: (context) => SeeMoreBloc(
                                            authenticationBloc: auth,
                                            repository: userRepository)),
                                    BlocProvider<QrCounterReasonBloc>(
                                        create: (context) =>
                                            QrCounterReasonBloc(
                                                authenticationBloc: auth,
                                                userRepository: userRepository))
                                  ],
                                  child: AboutMore(
                                    id: order[index].pickup_id,
                                    status: order[index].status,
                                  ),
                                ),
                              ));
                          print(order[index].pickup_id);
                        },
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                            decoration: const BoxDecoration(
                              color: const Color.fromRGBO(159, 205, 79, 1),
                            ),
                            child: const Center(
                              child: Text(
                                "Վերցնել",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(240, 240, 240, 1)),
                              ),
                            )),
                        onTap: () {
                          //print(order[index].pickup_id);
                          _onConfirmButtonPressed(order[index].pickup_id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        );
      },
    );
  }
}
