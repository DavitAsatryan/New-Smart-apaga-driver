import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_apaga/Enum/internetEnum.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/screens/login_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
//import 'package:new_apaga/screens/Menu/drawerMenu.dart';
import '../bloc/Register_bloc/register_bloc.dart';
import '../repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';

class RegisterForm extends StatefulWidget {
  final UserRepository userRepository;
  const RegisterForm({Key? key, required this.userRepository})
      : super(key: key);
  @override
  State<RegisterForm> createState() => _RegisterFormState(userRepository);
}

class _RegisterFormState extends State<RegisterForm> {
  final UserRepository userRepository;
  _RegisterFormState(this.userRepository);

  var maskForCarNumber = MaskTextInputFormatter(
      mask: '##-AA-###',
      filter: {"A": RegExp(r'[A-Z]'), "#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  final _fullNameController = TextEditingController(text: "Davit Asatryan");
  final _phoneNumberController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _carNameController = TextEditingController(text: "Nissan");
  final _carColorController = TextEditingController(text: "Sev");
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool sendBoolData = false;
  bool passwordVisibility = false;
  bool isCheckedOne = false;
  bool isCheckedTwo = false;
  bool isCheckedThree = false;
  bool isCheckedFour = false;
  bool borderContainer = false;
  final scrollCOntroller = ScrollController();
  double valueScroll = 580;
  int _valueRadio = 0;
  int countBorder = 0;
  String capacity = '';
  String text =
      "ՇնորհակալությունՁեր դիմումը  ընդունվել է։  Մենք  ձեզ հետ կապ կհաստատենք 2  աշխատանքային օրվա ընթացքում։";
  String textInvalid = "Սխալ";
  bool toLoginScreen = false;
  var maskFormatter = MaskTextInputFormatter(
      mask: '##-###-###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  String hyCode = "374";
  FocusNode fullName = FocusNode();
  final Uri _url = Uri.parse('https://flutter.dev');
  void _launchUrl() async {
    if (!await launch("$_url")) throw 'Ձախողում $_url';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fullName.dispose();
  }

  void scrollUp(double value) {
    scrollCOntroller.animateTo(value,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
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
        if (toLoginScreen == true) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return LoginScreen(
                userRepository: UserRepository(),
                auth: BlocProvider.of<AuthBloc>(context),
              );
            },
          ), (route) => false);
        } else {
          Navigator.pop(context);
        }
      },
    );
    AlertDialog alert = alertDialogMetod(okButton, text);
    _onLoginButtonPressed() {
      String phone = "$hyCode${maskFormatter.getUnmaskedText()}";
      print(phone);
      String carNumber = maskForCarNumber.getUnmaskedText();
      print(carNumber);
      if (formKey.currentState!.validate() && sendBoolData == true) {
        BlocProvider.of<RegisterBloc>(context).add(RegisternButtonPressed(
          fullname: _fullNameController.text,
          phoneNumber: phone,
          carNumber: carNumber,
          carName: _carNameController.text,
          carColor: _carColorController.text,
          carCapacity: capacity,
          password: _passwordController.text,
          firebase_token: UserRepository.tokenF,
        ));
        print(
            "${_fullNameController.text} : $phone : ${_carNumberController.text} : ${_carNameController.text} : ${_carColorController.text} : $capacity : ${_passwordController.text}  : ${UserRepository.tokenF}");
      } else {
        if (_fullNameController.value.composing.isValid ||
            _phoneNumberController.value.composing.isValid) {
        } else {
          setState(() {
            valueScroll = 580;
          });
        }

        if (_carNumberController.value.composing.isValid ||
            _carNameController.value.composing.isValid ||
            _carColorController.value.composing.isValid) {
        } else {
          setState(() {
            valueScroll = 350;
          });
        }

        scrollUp(valueScroll);
        // return null;
      }
    }

    setState(() {
      if (_valueRadio == 1) {
        capacity = '100';
        // isCheckedTwo = false;
        // isCheckedThree = false;
        // isCheckedFour = false;
        sendBoolData = true;
        borderContainer = false;
      } else if (_valueRadio == 2) {
        capacity = '300';
        isCheckedTwo = true;
        // isCheckedOne = false;
        // isCheckedThree = false;
        // isCheckedFour = false;
        sendBoolData = true;
        borderContainer = false;
      } else if (_valueRadio == 3) {
        capacity = '500';
        // isCheckedOne = false;
        // isCheckedTwo = false;
        // isCheckedFour = false;
        sendBoolData = true;
        borderContainer = false;
      } else if (_valueRadio == 4) {
        capacity = '800';
        // isCheckedOne = false;
        // isCheckedTwo = false;
        // isCheckedThree = false;
        sendBoolData = true;
        borderContainer = false;
      } else {
        capacity = '';
        sendBoolData = false;
        if (sendBoolData == false && countBorder > 0) {
          borderContainer = true;
        }
      }
      if (sendBoolData == true) {
        countBorder++;
      }
    });
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterInitial) {
          toLoginScreen = true;
          showDialog(
              barrierColor: const Color.fromRGBO(85, 82, 75, 1),
              context: context,
              builder: (context) {
                return alertDialogMetod(okButton, text);
              });
        }
        if (state is RegisterFailure) {
          String textError = UserRepository.exeptionText;
          print("app ${UserRepository.exeptionText}");
          if (textError == "{message: Phone number already exist on db}") {
            textInvalid = "Հեռախոսահամարն արդեն գրանցված է";
          } else if (textError == "{message: license plate already exist}") {
            textInvalid = "Մեքենաի համարն արդեն գրանցված է";
          }
          showDialog(
              barrierColor: const Color.fromARGB(85, 82, 75, 1),
              context: context,
              builder: (context) {
                return alertDialogMetod(okButton, textInvalid);
              });
        }
        //  if (state is ) {
        //   Scaffold.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text("Register failed."),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        // }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          Color getColor(Set<MaterialState> states) {
            const Set<MaterialState> interactiveStates = <MaterialState>{
              //  MaterialState.pressed,
              //MaterialState.hovered,
              //MaterialState.focused,Text
              MaterialState.selected
            };
            // if (states.any(interactiveStates.contains)) {
            //   return Color.fromARGB(0, 217, 31, 31);
            // }
            return const Color(0xFFA7A7A7);
          }

          return SingleChildScrollView(
            reverse: true,
            controller: scrollCOntroller,
            child: Container(
              width: double.infinity,
              // height: double.infinity,
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: formKey,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          "assets/Forgot1.png",
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                    Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 75),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 20, 0, 0),
                                  child: Container(
                                    width: 288,
                                    height: 50,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: const AlignmentDirectional(
                                            1,
                                            0,
                                          ),
                                          child: TextButton(
                                            child: const Text(
                                              "Մուտք",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Color.fromRGBO(
                                                    12, 128, 64, 1),
                                                fontSize: 18,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationThickness: 2.5,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context, MaterialPageRoute(
                                                builder: (context) {
                                                  return LoginScreen(
                                                    userRepository:
                                                        UserRepository(),
                                                    auth: BlocProvider.of<
                                                        AuthBloc>(context),
                                                  );
                                                },
                                              ), (route) => false);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 24),
                                  child: Container(
                                    width: 288,
                                    height: 40,
                                    child: Stack(
                                      children: const [
                                        Align(
                                          alignment: AlignmentDirectional(
                                            -1,
                                            0,
                                          ),
                                          child: Text('Գրանցվել',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Color.fromRGBO(
                                                    47, 48, 43, 1),
                                                fontSize: 22,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 24),
                                  child: Container(
                                    width: 288,
                                    height: 40,
                                    child: Stack(
                                      children: [
                                        Align(
                                            alignment:
                                                const AlignmentDirectional(
                                              -1,
                                              0,
                                            ),
                                            child: TextButton(
                                              onPressed: _launchUrl,
                                              child: const Text(
                                                  "Առաջարկվող պայմանները",
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Color.fromRGBO(
                                                          65, 132, 130, 1))),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 24),
                                  child: Container(
                                    width: 288,
                                    height: 40,
                                    child: Stack(
                                      children: const [
                                        Align(
                                          alignment: AlignmentDirectional(
                                            -1,
                                            0,
                                          ),
                                          child: Text('Անձնական տվյալներ',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontSize: 18,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 10),
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
                                              LengthLimitingTextInputFormatter(
                                                  30)
                                            ],
                                            validator: (value) {
                                              Pattern pattern =
                                                  r"^(?:[ա-ֆԱ-Ֆա-ֆԱ-Ֆ\w+а-яА-Яа-яА-Яa-zA-Z]{3,} [ա-ֆԱ-Ֆա-ֆԱ-Ֆ\w+а-яА-Яа-яА-Яa-zA-Za-zA-Z]{1,}){0,1}$";
                                              RegExp regex =
                                                  RegExp(pattern.toString());
                                              if (value!.isEmpty) {
                                                return ConstValid.partadir;
                                              } else if (!regex
                                                  .hasMatch(value)) {
                                                return ConstValid.tery;
                                              }
                                            },
                                            style: const TextStyle(
                                              fontFamily: 'Lato',
                                              //color:
                                              fontSize: 16,
                                            ),
                                            controller: _fullNameController,
                                            obscureText: false,
                                            focusNode: fullName,
                                            decoration: const InputDecoration(
                                              hintText: 'Անուն Ազգանուն',
                                              hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    169, 169, 169, 1),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00FFFFFF),
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              focusedBorder: InputBorder.none,
                                              filled: true,
                                              fillColor: Color.fromRGBO(
                                                  235, 235, 232, 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 0, 4),
                                  child: Container(
                                    width: 288,
                                    height: 70,
                                    child: Align(
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                      child: TextFormField(
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                        inputFormatters: [maskFormatter],
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return ConstValid.partadir;
                                          } else if (value.length < 10) {
                                            return ConstValid.tery;
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.phone,
                                        controller: _phoneNumberController,
                                        obscureText: false,
                                        decoration: const InputDecoration(
                                          prefixIcon: SizedBox(
                                            child: Center(
                                              widthFactor: 0.0,
                                              heightFactor: 0.0,
                                              child: Text("+374"),
                                            ),
                                          ),
                                          prefixStyle: TextStyle(
                                            color: Color.fromARGB(255, 5, 2, 2),
                                          ),
                                          hintText: "Հեռախոսահամար",
                                          hintStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                169, 169, 169, 1),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00FFFFFF),
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          focusedBorder: InputBorder.none,
                                          filled: true,
                                          fillColor:
                                              Color.fromRGBO(235, 235, 232, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 24),
                                  child: Container(
                                    width: 288,
                                    height: 50,
                                    child: Stack(
                                      children: const [
                                        Align(
                                          alignment: AlignmentDirectional(
                                            -1,
                                            0,
                                          ),
                                          child: Text('Մեքենայի տվյալներ',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontSize: 18,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 20),
                                  child: Container(
                                    width: 288,
                                    height: 60,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: TextFormField(
                                            inputFormatters: [maskForCarNumber],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Մուտքագրեք սկզբի 2 թվերը";
                                              }
                                              if (value.length <= 1) {
                                                return "Մուտքագրեք սկզբի 2 թվերը";
                                              }
                                              if (value.length > 1 &&
                                                  value.length < 5) {
                                                TextCapitalization.characters;
                                                return "Մուտքագրեք համարանիշի տառերը";
                                              }
                                              if (value.length > 4 &&
                                                  value.length <= 8) {
                                                return "Մուտքագրեք վերջի 3 թվերը";
                                              }
                                              return null;
                                            },
                                            controller: _carNumberController,
                                            obscureText: false,
                                            decoration: const InputDecoration(
                                              hintText: 'Մեքենայի  համարանիշ',
                                              hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    169, 169, 169, 1),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00FFFFFF),
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              focusedBorder: InputBorder.none,
                                              filled: true,
                                              fillColor: Color.fromRGBO(
                                                  235, 235, 232, 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 20),
                                  child: Container(
                                    width: 288,
                                    height: 60,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: TextFormField(
                                            maxLengthEnforced: true,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  20)
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  value.length < 2) {
                                                return ConstValid.partadir;
                                              }
                                            },
                                            style: const TextStyle(
                                              fontFamily: 'Lato',
                                              // color: Color.fromRGBO(
                                              //     169, 169, 169, 1),
                                              fontSize: 16,
                                            ),
                                            controller: _carNameController,
                                            obscureText: false,
                                            decoration: const InputDecoration(
                                              hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    169, 169, 169, 1),
                                              ),
                                              hintText: "Մեքենայի մակնիշը",
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00FFFFFF),
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              focusedBorder: InputBorder.none,
                                              filled: true,
                                              fillColor: Color.fromRGBO(
                                                  235, 235, 232, 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 20),
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
                                              LengthLimitingTextInputFormatter(
                                                  15)
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  value.length < 2) {
                                                return ConstValid.partadir;
                                              }
                                            },
                                            style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                            ),
                                            controller: _carColorController,
                                            obscureText: false,
                                            decoration: const InputDecoration(
                                              hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    169, 169, 169, 1),
                                              ),
                                              hintText: 'Մեքենայի գույնը',
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      235, 235, 232, 1),
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              focusedBorder: InputBorder.none,
                                              filled: true,
                                              fillColor: Color(0xFFEBECE7),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //dddd
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 30),
                                  child: Container(
                                    width: 288,
                                    height: 242,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(-1, 0),
                                          child: Container(
                                            width: 310,
                                            decoration: BoxDecoration(
                                                border: Border.fromBorderSide(
                                                    BorderSide(
                                                        width: 0.5,
                                                        color: borderContainer ==
                                                                true
                                                            ? const Color.fromRGBO(
                                                                255, 0, 0, 1)
                                                            : const Color
                                                                    .fromRGBO(
                                                                235,
                                                                235,
                                                                232,
                                                                1))),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: const Color.fromRGBO(
                                                    235, 235, 232, 1)),
                                            height: 400,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 11, 0, 0),
                                                  child: Container(
                                                    width: 288,
                                                    height: 20,
                                                    child: Stack(
                                                      children: const [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                            -1,
                                                            0,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 11),
                                                            child: Text(
                                                                'Մեքենայի տարողությունը',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          1),
                                                                  fontSize: 16,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 22, 0, 0),
                                                  child: Container(
                                                    width: 310,
                                                    height: 20,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, 0),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    0, 0, 0, 0),
                                                            child: Container(
                                                              width: 288,
                                                              height: 20,
                                                              child: Stack(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                    child: Row(
                                                                      children: [
                                                                        Theme(
                                                                          data:
                                                                              Theme.of(context).copyWith(
                                                                            unselectedWidgetColor: const Color.fromRGBO(
                                                                                167,
                                                                                166,
                                                                                166,
                                                                                1),
                                                                          ),
                                                                          child:
                                                                              Radio(
                                                                            activeColor: const Color.fromRGBO(
                                                                                12,
                                                                                128,
                                                                                64,
                                                                                1),
                                                                            value:
                                                                                1,
                                                                            groupValue:
                                                                                _valueRadio,
                                                                            onChanged:
                                                                                (int? value) {
                                                                              setState(() {
                                                                                _valueRadio = value!;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              _valueRadio = 1;
                                                                            });
                                                                          },
                                                                          child: const Text(
                                                                              "100 - 300",
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins',
                                                                                color: Color.fromRGBO(167, 166, 166, 1),
                                                                                fontSize: 16,
                                                                              )),
                                                                        ),
                                                                      ],
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 27, 0, 0),
                                                  child: Container(
                                                    width: 310,
                                                    height: 20,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, 0),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    0, 0, 0, 0),
                                                            child: Container(
                                                              width: 288,
                                                              height: 20,
                                                              child: Stack(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                    child: Row(
                                                                      children: [
                                                                        Theme(
                                                                          data:
                                                                              Theme.of(context).copyWith(
                                                                            unselectedWidgetColor: const Color.fromRGBO(
                                                                                167,
                                                                                166,
                                                                                166,
                                                                                1),
                                                                          ),
                                                                          child:
                                                                              Radio(
                                                                            activeColor: const Color.fromRGBO(
                                                                                12,
                                                                                128,
                                                                                64,
                                                                                1),
                                                                            value:
                                                                                2,
                                                                            groupValue:
                                                                                _valueRadio,
                                                                            onChanged:
                                                                                (int? value) {
                                                                              setState(() {
                                                                                _valueRadio = value!;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              _valueRadio = 2;
                                                                            });
                                                                          },
                                                                          child: const Text(
                                                                              "300 - 500",
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins',
                                                                                color: Color.fromRGBO(167, 166, 166, 1),
                                                                                fontSize: 16,
                                                                              )),
                                                                        ),
                                                                      ],
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 27, 0, 0),
                                                  child: Container(
                                                    width: 288,
                                                    height: 20,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, 0),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    0, 0, 0, 0),
                                                            child: Container(
                                                              width: 288,
                                                              height: 20,
                                                              child: Stack(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                    child: Row(
                                                                      children: [
                                                                        Theme(
                                                                          data:
                                                                              Theme.of(context).copyWith(
                                                                            unselectedWidgetColor: const Color.fromRGBO(
                                                                                167,
                                                                                166,
                                                                                166,
                                                                                1),
                                                                          ),
                                                                          child:
                                                                              Radio(
                                                                            activeColor: const Color.fromRGBO(
                                                                                12,
                                                                                128,
                                                                                64,
                                                                                1),
                                                                            value:
                                                                                3,
                                                                            groupValue:
                                                                                _valueRadio,
                                                                            onChanged:
                                                                                (int? value) {
                                                                              setState(() {
                                                                                _valueRadio = value!;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              _valueRadio = 3;
                                                                            });
                                                                          },
                                                                          child: const Text(
                                                                              "500 - 800",
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins',
                                                                                color: Color.fromRGBO(167, 166, 166, 1),
                                                                                fontSize: 16,
                                                                              )),
                                                                        ),
                                                                      ],
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 27, 0, 0),
                                                  child: Container(
                                                    width: 288,
                                                    height: 20,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, 0),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    0, 0, 0, 0),
                                                            child: Container(
                                                              width: 288,
                                                              height: 20,
                                                              child: Stack(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                    child: Row(
                                                                      children: [
                                                                        Theme(
                                                                          data:
                                                                              Theme.of(context).copyWith(
                                                                            unselectedWidgetColor: const Color.fromRGBO(
                                                                                167,
                                                                                166,
                                                                                166,
                                                                                1),
                                                                          ),
                                                                          child:
                                                                              Radio(
                                                                            activeColor: const Color.fromRGBO(
                                                                                12,
                                                                                128,
                                                                                64,
                                                                                1),
                                                                            value:
                                                                                4,
                                                                            groupValue:
                                                                                _valueRadio,
                                                                            onChanged:
                                                                                (int? value) {
                                                                              setState(() {
                                                                                _valueRadio = value!;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              _valueRadio = 4;
                                                                            });
                                                                          },
                                                                          child: const Text(
                                                                              "800 և ավել",
                                                                              style: TextStyle(
                                                                                fontFamily: 'Poppins',
                                                                                color: Color.fromRGBO(167, 166, 166, 1),
                                                                                fontSize: 16,
                                                                              )),
                                                                        ),
                                                                      ],
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
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 24),
                                  child: Container(
                                    width: 288,
                                    height: 26,
                                    child: Stack(
                                      children: const [
                                        Align(
                                          alignment: AlignmentDirectional(
                                            -1,
                                            0,
                                          ),
                                          child: Text('Գաղտնաբառ',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontSize: 18,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
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
                                              LengthLimitingTextInputFormatter(
                                                  20)
                                            ],
                                            maxLengthEnforced: true,
                                            validator: (value) {
                                              Pattern password =
                                                  r'[A-Z,a-z,0-9(]{6}';
                                              RegExp regex =
                                                  RegExp(password.toString());
                                              if (value!.isEmpty) {
                                                return ConstValid.partadir;
                                              } else if (!regex
                                                  .hasMatch(value)) {
                                                return ConstValid
                                                    .minPasswordLenght;
                                              }
                                            },
                                            controller: _passwordController,
                                            obscureText: !passwordVisibility,
                                            decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    169, 169, 169, 1),
                                              ),
                                              hintText: 'Գաղտնաբառ',
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
                                              fillColor:
                                                  const Color(0xFFEBECE7),
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
                                              color: Color(0xFF757575),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 30, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              Color.fromRGBO(12, 128, 64, 1),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          minimumSize:
                                              Size(242, 40), //////// HERE
                                        ),
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          if (sendBoolData == false) {
                                            setState(() {
                                              borderContainer = true;
                                            });
                                          } else {
                                            setState(() {
                                              borderContainer = false;
                                            });
                                          }
                                          _onLoginButtonPressed();
                                        },
                                        child: const Text('ՈՒղարկել դիմում',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              fontSize: 16,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Container(
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
                                        padding:
                                            EdgeInsets.only(right: 10, top: 4),
                                        child: Text(
                                          "Terms of Use",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color.fromRGBO(
                                                  65, 132, 130, 1)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Text(
                                          "Privacy Policy",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color.fromRGBO(
                                                  65, 132, 130, 1)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )))
                  ],
                ),
              ),
            ),
          );
          // return Padding(
          //   padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 80.0),
          //   child: Form(
          //     child: Column(
          //       children: [
          //         Container(
          //             height: 200.0,
          //             padding: EdgeInsets.only(bottom: 20.0, top: 40.0),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Text(
          //                   "Registration",
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold, fontSize: 24.0),
          //                 ),
          //                 SizedBox(
          //                   height: 5.0,
          //                 ),
          //               ],
          //             )),
          //         TextFormField(
          //           style:
          //               TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          //           controller: _fullNameController,
          //           decoration: InputDecoration(
          //             enabledBorder: OutlineInputBorder(
          //                 borderSide: new BorderSide(color: Colors.black12),
          //                 borderRadius: BorderRadius.circular(30.0)),
          //             focusedBorder: OutlineInputBorder(
          //                 borderSide: new BorderSide(color: Colors.black),
          //                 borderRadius: BorderRadius.circular(30.0)),
          //             contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
          //             labelText: "Full Name",
          //             hintStyle: TextStyle(
          //                 fontSize: 12.0, fontWeight: FontWeight.w500),
          //             labelStyle: TextStyle(
          //                 fontSize: 12.0,
          //                 color: Colors.grey,
          //                 fontWeight: FontWeight.w500),
          //           ),
          //           autocorrect: false,
          //         ),
          //         SizedBox(
          //           height: 30.0,
          //         ),
          //         TextFormField(
          //           keyboardType: TextInputType.number,
          //           style:
          //               TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          //           controller: _phoneNumberController,
          //           decoration: InputDecoration(
          //             enabledBorder: OutlineInputBorder(
          //                 borderSide: new BorderSide(color: Colors.black12),
          //                 borderRadius: BorderRadius.circular(30.0)),
          //             focusedBorder: OutlineInputBorder(
          //                 borderSide: new BorderSide(color: Colors.black),
          //                 borderRadius: BorderRadius.circular(30.0)),
          //             contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
          //             labelText: "Phone Number",
          //             hintStyle: TextStyle(
          //                 fontSize: 12.0, fontWeight: FontWeight.w500),
          //             labelStyle: TextStyle(
          //                 fontSize: 12.0,
          //                 color: Colors.grey,
          //                 fontWeight: FontWeight.w500),
          //           ),
          //           autocorrect: false,
          //         ),
          //         SizedBox(
          //           height: 30.0,
          //         ),
          //         TextFormField(
          //           style:
          //               TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          //           controller: _usernameController,
          //           keyboardType: TextInputType.emailAddress,
          //           decoration: InputDecoration(
          //             prefixIcon:
          //                 Icon(Icons.email_outlined, color: Colors.black26),
          //             enabledBorder: OutlineInputBorder(
          //                 borderSide: new BorderSide(color: Colors.black12),
          //                 borderRadius: BorderRadius.circular(30.0)),
          //             focusedBorder: OutlineInputBorder(
          //                 borderSide: new BorderSide(color: Colors.black),
          //                 borderRadius: BorderRadius.circular(30.0)),
          //             contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
          //             labelText: "E-Mail",
          //             hintStyle: TextStyle(
          //                 fontSize: 12.0, fontWeight: FontWeight.w500),
          //             labelStyle: TextStyle(
          //                 fontSize: 12.0,
          //                 color: Colors.grey,
          //                 fontWeight: FontWeight.w500),
          //           ),
          //           autocorrect: false,
          //         ),
          //         SizedBox(
          //           height: 20.0,
          //         ),
          //         TextFormField(
          //           style:
          //               TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          //           controller: _passwordController,
          //           decoration: InputDecoration(
          //             fillColor: Colors.white,
          //             prefixIcon: Icon(
          //               Icons.lock_clock_outlined,
          //               color: Colors.black26,
          //             ),
          //             enabledBorder: OutlineInputBorder(
          //                 borderSide: new BorderSide(color: Colors.black12),
          //                 borderRadius: BorderRadius.circular(30.0)),
          //             focusedBorder: OutlineInputBorder(
          //                 borderSide: new BorderSide(color: Colors.black),
          //                 borderRadius: BorderRadius.circular(30.0)),
          //             contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
          //             labelText: "Password",
          //             hintStyle: TextStyle(
          //                 fontSize: 12.0, fontWeight: FontWeight.w500),
          //             labelStyle: TextStyle(
          //                 fontSize: 12.0,
          //                 color: Colors.grey,
          //                 fontWeight: FontWeight.w500),
          //           ),
          //           autocorrect: false,
          //           obscureText: true,
          //         ),
          //         SizedBox(
          //           height: 30.0,
          //         ),
          //         Padding(
          //           padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.stretch,
          //             children: <Widget>[
          //               SizedBox(
          //                   height: 45,
          //                   child: state is RegisterLoading
          //                       ? Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.center,
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: <Widget>[
          //                             Center(
          //                                 child: Column(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.center,
          //                               children: [
          //                                 SizedBox(
          //                                   height: 25.0,
          //                                   width: 25.0,
          //                                   child: CupertinoActivityIndicator(),
          //                                 )
          //                               ],
          //                             ))
          //                           ],
          //                         )
          //                       : RaisedButton(
          //                           disabledTextColor: Colors.white,
          //                           shape: RoundedRectangleBorder(
          //                             borderRadius: BorderRadius.circular(30.0),
          //                           ),
          //                           onPressed: _onLoginButtonPressed,
          //                           child: Text("Register",
          //                               style: new TextStyle(
          //                                   fontSize: 12.0,
          //                                   fontWeight: FontWeight.bold,
          //                                   color: Colors.white)))),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        },
      ),
    );
  }

  AlertDialog alertDialogMetod(
    Widget okButton,
    String text,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color.fromARGB(255, 144, 138, 137)),
        borderRadius: BorderRadius.circular(20),
      ),
      actions: [okButton],
      content: Text(text),
    );
  }
}

class lowCaseText extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return oldValue.copyWith(text: newValue.text.toUpperCase());
  }
}
