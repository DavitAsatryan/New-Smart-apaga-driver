import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_apaga/Cubit/Internet/cubit/internet_cubit.dart';
import 'package:new_apaga/Enum/internetEnum.dart';
import 'package:new_apaga/bloc/ForgetPassword_Bloc/bloc/forget_password_bloc.dart';
import 'package:new_apaga/notifications/notificationOrder.dart';
import 'package:new_apaga/screens/main_screen.dart';
import 'package:new_apaga/screens/register_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:new_apaga/bloc/ForgetPassword_Bloc/bloc/forget_password_bloc.dart';
import 'package:new_apaga/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import '/bloc/Confirm/bloc/confirm_bloc.dart';
import '/bloc/Login_bloc/login_bloc.dart';
import '/bloc/profileEdit_send/Password_Bloc/bloc/password_change_bloc.dart';
import '/repository.dart';
import 'Forget_Password/forget_password.dart';

class LoginForm extends StatefulWidget {
  final AuthBloc auth;
  final UserRepository userRepository;
  LoginForm({Key? key, required this.userRepository, required this.auth})
      : assert(userRepository != null, auth != null),
        super(key: key);
  @override
  State<LoginForm> createState() => LoginFormState(userRepository);
}

class LoginFormState extends State<LoginForm> {
  bool passwordVisibility = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserRepository userRepository;
  LoginFormState(this.userRepository);
  @override
  void initState() {
    super.initState();

    /// autoLogin();
    /// }
  }

  String textDialog = "Սխալ";

  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController(text: "application");
  bool isChecked = false;
  static bool isLoggedIn = false;
  var maskFormatter = MaskTextInputFormatter(
      mask: '##-###-###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  String hyCode = "374";
  Future<void> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? acc_token = prefs.get("token");

    prefs.setString("token_auth", acc_token!);
  }

