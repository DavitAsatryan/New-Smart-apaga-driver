import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_apaga/bloc/QRCounterAndReason/bloc/qr_counter_reason_bloc.dart';
import 'package:new_apaga/screens/main_screen.dart';
import 'package:new_apaga/showdIalogs.dart';

class CounterQR extends StatefulWidget {
  int counter;
  bool hide;
  int id;
  CounterQR(
      {Key? key, required this.counter, required this.id, required this.hide})
      : super(key: key);
  @override
  _CounterQRState createState() =>
      _CounterQRState(counter: counter, id: id, hide: hide);
}

class _CounterQRState extends State<CounterQR> {
  _CounterQRState(
      {required this.counter, required this.id, required this.hide});
  int id;
  bool hide;
  int counter;
  String dirty = "Թափոնը մաքուր չէր";
  String clean = "Թափոնը մաքուր էր";
  String text = "";
  TextEditingController _controller = TextEditingController();
  _onQRCounterAndReasonButtonPressed(String status) {
    print(" heyyy   ${_controller.text} $id  $text");
    BlocProvider.of<QrCounterReasonBloc>(context).add(
        QrCounterReasonButtonPressed(
            pickup_id: id,
            comment_driver: "${_controller.text} $text",
            status: "$status"));
  }

  bool isCheckedOne = false;
  bool isCheckedTwo = false;
  bool isChecked = false;
  bool? reason;
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      return const Color.fromRGBO(12, 128, 64, 1);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(12, 128, 64, 1),
        ),
        resizeToAvoidBottomInset: false,
        body: BlocListener<QrCounterReasonBloc, QrCounterReasonState>(
          listener: (context, state) {
            if (state is QrCounterReasonFailure) {
            ShowDialogs().showFailure(context);
            }
            if (state is QrCounterReasonInitial) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return const MainScreen();
                },
              ), (route) => false);
            }
          },
          child: BlocBuilder<QrCounterReasonBloc, QrCounterReasonState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1)),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1)),
                        child: Column(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 120,
                                ),
                                child: Row(
                                  verticalDirection: VerticalDirection.down,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icon/QR.svg",
                                      height: 91,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 27),
                                      child: Text(
                                        "$counter",
                                        style: const TextStyle(fontSize: 58),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 35, bottom: 35),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 10),
                                    child: Container(
                                      width: 288,
                                      height: 29,
                                      child: Stack(
                                        children: const [
                                          Align(
                                            alignment: AlignmentDirectional(
                                              -1,
                                              0,
                                            ),
                                            child:
                                                Text('Լրացուցիչ տեղեկություն',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Color.fromRGBO(
                                                          47, 48, 43, 1),
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
                                        hintStyle: TextStyle(
                                            fontSize: 11,
                                            color: reason == false
                                                ? Colors.red
                                                : null),
                                        filled: true,
                                        border: InputBorder.none,
                                        fillColor:
                                            Color.fromRGBO(235, 235, 232, 1)),
                                    minLines: 3,
                                    maxLines: 5,
                                    keyboardType: TextInputType.multiline,
                                    cursorRadius: const Radius.circular(10),
                                    controller: _controller,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      // checkColor: Colors.white,
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              getColor),
                                      value: isCheckedOne,
                                      onChanged: (bool? value) {
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
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      // checkColor: Colors.white,
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              getColor),
                                      value: isCheckedTwo,
                                      onChanged: (bool? value) {
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
                              padding: const EdgeInsets.only(top: 39),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  hide == false
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            side: const BorderSide(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    112, 112, 112, 1)),
                                            primary: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            minimumSize:
                                                Size(135, 36), //////// HERE
                                          ),
                                          onPressed: () {
                                            if (_controller.text.isEmpty) {
                                              setState(() {
                                                reason = false;
                                              });
                                            } else if (_controller
                                                .text.isNotEmpty) {
                                              setState(() {
                                                _onQRCounterAndReasonButtonPressed(
                                                    "incomplete");
                                                reason = true;
                                              });
                                            }
                                          },
                                          child: const Text('Չեղարկել հավաքը',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Color.fromRGBO(
                                                    112, 112, 112, 1),
                                                fontSize: 15,
                                              )),
                                        )
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Color.fromRGBO(159, 205, 79, 1),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            minimumSize:
                                                Size(135, 36), //////// HERE
                                          ),
                                          onPressed: () {
                                            _onQRCounterAndReasonButtonPressed(
                                                "completed");
                                          },
                                          child: const Text('Ավարտել',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Color.fromRGBO(
                                                    247, 247, 247, 1),
                                                fontSize: 15,
                                              )),
                                        ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
