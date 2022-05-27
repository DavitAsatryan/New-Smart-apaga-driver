import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_apaga/Enum/internetEnum.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/bloc/ForgetPassword_Bloc/bloc/forget_password_new_bloc.dart';
import 'package:new_apaga/repository.dart';
import 'package:new_apaga/screens/login_screen.dart';
import 'forget_password_pincode.dart';

class ForgetPasswordNew extends StatefulWidget {
  String phoneNumber;
  ForgetPasswordNew({Key? key, required this.phoneNumber}) : super(key: key);
  @override
  _ForgetPasswordState createState() =>
      _ForgetPasswordState(phoneNumber: phoneNumber);
}

class _ForgetPasswordState extends State<ForgetPasswordNew> {
  String phoneNumber;
  _ForgetPasswordState({required this.phoneNumber});
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool passwordVisibility = false;
  bool passwordVisibilityTwo = false;
  bool colorBool = false;
  bool c = false;
  String textDialog = "Սխալ";
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _onPasswordNewButtonPressed(String password) {
      print("validate");
      BlocProvider.of<ForgetPasswordNewBloc>(context).add(
        ButtonForgetPasswordNew(
            phoneNumber: phoneNumber, passwordText: password),
      );
    }

    return BlocListener<ForgetPasswordNewBloc, ForgetPasswordNewState>(
        listener: (context, state) {
      Widget okButton = TextButton(
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: const BoxDecoration(
              border: Border(
            top: BorderSide(
                width: 1.0, color: Color.fromARGB(255, 229, 238, 243)),
          )),
          child: const Center(
            child: Text(
              "",
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
      if (state is ForgetPasswordNewLoading) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return LoginScreen(
              userRepository: UserRepository(),
              auth: BlocProvider.of<AuthBloc>(context),
            );
          },
        ), (route) => false);
      } else if (state is ForgetPasswordNewFailure) {
        showDialog(
            // barrierColor: const Color.fromARGB(218, 226, 222, 211),
            context: context,
            builder: (context) {
              return alert(okButton, textDialog);
            });
      }
    }, child: BlocBuilder<ForgetPasswordNewBloc, ForgetPasswordNewState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: formKey,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              key: scaffoldKey,
              backgroundColor: const Color(0xFFF5F5F5),
              body: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Stack(
                          children: [Image.asset("assets/Frame.png")],
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
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
                                        child: Text('Նոր գաղտնաբառ',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color:
                                                  Color.fromRGBO(47, 48, 43, 1),
                                              fontSize: 22,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 30, 0, 0),
                                child: Container(
                                  width: 288,
                                  height: 60,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(0, 0),
                                        child: TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(20)
                                          ],
                                          validator: (value) {
                                            Pattern password =
                                                r'[A-Z,a-z,0-9()]{6}';
                                            RegExp regex =
                                                RegExp(password.toString());
                                            if (value!.isEmpty) {
                                              return ConstValid.partadir;
                                            } else if (!regex.hasMatch(value)) {
                                              return ConstValid
                                                  .minPasswordLenght;
                                            }
                                          },
                                          controller: _passwordController,
                                          obscureText: !passwordVisibility,
                                          decoration: InputDecoration(
                                            hintText: 'Նոր գաղտնաբառ',
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    235, 235, 232, 1),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00FFFFFF),
                                                width: 2,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFFEBECE7),
                                            suffixIcon: InkWell(
                                              onTap: () => setState(
                                                () => passwordVisibility =
                                                    !passwordVisibility,
                                              ),
                                              child: Icon(
                                                passwordVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            color: Color.fromRGBO(
                                                183, 183, 183, 1),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 47, 0, 0),
                                child: Container(
                                  width: 214,
                                  height: 40,
                                  child: Stack(
                                    children: [
                                      Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color.fromRGBO(
                                                  12, 128, 64, 1),
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              minimumSize: const Size(
                                                  214, 40), //////// HERE
                                            ),
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                _onPasswordNewButtonPressed(
                                                  _passwordController.text,
                                                );
                                              } else {
                                                null;
                                              }
                                              // if (state
                                              //     is ButtonPhoneNumber) {
                                              //   Navigator.of(context).push(
                                              //       MaterialPageRoute(
                                              //           builder:
                                              //               (context) =>
                                              //                   BlocProvider(
                                              //                     create: (context) => PincodeForgetPassBloc(
                                              //                         authenticationBloc:
                                              //                             BlocProvider.of<AuthBloc>(context),
                                              //                         userRepository: UserRepository()),
                                              //                     child:
                                              //                         ForgetPasswordPinCode(),
                                              //                   )));
                                              // }
                                            },
                                            child: const Text(
                                              'Հաստատել',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      240, 240, 240, 1)),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(169, 169, 169, 1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 10, top: 4),
                      child: Text(
                        "Terms of Use",
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(65, 132, 130, 1)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(65, 132, 130, 1)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ));
  }

  AlertDialog alert(Widget okButton, String text) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      actions: [okButton],
      content: Text(
        text,
      ),
    );
  }
}
