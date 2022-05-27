import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:new_apaga/Enum/internetEnum.dart';
import 'package:new_apaga/bloc/ForgetPassword_Bloc/bloc/forget_password_bloc.dart';
import 'package:new_apaga/bloc/ForgetPassword_Bloc/bloc/pincode_forget_pass_bloc.dart';
import 'package:new_apaga/repository.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'forget_password_pincode.dart';

String base_url = 'https://phpstack-351614-1150808.cloudwaysapps.com';
var api_url = base_url + '/api/customer';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var maskFormatter = MaskTextInputFormatter(
      mask: '##-###-###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  String hyCode = "374";
  String phone = "";
  String textDialog = "Սխալ";
  _onPhoneNumberButtonPressed() {
    phone = "$hyCode${maskFormatter.getUnmaskedText()}";
    if (formKey.currentState!.validate()) {
      BlocProvider.of<ForgetPasswordBloc>(context).add(
        ButtonPhoneNumber(
          phoneNumberText: phone,
        ),
      );
    } else {
      return null;
    }
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
    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordLoading) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => PincodeForgetPassBloc(
                        authenticationBloc: BlocProvider.of<AuthBloc>(context),
                        userRepository: UserRepository()),
                    child: ForgetPasswordPinCode(
                      phoneNumber: phone,
                    ),
                  )));
        } else if (state is ForgetPasswordFailure) {
          if (UserRepository.exeptionText ==
              "{message: Driver phone number not exist in db}") {
            textDialog = "Սխալ հեռախոսահամար:";
          }
          showDialog(
              // barrierColor: const Color.fromARGB(218, 226, 222, 211),
              context: context,
              builder: (context) {
                return alert(okButton, textDialog);
              });
        }
      },
      child: BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
        builder: (context, state) {
          return Padding(
            padding:
                const EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 0),
            child: Form(
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
                                      0, 0, 0, 31),
                                  child: Container(
                                    width: 288,
                                    height: 60,
                                    child: Stack(
                                      children: const [
                                        Align(
                                          alignment: AlignmentDirectional(
                                            -1,
                                            0,
                                          ),
                                          child: Text('Մոռացել եք գաղտնաբառը',
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
                                      0, 0, 0, 10),
                                  child: Container(
                                    width: 288,
                                    height: 60,
                                    child: Stack(
                                      children: const [
                                        Align(
                                          alignment: AlignmentDirectional(
                                            -1,
                                            0,
                                          ),
                                          child: Text(
                                              'Մուտքագրեք ձեր հաշվում նշված հեռախոսահամարը',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Color.fromRGBO(
                                                    162, 160, 160, 1),
                                                fontSize: 17,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 27),
                                  child: Container(
                                    width: 288,
                                    height: 70,
                                    child: Stack(
                                      children: [
                                        Align(
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
                                      0, 0, 0, 0),
                                  child: Container(
                                    width: 214,
                                    height: 40,
                                    child: Stack(
                                      children: [
                                        Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0, 0),
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
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  _onPhoneNumberButtonPressed();
                                                },
                                                child: const Text(
                                                  'Վերականգնել',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromRGBO(
                                                          240, 240, 240, 1)),
                                                ))),
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
      ),
    );
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
