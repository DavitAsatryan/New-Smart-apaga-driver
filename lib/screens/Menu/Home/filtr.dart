import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../bloc/Order_bloc/order_bloc.dart';

class Filtr extends StatefulWidget {
  Filtr({Key? key}) : super(key: key);
  @override
  State<Filtr> createState() => _FiltrState();
}

class _FiltrState extends State<Filtr> {
  bool isChecked = false;
  var blocOrder;
  List<String> sendSectionsList = [];
  List section = [
    "Աջափնյակ",
    "Արաբկիր",
    "Ավան",
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
    blocOrder.add(FetchEvent());
    // var boolCubit = BlocProvider.of<BoolCubit>(context);
    // _scrollController.addListener(_onScrollEvent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: SvgPicture.asset("assets/icon/filtr.svg"),
        tooltip: 'Increase volume by 10',
        onPressed: () {
          isChecked = false;
          sendSectionsList.clear();
          showDialog(
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icon/filtr.svg"),
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
                                            "",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color.fromRGBO(
                                                    12, 128, 64, 1)),
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
                                                        sendSectionsList.add(
                                                            section[index]);
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
              }).then((value) {
            print("then section  $sendSectionsList");
            blocOrder = BlocProvider.of<ListBloc>(context);
            blocOrder.add(SectionButtonPressed(section: sendSectionsList));
          });
        });
    //     Padding(
    //           padding: const EdgeInsets.only(left: 21, top: 19, bottom: 0),
    //           child: Row(
    //             children: [
    //               IconButton(
    //                   icon: SvgPicture.asset("assets/icon/filtr.svg"),
    //                   tooltip: 'Increase volume by 10',
    //                   onPressed: () {
    //                     isChecked = false;
    //                     sendSectionsList.clear();
    //                     showDialog(
    //                         barrierColor: Colors.transparent,
    //                         context: context,
    //                         builder: (context) {
    //                           return Dialog(
    //                               elevation: 0,
    //                               backgroundColor: Colors.transparent,
    //                               insetPadding: EdgeInsets.only(top: 10),
    //                               child: Stack(
    //                                 children: <Widget>[
    //                                   Padding(
    //                                       padding: const EdgeInsets.only(
    //                                           top: 84, bottom: 49),
    //                                       child: Container(
    //                                         width: double.infinity,
    //                                         height: double.infinity,
    //                                         decoration: const BoxDecoration(
    //                                             borderRadius:
    //                                                 BorderRadius.only(
    //                                                     topLeft: Radius
    //                                                         .circular(10),
    //                                                     topRight:
    //                                                         Radius.circular(
    //                                                             10)),
    //                                             color: Color.fromRGBO(
    //                                                 255, 255, 255, 1)),
    //                                         child: Padding(
    //                                           padding:
    //                                               const EdgeInsets.only(
    //                                                   left: 11,
    //                                                   right: 18,
    //                                                   top: 16),
    //                                           child: Column(
    //                                             crossAxisAlignment:
    //                                                 CrossAxisAlignment
    //                                                     .stretch,
    //                                             children: [
    //                                               Padding(
    //                                                 padding:
    //                                                     const EdgeInsets
    //                                                         .only(left: 10),
    //                                                 child: Row(
    //                                                   mainAxisSize:
    //                                                       MainAxisSize.max,
    //                                                   mainAxisAlignment:
    //                                                       MainAxisAlignment
    //                                                           .spaceBetween,
    //                                                   children: [
    //                                                     SvgPicture.asset(
    //                                                         "assets/icon/filtr.svg"),
    //                                                     IconButton(
    //                                                       onPressed: () {
    //                                                         Navigator.of(
    //                                                                 context)
    //                                                             .pop();
    //                                                       },
    //                                                       icon: Icon(
    //                                                           Icons.close),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                               ),
    //                                               Padding(
    //                                                 padding:
    //                                                     const EdgeInsets
    //                                                         .only(left: 10),
    //                                                 child: Row(
    //                                                   children: const [
    //                                                     Text(
    //                                                       "
    //                                                       style: TextStyle(
    //                                                           fontSize: 16,
    //                                                           color: Color
    //                                                               .fromRGBO(
    //                                                                   12,
    //                                                                   128,
    //                                                                   64,
    //                                                                   1)),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                               ),
    //                                               Expanded(
    //                                                 child: ListView.builder(
    //                                                   addAutomaticKeepAlives:
    //                                                       false,
    //                                                   scrollDirection:
    //                                                       Axis.vertical,
    //                                                   itemCount:
    //                                                       section.length,
    //                                                   itemBuilder:
    //                                                       (context, index) {
    //                                                     return StatefulBuilder(
    //                                                         builder: (context,
    //                                                             StateSetter
    //                                                                 setState) {
    //                                                       return Row(
    //                                                         children: [
    //                                                           Checkbox(
    //                                                               value:
    //                                                                   isChecked,
    //                                                               onChanged:
    //                                                                   (checked) {
    //                                                                 setState(
    //                                                                     () {
    //                                                                   isChecked =
    //                                                                       checked!;
    //                                                                 });
    //                                                                 if (isChecked ==
    //                                                                     true) {
    //                                                                   sendSectionsList
    //                                                                       .add(section[index]);
    //                                                                   print(
    //                                                                       sendSectionsList);
    //                                                                 }
    //                                                               }),
    //                                                           Text(
    //                                                               "${section[index]}",
    //                                                               style: const TextStyle(
    //                                                                   fontSize:
    //                                                                       16,
    //                                                                   color: Color.fromRGBO(
    //                                                                       75,
    //                                                                       75,
    //                                                                       75,
    //                                                                       1))),
    //                                                         ],
    //                                                       );
    //                                                       // return ListTile(
    //                                                       //   leading: Checkbox(
    //                                                       //       value:
    //                                                       //           isChecked,
    //                                                       //       onChanged:
    //                                                       //           (checked) {
    //                                                       //         setState(
    //                                                       //             () {
    //                                                       //           isChecked =
    //                                                       //               checked!;
    //                                                       //         });
    //                                                       //       }),
    //                                                       //   title: Text(
    //                                                       //       "${section[index]}",
    //                                                       //       style: TextStyle(
    //                                                       //           fontSize:
    //                                                       //               16,
    //                                                       //           color: Color.fromRGBO(
    //                                                       //               75,
    //                                                       //               75,
    //                                                       //               75,
    //                                                       //               1))),
    //                                                       // );
    //                                                     });
    //                                                   },
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                         ),
    //                                       )),
    //                                 ],
    //                               ));
    //                         }).then((value) {
    //                       print("then section  $sendSectionsList");
    //                       blocOrder = BlocProvider.of<ListBloc>(context);
    //                       blocOrder.add(SectionButtonPressed(
    //                           section: sendSectionsList));
    //                     });
    //                     // showDialog(
    //                     //     context: context,
    //                     //     builder: (_) => AlertDialog(
    //                     //           shape: const RoundedRectangleBorder(
    //                     //               borderRadius: BorderRadius.all(
    //                     //                   Radius.circular(10.0))),
    //                     //           content: Builder(
    //                     //             builder: (context) {
    //                     //               // Get available height and width of the build area of this widget. Make a choice depending on the size.
    //                     //               var height = 0;
    //                     //               var width = double.infinity;
    //                     //               return Container(
    //                     //                 height: height - 100,
    //                     //                 width: width - double.infinity,
    //                     //               );
    //                     //             },
    //                     //           ),
    //                     //         ));
    //                   })
    //             ],
    //           ),
    //         ),
    //         Expanded(
    //           child: BlocBuilder<ListBloc, ListState>(
    //               builder: (context, state) {
    //             if (state is InitialState) {
    //               return const Center(
    //                   child:
    //                       CircularProgressIndicator(color: Colors.green));
    //             } else if (state is LoadingState) {
    //               return const Center(
    //                   child:
    //                       CircularProgressIndicator(color: Colors.green));
    //             } else if (state is FetchSuccses) {
    //               return Container(
    //                 child: gridViewOrder(
    //                     state, state.orders.length, state.orders),
    //               );
    //             } else if (state is SectionsSuccses) {
    //               return Container(
    //                 child: gridViewOrder(
    //                     state, state.orders.length, state.orders),
    //               );
    //             }
    //             //  else if (state is UnassignedSuccses) {
    //             //   return Container(
    //             //       child: gridViewOrder(
    //             //           state, state.orders.length, state.orders));
    //             // } else if (state is AssignedSuccses) {
    //             //   return Container(
    //             //       child: gridViewOrder(
    //             //           state, state.orders.length, state.orders));
    //             // } else if (state is CanceledSuccses) {
    //             //   return Container(
    //             //       child: gridViewOrder(
    //             //           state, state.orders.length, state.orders));
    //             // } else if (state is CompletedSuccses) {
    //             //   return Container(
    //             //       child: gridViewOrder(
    //             //           state, state.orders.length, state.orders));
    //             // } else if (state is IncompleteSuccses) {
    //             //   return Container(
    //             //       child: gridViewOrder(
    //             //           state, state.orders.length, state.orders));
    //             // } else if (state is MissedSuccses) {
    //             //   return Container(
    //             //       child: gridViewOrder(
    //             //           state, state.orders.length, state.orders));
    //             // }
    //             return Container(
    //               child: const Center(child: Text("Data Is Empty")),
    //             );
    //           }),
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
  }
}
