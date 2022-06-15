import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_apaga/Cubit/Internet/cubit/internet_cubit.dart';
import 'package:new_apaga/bloc/Notification/bloc/notification_bloc.dart';
import 'package:new_apaga/bloc/QRCounterAndReason/bloc/qr_counter_reason_bloc.dart';
import 'package:new_apaga/bloc/QrCodeSend/bloc/qr_send_bloc.dart';
import 'package:new_apaga/bloc/SeeMorde/bloc/see_more_bloc.dart';
import 'package:new_apaga/screens/Menu/Home/aboutmore.dart';
import 'package:new_apaga/screens/Menu/myPickup/qr_or_comment.dart';
import 'package:new_apaga/screens/Menu/scrolltohide.dart';
import 'package:new_apaga/screens/notification/notification.dart';
import '../../../bloc/Auth_Bloc/bloc/auth_bloc.dart';
import '../../../bloc/Confirm/bloc/confirm_bloc.dart';
import '../../../bloc/Order_bloc/order_bloc.dart';
import '../../../repository.dart';
import '../../QR_code/qr_code.dart';
//import 'filtr.dart';

class MyPickUp extends StatefulWidget {
  const MyPickUp({Key? key}) : super(key: key);
  @override
  MyPickUpState createState() => MyPickUpState(
        auth: AuthBloc(),
        userRepository: UserRepository(),
      );
}

class MyPickUpState extends State<MyPickUp> {
  TextEditingController _controllerId = TextEditingController();
  UserRepository userRepository;
  AuthBloc auth;
  var blocOrder;
  bool isFinish = true;
  bool moveItem = false;
  bool moveIcon = true;
  String titleText = "Իմ հավաքները";
  static String assigned = "assigned";
  static String completed = "completed";
  static String incomplete = "incomplete";
  static String missed = "missed";

