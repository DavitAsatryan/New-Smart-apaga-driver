import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/bloc/QRCounterAndReason/bloc/qr_counter_reason_bloc.dart';
import 'package:new_apaga/bloc/QrCodeSend/bloc/qr_send_bloc.dart';
import 'package:new_apaga/repository.dart';
import 'package:new_apaga/screens/QR_code/counterqr.dart';
import 'package:new_apaga/screens/QR_code/qr_code.dart';
import 'package:new_apaga/screens/main_screen.dart';

class QRorComment extends StatefulWidget {
  int id;
  QRorComment({Key? key, required this.id}) : super(key: key);

  @override
  _QRorCommentState createState() => _QRorCommentState(id: id);
}

class _QRorCommentState extends State<QRorComment> {
  int values = 0;
  int id;

  _QRorCommentState({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(12, 128, 64, 50),
      ),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromRGBO(12, 128, 64, 120)),
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 100),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Հավաքը կատարվեց՞",
                    style: TextStyle(fontSize: 22),
                  )),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 1,
                        groupValue: values,
                        onChanged: (value) {
                          setState(() {
                            values = 1;
                          });
                          if (values == 1) {
                            Future.delayed(Duration(seconds: 1)).then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BlocProvider<QrSendBloc>(
                                            create: (context) => QrSendBloc(
                                                authenticationBloc:
                                                    BlocProvider.of<AuthBloc>(
                                                        context),
                                                userRepository:
                                                    UserRepository()),
                                            child: QrCode(
                                              hide: true,
                                              id: id,
                                            ),
                                          )));
                            });
                          }
                        },
                      ),
                      const Text(
                        "Այո",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 2,
                        groupValue: values,
                        onChanged: (value) {
                          setState(() {
                            values = 2;
                          });
                          if (values == 2) {
                            Future.delayed(Duration(seconds: 1)).then((value) {
                              setState(() {
                                values = 0;
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (contet) => BlocProvider(
                                        create: (context) =>
                                            QrCounterReasonBloc(
                                                authenticationBloc:
                                                    BlocProvider.of<AuthBloc>(
                                                        context),
                                                userRepository:
                                                    UserRepository()),
                                        child: CounterQR(
                                          id: id,
                                          counter: 0,
                                          hide: false,
                                        ),
                                      )));
                            });
                          }
                        },
                      ),
                      const Text(
                        "Ոչ",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