  _onLoginButtonPressed() {
    String phone = "$hyCode${maskFormatter.getUnmaskedText()}";
    if (formKey.currentState!.validate()) {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          phoneNumber: phone,
          password: _passwordController.text,
          firebase_token: UserRepository.tokenF,
        ),
      );
      print("${_passwordController.text}:  $phone: ${UserRepository.tokenF} ");
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("app ${UserRepository.exeptionText}");

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return const Color.fromARGB(255, 0, 144, 115);
      }
      return const Color.fromRGBO(12, 128, 64, 1);
    }

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

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is LoginInitial) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return const MainScreen();
            },
          ), (route) => false);
        }
        if (state is LoginFailure) {
          if (UserRepository.exeptionText == "{message: Invalid password}") {
            textDialog = "Սխալ գախտնաբառ:";
          }
          if (UserRepository.exeptionText ==
              "{message: User phone number is not exist in db}") {
            textDialog = "Սխալ հեռախոսահամար:";
          }
          if (UserRepository.exeptionText ==
              "{message: driver is not verified}") {
            textDialog =
                "Հեռախոսահամարն ակտիվ չէ: Խնդրում ենք սպասել մինչ ադմինը կապ կհաստատի ձեզ հետ:";
          }
          showDialog(
              // barrierColor: const Color.fromARGB(218, 226, 222, 211),
              context: context,
              builder: (context) {
                return alert(okButton, textDialog);
              });
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            autovalidateMode: AutovalidateMode.disabled,
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
                        children: [
                          Image.asset(
                            "assets/Frame.png",
                            fit: BoxFit.cover,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: SingleChildScrollView(
                          child: Container(
                            child: Stack(
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: AutofillGroup(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 30),
                                          child: Container(
                                            width: 288,
                                            height: 30,
                                            child: Stack(
                                              children: const [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                    -1,
                                                    0,
                                                  ),
                                                  child: Text('Մուտք գործել',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: Color.fromRGBO(
                                                            127, 127, 127, 1),
                                                        fontSize: 18,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 0, 4),
                                          child: Container(
                                            width: 288,
                                            height: 70,
                                            child: Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 0),
                                              child: TextFormField(
                                                autofillHints: const [
                                                  AutofillHints.username
                                                ],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                                inputFormatters: [
                                                  maskFormatter
                                                ],
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return ConstValid.partadir;
                                                  } else if (value.length <
                                                      10) {
                                                    return ConstValid.tery;
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.phone,
                                                controller:
                                                    _phoneNumberController,
                                                obscureText: false,
                                                decoration:
                                                    const InputDecoration(
                                                  prefixIcon: SizedBox(
                                                    child: Center(
                                                      widthFactor: 0.0,
                                                      heightFactor: 0.0,
                                                      child: Text("+374"),
                                                    ),
                                                  ),
                                                  prefixStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 5, 2, 2),
                                                  ),
                                                  hintText: "Հեռախոսահամար",
                                                  hintStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        169, 169, 169, 1),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide
                                                              .none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  filled: true,
                                                  fillColor: Color.fromRGBO(
                                                      235, 235, 232, 1),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 0, 0),
                                          child: Container(
                                            width: 288,
                                            height: 70,
                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
                                                  child: TextFormField(
                                                    autofillHints: const [
                                                      AutofillHints.password
                                                    ],
                                                    onEditingComplete: () =>
                                                        TextInput
                                                            .finishAutofillContext(),
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          20)
                                                    ],
                                                    
                                                    //maxLengthEnforced: true,
                                                    validator: (value) {
                                                      Pattern password =
                                                          r'[A-Z,a-z,0-9(]{6}';
                                                      RegExp regex = RegExp(
                                                          password.toString());
                                                      if (value!.isEmpty ||
                                                          value.length < 3) {
                                                        return ConstValid
                                                            .minPasswordLenght;
                                                      }
                                                    },
                                                    controller:
                                                        _passwordController,
                                                    obscureText:
                                                        !passwordVisibility,
                                                    decoration: InputDecoration(
                                                      hintText: 'Գաղտնաբառ',
                                                      enabledBorder:
                                                          const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0x00FFFFFF),
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0x00FFFFFF),
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                        ),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          const Color.fromRGBO(
                                                              235, 235, 232, 1),
                                                      suffixIcon: InkWell(
                                                        onTap: () => setState(
                                                          () => passwordVisibility =
                                                              !passwordVisibility,
                                                        ),
                                                        child: Icon(
                                                          passwordVisibility
                                                              ? Icons
                                                                  .visibility_outlined
                                                              : Icons
                                                                  .visibility_off_outlined,
                                                          size: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily: 'Lato',
                                                      color: Color.fromRGBO(
                                                          169, 169, 169, 1),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 0),
                                          child: Container(
                                            width: 288,
                                            height: 37,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                // InkWell(
                                                //   onTap: () async {
                                                //     if (isChecked == true) {
                                                //       setState(() {
                                                //         isChecked = false;
                                                //         isLoggedIn = false;
                                                //       });
                                                //     }
                                                //     if (isChecked == false) {
                                                //       setState(() {
                                                //         isChecked = true;
                                                //         isLoggedIn = true;
                                                //       });
                                                //     }
                                                //   },
                                                //   child: Row(
                                                //     children: [
                                                //       Checkbox(
                                                //         side:
                                                //             MaterialStateBorderSide
                                                //                 .resolveWith(
                                                //                     (states) {
                                                //           if (states.contains(
                                                //               MaterialState
                                                //                   .pressed)) {
                                                //             return const BorderSide(
                                                //                 color: Colors
                                                //                     .black38);
                                                //           } else {
                                                //             return const BorderSide(
                                                //                 width: 1.5,
                                                //                 color: Color
                                                //                     .fromRGBO(
                                                //                         12,
                                                //                         128,
                                                //                         64,
                                                //                         1));
                                                //           }
                                                //         }),
                                                //         shape:
                                                //             RoundedRectangleBorder(
                                                //                 borderRadius:
                                                //                     BorderRadius
                                                //                         .circular(
                                                //                             4)),
                                                //         fillColor:
                                                //             MaterialStateProperty
                                                //                 .all(Colors
                                                //                     .transparent),
                                                //         // activeColor:
                                                //         //     const Color.fromARGB(
                                                //         //         255, 0, 144, 115),
                                                //         checkColor:
                                                //             const Color.fromRGBO(
                                                //                 12, 128, 64, 1),
                                                //         value: isChecked,
                                                //         onChanged: (bool? value) {
                                                //           setState(() {
                                                //             isChecked = value!;
                                                //             isLoggedIn =
                                                //                 isChecked;
                                                //             if (isLoggedIn ==
                                                //                 true) {
                                                //               loginUser();
                                                //             }
                                                //             print(
                                                //                 "login isLoggedIn $isLoggedIn");
                                                //           });
                                                //         },
                                                //       ),
                                                //       const Text("Հիշել",
                                                //           style: TextStyle(
                                                //             fontFamily: 'Poppins',
                                                //             color: Color.fromRGBO(
                                                //                 12, 128, 64, 1),
                                                //             fontSize: 12,
                                                //           )),
                                                //     ],
                                                //   ),
                                                // ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                BlocProvider(
                                                                  create: (context) => ForgetPasswordBloc(
                                                                      authenticationBloc:
                                                                          BlocProvider.of<AuthBloc>(
                                                                              context),
                                                                      userRepository:
                                                                          userRepository),
                                                                  child:
                                                                      const ForgetPassword(),
                                                                )));
                                                  },
                                                  child: const Text(
                                                      "Մոռացե՞լ եք գաղտնաբառը",
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: Color.fromRGBO(
                                                            12, 128, 64, 1),
                                                        fontSize: 12,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 30, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: const Color.fromRGBO(
                                                      12, 128, 64, 1),
                                                  onPrimary: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)),
                                                  minimumSize: const Size(
                                                      160, 40), //////// HERE
                                                ),
                                                onPressed: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  _onLoginButtonPressed();
                                                  // FirebaseMessaging.instance
                                                  //     .getToken()
                                                  //     .then((value) {
                                                  //   print("FCM token");
                                                  //   print(value);
                                                  // });
                                                  // final prefer = await SharedPreferences
                                                  //     .getInstance();
                                                  // prefer.getString('phone');
                                                  // print(prefer.containsKey('phone'));
                                                },
                                                child: const Text(
                                                  'Մուտք',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 81,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              183,
                                                              183,
                                                              183,
                                                              1))),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Text(
                                                "կամ",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        183, 183, 183, 1)),
                                              ),
                                            ),
                                            Container(
                                              width: 81,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              183,
                                                              183,
                                                              183,
                                                              1))),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterScreen(
                                                        userRepository:
                                                            userRepository,
                                                      )),
                                            );
                                          },
                                          child: const Text("Գրանցվել",
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontFamily: 'Poppins',
                                                color: Color.fromRGBO(
                                                    12, 128, 64, 1),
                                                fontSize: 18,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AlertDialog alert(Widget okButton, String text) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actions: [okButton],
        content: Text(text));
  }
}