  MyPickUpState({required this.auth, required this.userRepository});
  // pickups models List
//  List<OrderModel> models = [];
  // get json data from list
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
    print("initalstate");
    blocOrder = BlocProvider.of<ListBloc>(context);
    blocOrder.add(AssignedEvent(assignedStatus: assigned));
    // var boolCubit = BlocProvider.of<BoolCubit>(context);
    super.initState();
    // @override
    // void dispose() {
    //   super.dispose();
    //   BoolCubit().close();
    //   // AcceptfinishCubit().close();
    //   ConfirmBloc(authenticationBloc: AuthBloc(), userRepository: userRepository)
    //       .close();
    // }
  }

  Future<dynamic> filtr(BuildContext cotext) {
    return showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        context: cotext,
        builder: (cotext) {
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
                        padding:
                            const EdgeInsets.only(left: 11, right: 18, top: 16),
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
                                      if (sendSectionsList.isNotEmpty) {
                                        blocOrder =
                                            BlocProvider.of<ListBloc>(context);
                                        blocOrder.add(SectionMyButtonPressed(
                                            section: sendSectionsList));
                                        print(sendSectionsList);
                                      } else if (sendSectionsList.isEmpty) {
                                        // blocOrder = BlocProvider.of<ListBloc>(context);
                                        // blocOrder.add(AssignedEvent(assignedStatus: assigned));
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    icon: SvgPicture.asset("assets/icon/x.svg"),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 31, right: 88),
                              child: Container(
                                height: 154,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                      color: Color.fromRGBO(112, 112, 112, 1),
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          moveIcon = true;
                                          titleText = "Իմ հավաքները";
                                        });
                                        blocOrder =
                                            BlocProvider.of<ListBloc>(context);
                                        blocOrder.add(AssignedEvent(
                                            assignedStatus: assigned));
                                        Navigator.of(context).pop();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                          "Իմ հավաքները",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromRGBO(12, 128, 64, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          moveIcon = false;
                                          titleText = "Ավարտված";
                                        });
                                        blocOrder =
                                            BlocProvider.of<ListBloc>(context);
                                        blocOrder.add(CompletedEvent(
                                            completedStatus: completed));
                                        Navigator.of(context).pop();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                          "Ավարտված",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromRGBO(
                                                  12, 128, 64, 1)),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          moveIcon = false;
                                          titleText = "Չկատարված";
                                        });
                                        blocOrder =
                                            BlocProvider.of<ListBloc>(context);
                                        blocOrder.add(IncompleteEvent(
                                            incompleteStatus: incomplete));
                                        Navigator.of(context).pop();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                          "Չկատարված",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromRGBO(
                                                  12, 128, 64, 1)),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          moveIcon = false;
                                          titleText = "Բաց թողնված";
                                        });
                                        blocOrder =
                                            BlocProvider.of<ListBloc>(context);
                                        blocOrder.add(
                                            MissedEvent(missedStatus: missed));
                                        Navigator.of(context).pop();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                          "Բաց թողնված",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromRGBO(
                                                  12, 128, 64, 1)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 31),
                              child: Row(
                                children: const [
                                  Text(
                                    "Ըստ  տարածաշրջանի",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromRGBO(12, 128, 64, 1)),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18),
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
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          );
        }).then((value) {
      if (sendSectionsList.isNotEmpty) {
        blocOrder = BlocProvider.of<ListBloc>(context);
        blocOrder.add(SectionMyButtonPressed(section: sendSectionsList));
        print(sendSectionsList);
      } else if (sendSectionsList.isEmpty) {
        // blocOrder = BlocProvider.of<ListBloc>(context);
        // blocOrder.add(AssignedEvent(assignedStatus: assigned));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color colors = const Color.fromRGBO(12, 128, 64, 1);
    double width = MediaQuery.of(context).size.width;
    return Container(
        color: const Color.fromRGBO(232, 232, 232, 1),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 0,
                stretch: true,
                backgroundColor: Color.fromRGBO(12, 128, 64, 1),
                floating: false,
                pinned: true,
                primary: true,
                snap: false,
                centerTitle: true,
                title: Text(
                  "$titleText",
                  style: const TextStyle(
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
                                              create: (context) =>
                                                  NotificationBloc(
                                                      authenticationBloc:
                                                          BlocProvider.of<
                                                                  AuthBloc>(
                                                              context),
                                                      repository:
                                                          userRepository),
                                              child: const NotificationNew(),
                                            )));
                                setState(() {
                                  moveItem = false;
                                });
                              },
                              icon: SvgPicture.asset(
                                  "assets/icon/notification.svg")),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100, left: 21),
                      child: Row(
                        children: [
                          IconButton(
                              icon: SvgPicture.asset("assets/icon/filtr.svg"),
                              tooltip: 'Increase volume by 10',
                              onPressed: () {
                                isChecked = false;
                                sendSectionsList.clear();

                                filtr(context);
                                setState(() {
                                  moveItem = false;
                                });
                              }),
                          moveIcon == true
                              ? IconButton(
                                  icon: SvgPicture.asset(
                                      "assets/icon/Group 3791.svg"),
                                  tooltip: 'Increase volume by 10',
                                  onPressed: () {
                                    setState(() {
                                      moveItem = !moveItem;
                                    });
                                  })
                              : const Text("")
                        ],
                      ),
                    )
                  ]),
                ),
                expandedHeight: MediaQuery.of(context).size.height * 0.155,
              ),
            ];
          },
          body: BlocBuilder<ListBloc, ListState>(builder: (context, state) {
            if (state is InitialState) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.green));
            } else if (state is LoadingState) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.green));
            }
            if (state is SectionsMySuccses) {
              if (state.orders.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    return gridViewOrder(
                        key: ValueKey(state.orders),
                        state: state,
                        itemCount: state.orders.length,
                        order: state.orders,
                        index: index);
                  },
                );
              } else if (state.orders.isEmpty) {
                return Container(
                  child: const Center(child: Text("Հավաքներ չեն գտնվել")),
                );
              }
            }
            if (state is AssignedSuccses) {
              if (state.orders.isNotEmpty) {
                return moveItem == true
                    ? ReorderableListView.builder(
                        shrinkWrap: true,
                        onReorder: (oldIndex, newIndex) => setState(() {
                          final index =
                              newIndex > oldIndex ? newIndex - 1 : newIndex;
                          final user = state.orders.removeAt(oldIndex);
                          state.orders.insert(index, user);
                        }),
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          return gridViewOrder(
                              key: ValueKey(state.orders[index]),
                              state: state,
                              itemCount: state.orders.length,
                              order: state.orders,
                              index: index);
                        },
                      )
                    : ListView.builder(
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          print(state.orders.length);
                          return gridViewOrder(
                              key: ValueKey(state.orders),
                              state: state,
                              itemCount: state.orders.length,
                              order: state.orders,
                              index: index);
                        },
                      );
              } else if (state.orders.isEmpty) {
                return Container(
                  child: const Center(child: Text("Հավաքներ չեն գտնվել")),
                );
              }
            }
            if (state is CompletedSuccses) {
              if (state.orders.isEmpty) {
                return Container(
                  child: const Center(child: Text("Հավաքներ չեն գտնվել")),
                );
              } else if (state.orders.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    return gridViewOrder(
                        key: ValueKey(state.orders),
                        state: state,
                        itemCount: state.orders.length,
                        order: state.orders,
                        index: index);
                  },
                );
              }
            } else if (state is IncompleteSuccses) {
              if (state.orders.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    return gridViewOrder(
                        key: ValueKey(state.orders),
                        state: state,
                        itemCount: state.orders.length,
                        order: state.orders,
                        index: index);
                  },
                );
              } else if (state.orders.isEmpty) {
                return Container(
                  child: const Center(child: Text("Հավաքներ չեն գտնվել")),
                );
              }
            } else if (state is MissedSuccses) {
              if (state.orders.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    return gridViewOrder(
                        key: ValueKey(state.orders),
                        state: state,
                        itemCount: state.orders.length,
                        order: state.orders,
                        index: index);
                  },
                );
              } else if (state.orders.isEmpty) {
                return Container(
                  child: const Center(child: Text("Հավաքներ չեն գտնվել")),
                );
              }
            }
            return Container(
              child: const Center(
                  child: CircularProgressIndicator(color: Colors.green)),
            );
          }),
        ));
  }

  Widget gridViewOrder(
      {required ValueKey key,
      required dynamic state,
      required int itemCount,
      required List<OrderModel> order,
      required int index}) {
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
    if (order[index].status == "completed") {
      order[index].navigQR = false;
      order[index].colorMenu = true;
      order[index].textNext = "${order[index].price}";
      order[index].hideButton = false;
    }
    if (order[index].status == "assigned") {
      order[index].hideButton = false;
      order[index].navigQR = true;
      order[index].colorMenu = false;
      order[index].textNext = "Ավարտել";
    }
    if (order[index].status == "incomplete") {
      order[index].hideButton = true;
    }
    if (order[index].status == "missed") {
      order[index].hideButton = true;
    }
    return Container(
      key: key,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        key: key,
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
                            width: 1, color: Color.fromRGBO(232, 232, 232, 1)),
                      ),
                    ),
                    child: Row(
                      children: [
                        moveItem == true
                            ? const Expanded(
                                flex: 1,
                                child: ImageIcon(
                                  AssetImage("assets/icon/hand_.png"),
                                  color: Color.fromRGBO(153, 153, 153, 1),
                                ))
                            : const Text(""),
                        Expanded(
                          flex: 9,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            child: Text(
                              '${order[index].customer_address}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 10, 11),
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
                            padding:
                                EdgeInsetsDirectional.fromSTEB(5.9, 0, 0, 0),
                            child: Text(
                              '${order[index].bagsCounter}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(23, 0, 0, 0),
                            child: SvgPicture.asset(
                              "assets/icon/datark_bag.svg",
                              height: 18,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(5.9, 0, 0, 0),
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
          //under
          IgnorePointer(
            ignoring: moveItem,
            child: Padding(
              padding: const EdgeInsets.only(top: 86),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: order[index].hideButton == true
                                ? const Color.fromRGBO(242, 242, 242, 1)
                                : const Color.fromRGBO(255, 255, 255, 1),
                          ),
                          child: const Center(
                              child: Text(
                            'Տեսնել ավելին',
                            style: TextStyle(
                                color: Color.fromRGBO(12, 128, 64, 1)),
                          )),
                        ),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider<ConfirmBloc>(
                                            create: (context) => ConfirmBloc(
                                                authenticationBloc: auth,
                                                userRepository: userRepository),
                                          ),
                                          BlocProvider<SeeMoreBloc>(
                                            create: (context) => SeeMoreBloc(
                                              authenticationBloc: auth,
                                              repository: userRepository,
                                            ),
                                          ),
                                          BlocProvider<QrCounterReasonBloc>(
                                            create: (context) =>
                                                QrCounterReasonBloc(
                                                    authenticationBloc:
                                                        BlocProvider.of<
                                                            AuthBloc>(context),
                                                    userRepository:
                                                        userRepository),
                                          ),
                                        ],
                                        child: AboutMore(
                                          id: order[index].pickup_id,
                                          status: order[index].status,
                                        ),
                                      )));
                        },
                      ),
                    ),
                    order[index].hideButton == false
                        ? Expanded(
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: order[index].colorMenu == false
                                        ? const Color.fromRGBO(159, 205, 79, 1)
                                        : const Color.fromRGBO(
                                            169, 166, 166, 1)),
                                child: Center(
                                  child: Text(
                                    "${order[index].textNext}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromRGBO(240, 240, 240, 1)),
                                  ),
                                ),
                              ),
                              onTap: () {
                                print(order[index].pickup_id);
                                // order[index].navigQR == true
                                //     ? Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) =>
                                //                 BlocProvider<QrSendBloc>(
                                //                   create: (context) => QrSendBloc(
                                //                       authenticationBloc:
                                //                           BlocProvider.of<
                                //                               AuthBloc>(context),
                                //                       userRepository:
                                //                           UserRepository()),
                                //                   child: QrCode(
                                //                     id: order[index].pickup_id,
                                //                   ),
                                //                 )),
                                //       )
                                //     : null;

                                order[index].navigQR == true
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QRorComment(
                                                id: order[index].pickup_id)),
                                      )
                                    : null;
                                //   //           // blocOrder = BlocProvider.of<ListBloc>(context);
                              },
                            ),
                          )
                        : Text(""),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
