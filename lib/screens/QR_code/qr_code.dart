import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:new_apaga/Enum/internetEnum.dart';
import 'package:new_apaga/bloc/QRCounterAndReason/bloc/qr_counter_reason_bloc.dart';
import 'package:new_apaga/bloc/QrCodeSend/bloc/qr_send_bloc.dart';
import 'package:new_apaga/repository.dart';
import 'package:new_apaga/showdIalogs.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../bloc/Auth_Bloc/bloc/auth_bloc.dart';
import '../Menu/Home/home.dart';
import 'counterqr.dart';

class QrCode extends StatefulWidget {
  int id;
  bool hide;
  QrCode({Key? key, required this.id, required this.hide}) : super(key: key);
  @override
  _QrCodeState createState() => _QrCodeState(id: id, hide: hide);
}

class _QrCodeState extends State<QrCode> {
  int id;
  bool hide;
  String textDialog = "Սխալ";
  _QrCodeState({required this.id, required this.hide});
  final qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  Barcode? barcode;
  bool hideChack = true;
  int counter = 0;
  List<String> resultList = [];
  bool iconChange = false;
  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    try {
      if (Platform.isAndroid) {
        await controller?.pauseCamera();
      } else if (Platform.isIOS) {
        await controller?.resumeCamera();
      }
      controller?.resumeCamera();
    } catch (e) {
      print("error try");
    }
  }

  _onQrCodeSendButtonPressed(String barCode) {
    if (resultList.length > 1) {
      setState(() {
        iconChange = true;
      });
    }
    BlocProvider.of<QrSendBloc>(context).add(
      QrSendButtonPressed(qrSendCode: barCode, id: id),
    );
    print(" ___________________------------------------- $barCode $id");
  }

  @override
  Widget build(BuildContext context) {
    Widget okButton = TextButton(
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: const BoxDecoration(
            border: Border(
          top:
              BorderSide(width: 1.0, color: Color.fromARGB(255, 229, 238, 243)),
        )),
        child: const Center(
          child: Text(
            "Լավ",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color.fromARGB(202, 150, 179, 47),
              fontSize: 15,
            ),
          ),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alerts = alert(okButton, textDialog);
    return BlocListener<QrSendBloc, QrSendState>(
      listener: (context, state) {
        if (state is QrSendLoading) {
          Container(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is QrSendFailure) {
          print(state.error);
          counter--;
          print(UserRepository.exeptionText);
          if (UserRepository.exeptionText ==
              '{message: bag is not collected maybe it already collected}') {
            textDialog = 'Այն արդեն վերցված է';
          } else {
            textDialog = 'Նորից փորձեք';
          }

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return alert(okButton, textDialog);
              }).then((value) => null);
          // ShowDialogs().showFailure(context).then((value) => null);
        }
        if (state is QrSendInitial) {
          for (var i = 0; i < resultList.length; i++) {
            if (barcode!.code.toString() != resultList[i]) {
              resultList.add(barcode!.code.toString());
            } else {
              return null;
            }
          }

          ShowDialogs().show(context, false).then((value) => null);
        }
      },
      child: BlocBuilder<QrSendBloc, QrSendState>(
        builder: (context, state) {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(12, 128, 64, 1),
            ),
            body: Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(232, 232, 232, 1)),
              child: Center(
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 100, bottom: 19),
                    child: Text(
                      "Qr  code  scan",
                      style: TextStyle(
                        fontSize: 22,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ),
                  Container(
                    height: 288,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          hideChack != false
                              ? buildQrCode(context)
                              : const Text(""),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ButtonScanQR(),
                        ButtonSendQR(),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ));
        },
      ),
    );
  }

  // Widget buildResult() => Container(
  //       padding: EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //           color: Colors.white12, borderRadius: BorderRadius.circular(8)),
  //       child: Text(
  //         barcode != null ? "Result: ${sum}" : "Scan Code",
  //         maxLines: 10,
  //       ),
  //     );
  Widget ButtonSendQR() => IconButton(
      onPressed: () {
        if (resultList.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (contet) => BlocProvider(
              create: (context) => QrCounterReasonBloc(
                  authenticationBloc: BlocProvider.of<AuthBloc>(context),
                  userRepository: UserRepository()),
              child: CounterQR(
                hide: hide,
                id: id,
                counter: counter,
              ),
            ),
          ));
        } else {
          return null;
        }
      }, //sendQrCode("123", context),
      icon: iconChange == false
          ? SvgPicture.asset(
              "assets/icon/next.svg",
              height: 35,
            )
          : SvgPicture.asset(
              "assets/icon/arrow.svg",
              height: 35,
            ));
  Widget ButtonScanQR() => IconButton(
      onPressed: () {
        setState(() {
          if (hideChack == false) {
            hideChack = true;
          } else if (hideChack == true) {
            hideChack = false;
          }
        });
      },
      icon: SvgPicture.asset(
        "assets/icon/+.svg",
        height: 35,
      ));
  Widget buildQrCode(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Color.fromRGBO(112, 112, 112, 1),
          borderRadius: 0,
          borderLength: 19,
          borderWidth: 2,
          cutOutSize: MediaQuery.of(context).size.width * 0.7,
        ),
      );
  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((event) async => setState(() {
          barcode = event;
          setState(() {
            if (barcode!.code!.isNotEmpty || barcode!.code != null) {
              controller.pauseCamera();
              _onQrCodeSendButtonPressed(barcode!.code.toString());
              hideChack = false;
              iconChange = true;
              counter++;
            }
          });
        }));
    setState(() => this.controller = controller);
  }

  AlertDialog alert(Widget okButton, String text) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actions: [okButton],
        content: Text(
          textDialog,
        ));
  }
}
