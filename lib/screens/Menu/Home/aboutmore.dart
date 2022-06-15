import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/bloc/QRCounterAndReason/bloc/qr_counter_reason_bloc.dart';
import 'package:new_apaga/bloc/QrCodeSend/bloc/qr_send_bloc.dart';
import 'package:new_apaga/bloc/SeeMorde/bloc/see_more_bloc.dart';
import 'package:new_apaga/repository.dart';
import 'package:new_apaga/screens/Menu/myPickup/qr_or_comment.dart';
import 'package:new_apaga/screens/QR_code/qr_code.dart';
import 'package:new_apaga/screens/main_screen.dart';
import 'package:new_apaga/showdIalogs.dart';
import '../../../bloc/Confirm/bloc/confirm_bloc.dart';
import '../../../bloc/Order_bloc/order_bloc.dart';
import 'home.dart';

class AboutMore extends StatefulWidget {
  AboutMore({Key? key, required this.id, required this.status})
      : super(key: key);
  int id;
  String? status;

  @override
  aboutMoreState createState() => aboutMoreState(id: id, status: status);
}

class aboutMoreState extends State<AboutMore> {
  var blocSee;

  void shareToMap(dynamic lat, dynamic long) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      await availableMaps.first
          .showMarker(coords: Coords(lat, long), title: "", zoom: 20);
    } catch (e) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(159, 205, 79, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      minimumSize: const Size(100, 36), //////// HERE
                    ),
                    onPressed: () {
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
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                      child: Text(
                          "Հասցեի խնդրի պատճառով այս պահին անհնար կլինի մուտք գործել քարտեզ:"),
                    ),
                  ),
                ));
          }).then((value) => null);
    }
  }

  _onQRCounterAndReasonButtonPressed(String status) {
    print(" heyyy   ${_controller.text} $id  $text");
    BlocProvider.of<QrCounterReasonBloc>(context).add(
        QrCounterReasonButtonPressed(
            pickup_id: id,
            comment_driver: "${_controller.text} $text",
            status: "$status"));
  }

  _onConfirmButtonPressed(int id) {
    print(id);
    BlocProvider.of<ConfirmBloc>(context).add(
      ConfirmButtonPressed(
        pickupId: id,
      ),
    );
  }

  bool pickTrue = false;
  String? status;
  bool cancelPick = true;
  bool missedBool = false;
  int id;
  bool? reason;
  bool isCheckedOne = false;
  bool isCheckedTwo = false;
  bool isChecked = false;
  String dirty = "Թափոնը մաքուր չէր";
  String clean = "Թափոնը մաքուր էր";
  String text = "";
  TextEditingController _controller = TextEditingController();
  aboutMoreState({required this.id, required this.status});
  @override
  void initState() {
    blocSee = BlocProvider.of<SeeMoreBloc>(context);
    blocSee.add(SeeMoreEventPressed(id: id));
    super.initState();
    print(status);
    if (status == "completed") {
      pickTrue = true;
    }
    if (status == "assigned") {
      cancelPick = false;
    }
    if (status == "incomplete") {
      pickTrue = true;
    }
    if (status == "missed") {
      missedBool = true;
    }
    // if (status == "unassigned") {
    //   cancelPick = false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return aboutMetod();
  }

  String latitude = "";
  String longitude = "";

  Scaffold aboutMetod() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(12, 128, 64, 1),
        actions: [
          IconButton(
              onPressed: () {
                shareToMap(latitude, longitude);
              },
              icon: const Icon(
                Icons.location_on,
                color: Colors.white,
              ))
        ],
      ),
      body: BlocListener<QrCounterReasonBloc, QrCounterReasonState>(
        listener: (context, state) {
          if (state is QrCounterReasonLoading) {
            Navigator.of(context).pop();
            Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is QrCounterReasonInitial) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return const MainScreen();
              },
            ), (route) => false);
          }
          if (state is QrCounterReasonFailure) {
            ShowDialogs().showFailure(context).then((value) => null);
          }
        },
        child: BlocListener<ConfirmBloc, ConfirmState>(
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
                  barrierDismissible: false,
                  context: cont,
                  builder: (context) {
                    return AlertDialog(
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(159, 205, 79, 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              minimumSize: const Size(100, 36), //////// HERE
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return const MainScreen();
                                },
                              ), (route) => false);
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                              child: Text("Գործընթացը հաջողվեց"),
                            ),
                          ),
                        ));
                  }).then((value) => null);
            }
            if (state is ConfirmFailure) {
              print("confirm felure");

              ShowDialogs().showFailure(context).then((value) => null);
            }
          },
          child: Container(
            child: Center(child: BlocBuilder<SeeMoreBloc, SeeMoreState>(
              builder: (context, state) {
                if (state is SeeMoreLoadingState) {
                  return const CircularProgressIndicator();
                }
                if (state is SeeMoreError) {
                  return const CircularProgressIndicator();
                }
                if (state is SeeMoreFetchSuccses) {
                  return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) => aboutMoreMetod(context,
                        state, pickTrue, cancelPick, state.orders, index),
                  );
                }
                // } else if (state is AssignedSuccses) {
                //   return aboutMoreMetod(
                //       context, state, true, false, state.orders);
                // }
                // if (state is SectionsSuccses) {
                //   return aboutMoreMetod(
                //       context, state, false, false, state.orders);
                // } else if (state is CompletedSuccses) {
                //   return aboutMoreMetod(
                //       context, state, false, true, state.orders);
                // }
                return const Text("");
              },
            )),
          ),
        ),
      ),
    );
  }

  Widget aboutMoreMetod(BuildContext context, dynamic state, bool pick,
      bool cancelPick, List<dynamic> order, int index) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      return const Color.fromRGBO(12, 128, 64, 1);
    }

    if (order[index].comment_customer == null) {
      order[index].comment_customer = "";
    }
    if (order[index].building == null) {
      order[index].building == "";
    }
    if (order[index].apartment == null) {
      order[index].apartment == "";
    }
    if (order[index].entrance == null) {
      order[index].entrance == "";
    }
    if (order[index].floor == null) {
      order[index].floor == "";
    }

    // latitude = order[index].latitude;
    // longitude = order[index].longitude;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Color.fromRGBO(183, 183, 183, 0.33)))),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 17),
                child: Row(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SvgPicture.asset("assets/icon/oracuyc.svg"),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                9.4, 0, 0, 0),
                            child: Text(
                              '${order[index].order_date}',
                              style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SvgPicture.asset("assets/icon/clock.svg"),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                9.4, 0, 0, 0),
                            child: Text(
                              '${order[index].order_start_time}-${order[index].order_time_end}',
                              style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Color.fromRGBO(183, 183, 183, 0.33)))),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 18, 0, 17),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 19),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SvgPicture.asset(
                            "assets/icon/profile.svg",
                            height: 16,
                            color: const Color.fromRGBO(154, 154, 154, 1),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                9.4, 0, 0, 0),
                            child: Text(
                              '${order[index].firstname} ${order[index].lastname}',
                              style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SvgPicture.asset(
                          "assets/icon/phone.svg",
                          height: 16,
                          color: const Color.fromRGBO(154, 154, 154, 1),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              9.4, 0, 0, 0),
                          child: Text(
                            '${order[index].phoneNumber}',
                            style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Poppins',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Color.fromRGBO(183, 183, 183, 0.33)))),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Container(
                        width: 50,
                        height: 71,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(BorderSide(
                                width: 2,
                                color: Color.fromRGBO(183, 183, 183, 0.33)))),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 11, left: 6, right: 6),
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                183, 183, 183, 0.33)))),
                                width: 37,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: SvgPicture.asset(
                                      "assets/icon/plastic.svg"),
                                ),
                              ),
                            ),
                            Container(
                              width: 37,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 7.5),
                                child: Center(
                                  child: Text(
                                    '${order[index].plastic}',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18, left: 29),
                      child: Container(
                        width: 50,
                        height: 71,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(BorderSide(
                                width: 2,
                                color: Color.fromRGBO(183, 183, 183, 0.33)))),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 11, left: 6, right: 6),
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                183, 183, 183, 0.33)))),
                                width: 37,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child:
                                      SvgPicture.asset("assets/icon/paper.svg"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 6, right: 6),
                              child: Container(
                                width: 37,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7.5),
                                  child: Center(
                                    child: Text(
                                      '${order[index].paper}',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18, left: 29),
                      child: Container(
                        width: 50,
                        height: 71,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(BorderSide(
                                width: 2,
                                color: Color.fromRGBO(183, 183, 183, 0.33)))),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 11, left: 6, right: 6),
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                183, 183, 183, 0.33)))),
                                width: 37,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child:
                                      SvgPicture.asset("assets/icon/glass.svg"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 6, right: 6),
                              child: Container(
                                width: 37,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7.5),
                                  child: Center(
                                    child: Text(
                                      '${order[index].glass}',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18, left: 29),
                      child: Container(
                        width: 50,
                        height: 71,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(BorderSide(
                                width: 2,
                                color: Color.fromRGBO(183, 183, 183, 0.33)))),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 11, left: 6, right: 6),
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                183, 183, 183, 0.33)))),
                                width: 37,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: SvgPicture.asset(
                                      "assets/icon/datark_bag.svg"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 6, right: 6),
                              child: Container(
                                width: 37,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7.5),
                                  child: Center(
                                    child: Text(
                                      '${order[index].quantity}',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 140,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 17),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SvgPicture.asset("assets/icon/location.svg"),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 9.4),
                        child: Text(
                          '${order[index].customer_address} \nՇենք ${order[index].building} \nԲնակարան ${order[index].apartment} \nՄուտք ${order[index].entrance} \nՀարկ ${order[index].floor}',

                          // overflow: TextOverflow.ellipsis,
                          //softWrap: true,
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 87,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.fromBorderSide(BorderSide(
                      width: 1, color: Color.fromRGBO(183, 183, 183, 0.33)))),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(17, 0, 0, 17),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 9.4),
                        child: Text(
                          '${order[index].comment_customer}',
                          // overflow: TextOverflow.ellipsis,
                          //softWrap: true,
                          style: const TextStyle(
                            color: Color.fromRGBO(75, 75, 75, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 12.5),
              child: Row(
                children: [
                  Text(
                    "Գումարը ${order[index].price} դրամ",
                    style: const TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1), fontSize: 14),
                  ),
                ],
              ),
            ),
            missedBool != true
                ? Row(
                    mainAxisAlignment: cancelPick == false
                        ? MainAxisAlignment.spaceBetween
                        : cancelPick == true
                            ? MainAxisAlignment.center
                            : pick == false
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.center,
                    children: [
                      cancelPick == false
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary:
                                      const Color.fromRGBO(255, 255, 255, 1),
                                  fixedSize: const Size(134, 35),
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(112, 112, 112, 1)),
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                if (status == "assigned") {
                                  showDialog(
                                      barrierDismissible: false,
                                      barrierColor: Colors.transparent,
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            insetPadding:
                                                EdgeInsets.only(top: 10),
                                            child: StatefulBuilder(
                                              builder: (context, setState) =>
                                                  Stack(
                                                children: <Widget>[
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 120,
                                                      ),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 11,
                                                                  right: 18,
                                                                  top: 16),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons.close),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                        child:
                                                                            Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          height:
                                                                              30,
                                                                          child:
                                                                              Stack(
                                                                            children: const [
                                                                              Align(
                                                                                alignment: AlignmentDirectional(
                                                                                  -1,
                                                                                  0,
                                                                                ),
                                                                                child: Text('Լրացուցիչ տեղեկություն',
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'Poppins',
                                                                                      color: Color.fromRGBO(47, 48, 43, 1),
                                                                                      fontSize: 18,
                                                                                    )),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextField(
                                                                        decoration: InputDecoration(
                                                                            hintText: reason == false
                                                                                ? "Խնդրում ենք նշել չեղարկման պատճառը"
                                                                                : null,
                                                                            hintStyle:
                                                                                TextStyle(fontSize: 11, color: reason == false ? Colors.red : null),
                                                                            filled: true,
                                                                            border: InputBorder.none,
                                                                            fillColor: const Color.fromRGBO(235, 235, 232, 1)),
                                                                        minLines:
                                                                            3,
                                                                        maxLines:
                                                                            5,
                                                                        keyboardType:
                                                                            TextInputType.multiline,
                                                                        cursorRadius:
                                                                            const Radius.circular(10),
                                                                        controller:
                                                                            _controller,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Checkbox(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                                                          // checkColor: Colors.white,
                                                                          fillColor:
                                                                              MaterialStateProperty.resolveWith(getColor),
                                                                          value:
                                                                              isCheckedOne,
                                                                          onChanged:
                                                                              (bool? value) {
                                                                            setState(() {
                                                                              isCheckedOne = value!;
                                                                              if (isCheckedOne == true) {
                                                                                text = clean;
                                                                                isCheckedTwo = false;
                                                                                isChecked = isCheckedOne;
                                                                              }
                                                                            });
                                                                          },
                                                                        ),
                                                                        Text(
                                                                          clean,
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: Color.fromRGBO(0, 0, 0, 1)),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Checkbox(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                                                          // checkColor: Colors.white,
                                                                          fillColor:
                                                                              MaterialStateProperty.resolveWith(getColor),
                                                                          value:
                                                                              isCheckedTwo,
                                                                          onChanged:
                                                                              (bool? value) {
                                                                            setState(() {
                                                                              isCheckedTwo = value!;
                                                                              if (isCheckedTwo == true) {
                                                                                text = dirty;
                                                                                isCheckedOne = false;
                                                                                isChecked = isCheckedTwo;
                                                                              }
                                                                            });
                                                                          },
                                                                        ),
                                                                        Text(
                                                                          dirty,
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: Color.fromRGBO(0, 0, 0, 1)),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 18),
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      primary: const Color
                                                                              .fromRGBO(
                                                                          159,
                                                                          205,
                                                                          79,
                                                                          1),
                                                                      elevation:
                                                                          0,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0)),
                                                                      minimumSize:
                                                                          const Size(
                                                                              135,
                                                                              36), //////// HERE
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      if (_controller
                                                                          .text
                                                                          .isEmpty) {
                                                                        setState(
                                                                            () {
                                                                          reason =
                                                                              false;
                                                                        });
                                                                      } else {
                                                                        _onQRCounterAndReasonButtonPressed(
                                                                            "missed");
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        'Չեղարկել հավաքը',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color: Color.fromRGBO(
                                                                              247,
                                                                              247,
                                                                              247,
                                                                              1),
                                                                          fontSize:
                                                                              15,
                                                                        )),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ));
                                      });
                                } else
                                  Navigator.of(context).pop(MaterialPageRoute(
                                    builder: (contet) => const Home(),
                                  ));
                              },
                              child: const Text(
                                "Չեղարկել",
                                style: TextStyle(
                                    color: Color.fromRGBO(112, 112, 112, 1),
                                    fontSize: 15),
                              ),
                            )
                          : Text(""),
                      pick == false
                          ? Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: pick == false
                                          ? Color.fromRGBO(159, 205, 79, 1)
                                          : pick == true
                                              ? Color.fromRGBO(255, 255, 255, 1)
                                              : null,
                                      fixedSize: const Size(134, 35),
                                      shape: pick == false
                                          ? RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))
                                          : pick == true
                                              ? RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      width: 1,
                                                      color: Color.fromRGBO(
                                                          112, 112, 112, 1)),
                                                  borderRadius:
                                                      BorderRadius.circular(10))
                                              : null),
                                  onPressed: () async {
                                    if (cancelPick == true) {
                                      BlocProvider.of<ConfirmBloc>(context).add(
                                        ConfirmButtonPressed(
                                          pickupId: id,
                                        ),
                                      );
                                    }
                                    if (cancelPick == false) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QRorComment(
                                                id: order[index].pickup_id)),
                                      );
                                    }
                                  },
                                  child: Text(
                                      cancelPick != false
                                          ? "Վերցնել"
                                          : "Ավարտել",
                                      style: TextStyle(
                                          color: pick == false
                                              ? Color.fromRGBO(247, 247, 247, 1)
                                              : pick == true
                                                  ? Color.fromRGBO(
                                                      112, 112, 112, 1)
                                                  : null,
                                          fontSize: 15))),
                            )
                          : Text("")
                    ],
                  )
                : const Text("")
          ],
        ),
      ),
    );
  }
}
