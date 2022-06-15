import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_apaga/Enum/internetEnum.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/bloc/Order_bloc/order_bloc.dart';
import 'package:new_apaga/bloc/profileEdit_send/Password_Bloc/bloc/password_change_bloc.dart';
import 'package:new_apaga/bloc/profileEdit_send/Password_Bloc/bloc/profile_edit_bloc.dart';
import 'package:new_apaga/repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:new_apaga/showdIalogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../bloc/profileEdit_send/profileEdit_/bloc/profile_get_data_bloc.dart';
import '../../../splash.dart';
import '../../login_form.dart';
import '../../login_screen.dart';

var orderAPI = 'https://jsonplaceholder.typicode.com/posts';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}

List<ProfileModel> listProfile = [];
// List<ProfilePhoneNumberModel> listNumbers = [];
final _fullNameController = TextEditingController();
final _passwordController = TextEditingController();
final _passwordTwoController = TextEditingController();
final _passwordthreeController = TextEditingController();

class _ProfileState extends State<Profile> {
  var maskFormatter = MaskTextInputFormatter(
      mask: '##-###-###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  bool passwordVisibility = false;
  bool passwordVisibilityTwo = false;
  bool passwordVisibilityThree = false;
  bool doublePassword = false;
  bool isCheckedOne = false;
  bool isCheckedTwo = false;
  bool isCheckedThree = false;
  bool isCheckedFour = false;
  bool sendBoolData = false;
  final formKey = GlobalKey<FormState>();
  final passKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final carOneNumberController = TextEditingController();
  final carOneNameController = TextEditingController();
  final carOneColorController = TextEditingController();
  final scrollCOntroller = ScrollController();

  int _valueRadio = 0;
  int counterBorder = 0;
  double valueScroll = 0;
  String radioOneText = "";
  static dynamic imageTemprory;

  void scrollUp(double value) {
    scrollCOntroller.animateTo(value,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  void initState() {
    var profileEvent = BlocProvider.of<ProfileGetDataBloc>(context);
    profileEvent.add(ProfileFetchEvent());
    // getProfilData();
    super.initState();
  }

  // onProfileEditButtonPressed(
  //   dynamic avatar,
  //   String fullName,
  //   String phoneNumber,
  //   String title,
  //   String color,
  //   String volume,
  // ) {
  //   if (formKey.currentState!.validate()) {
  //     print("object");
  //     BlocProvider.of<ProfileEditBloc>(context).add(ProfileEditButtonPressed(
  //         imagePath: avatar,
  //         firstname: fullName,
  //         lastname: fullName,
  //         phoneOne: phoneNumber,

  //         // color: color,
  //         // title: title,
  //         // volume: volume
  //         ));
  //     print(
  //         "ProfilEditMetod avatar: $avatar, fullName: $fullName, number: $phoneNumber, color: $color, title: $title, volume:  $volume");
  //   } else {
  //     if (_fullNameController.value.composing.isValid ||
  //         _phoneNumberController.value.composing.isValid) {
  //     } else {
  //       setState(() {
  //         valueScroll = 1200;
  //       });
  //     }

  //     if (carOneNumberController.value.composing.isValid ||
  //         carOneNameController.value.composing.isValid ||
  //         carOneColorController.value.composing.isValid) {
  //     } else {
  //       setState(() {
  //         valueScroll = 350;
  //       });
  //     }

  //     scrollUp(valueScroll);
  //     return null;
  //   }
  // }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('token_auth');
    setState(() {
      // isLOggedIN = false;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return LoginScreen(
            userRepository: UserRepository(),
            auth: BlocProvider.of<AuthBloc>(context),
          );
        },
      ), (route) => false);
    });

    print("123    ${prefs.get("token_auth")} logout token_auth");
    //print("$isLOggedIN logout");
  }

  Future deleteProfile() async {
    String deleteAPI = "";
    var response = await http.delete(
      Uri.parse(deleteAPI),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // print();
    }
  }

  onPasswordChangeButtonPressed(
      String password, String newPassword, String newPasswordTwo) {
    BlocProvider.of<PasswordChangeBloc>(context).add(
        PasswordChangeButtonPressed(
            password: password,
            newPassword: newPassword,
            newPasswordTwo: newPasswordTwo));
    print(
        "PasswordChangeBloc: $password, newPassword: $newPassword, newPasswordTwo: $newPasswordTwo   ");
  }

  dynamic imageSend;
  File? image;
  Future pickerImage() async {
    try {
      final images = await ImagePicker().getImage(source: ImageSource.gallery);
      // _uploadFile(images);

      if (images == null) {
        return;
      }
      imageTemprory = File(images.path);
      setState(() {
        this.image = imageTemprory;
      });

      //  _imageController.text = ;
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<void> uploadImage(File? file) async {
    String number = "374${_phoneNumberController.text}";

    print(_fullNameController.text);
    print(number);
    print(carOneNameController.text);
    print(carOneColorController.text);
    print(radioOneText);

    dynamic token = await FlutterSession().get('token');
    var dio = Dio();
    var url = "http://159.223.29.24/PersonalData";
    String fileName;
    // if (file!.path.length > 0) {
    //   fileName = file.path.split('/').last;
    // }

    print(file?.path.isEmpty);
    //  print(file.path);

    FormData formData = FormData.fromMap({
      "avatar": file?.path != null
          ? await MultipartFile.fromFile(file!.path,
              filename: "File ${file.path}")
          : null,
      "fullName": _fullNameController.text,
      "lastname": _fullNameController.text,
      "phone_number": number,
      "title": carOneNameController.text,
      "color": carOneColorController.text,
      "volume": radioOneText,
    });
    var response;
    try {
      response = await dio.post(url,
          data: formData,
          options: Options(
              contentType: "multipart/form-data",
              headers: {'auth-token': '$token'}));
      print(response.statusCode);
      if (response.statusCode == 200) {
        ShowDialogs().show(context, false).then((value) => null);
      }
    } catch (e) {
      String exeption = "Սխալ";
      print(UserRepository
          .exeptionText); //{message: user with phoneNumber: 374${_phoneNumberController.text} already registered }
      if (UserRepository.exeptionText == "{message: Invalid password}" ||
          UserRepository.exeptionText ==
              "{message: User phone number is not exist in db}" ||
          UserRepository.exeptionText ==
              "user with phoneNumber: $number already registered ") {
        exeption = "Հեռախոսահամարն արդեն գրանցված է խնդրում ենք փոխել այն";
      }

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
                )
              ],
              shape: RoundedRectangleBorder(
                side:
                    const BorderSide(color: Color.fromARGB(255, 144, 138, 137)),
                borderRadius: BorderRadius.circular(10),
              ),
              content: StatefulBuilder(
                builder: (context, setState) => Container(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                    child: Text("$exeption"),
                  ),
                ),
              ));
        },
      ).then((value) => null);
    }

    // return response.data;
  }

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  // void _uploadFile(fileP) async {
  //   // Get base file name
  //   String fileName = fileP.path;
  //   var file = (fileName.split('/').last);
  //   var filePath = fileName.replaceAll("/$fileName", '');
  //   print(fileName);
  //   print(filePath);
  //   //print("File base name: $fileName");

  //   try {
  //     String number = "374${_phoneNumberController.text}";
  //     FormData formData = new FormData.fromMap({
  //       "avatar": await MultipartFile.fromFile(fileP.path, filename: "dp"),
  //       "fullName": _fullNameController.text,
  //       "lastname": _fullNameController.text,
  //       "phoneNumber": number,
  //       "title": carOneNameController.text,
  //       "color": carOneColorController.text,
  //       "volume": radioOneText,
  //     });

  //     var response =
  //         await Dio().post("http://159.223.29.24/personalPage", data: formData);
  //     print("File upload response: $response");
  //     print(response.statusCode);

  //     // Show the incoming message in snakbar
  //     _showSnakBarMsg(response.data['message']);
  //   } catch (e) {
  //     print("Exception Caught: $e");
  //   }
  // }

  // void _showSnakBarMsg(String msg) {
  //   _scaffoldstate.currentState!
  //       .showSnackBar(new SnackBar(content: new Text(msg)));
  // }

  // Widget buildsheet() => Padding(
  //       padding: const EdgeInsets.only(left: 16, right: 16),
  //       child: Container(
  //         width: double.infinity,
  //         height: 234,
  //         decoration: const BoxDecoration(color: Color.fromRGBO(38, 38, 38, 1)),
  //         child: Column(
  //           children: [
  //             Container(
  //               width: double.infinity,
  //               height: 79,
  //               decoration: const BoxDecoration(
  //                   color: Color.fromRGBO(255, 255, 255, 1),
  //                   borderRadius: BorderRadius.all(Radius.circular(8))),
  //               child: Column(
  //                 children: [
  //                   const Padding(
  //                     padding: EdgeInsets.only(
  //                       top: 10,
  //                     ),
  //                     child: Text(
  //                       "Ցանկանու՞մ եք ջնջել էջը",
  //                       style: TextStyle(
  //                           color: Color.fromRGBO(112, 112, 112, 1),
  //                           fontSize: 14),
  //                     ),
  //                   ),
  //                   TextButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                         //deleteProfile();
  //                       },
  //                       child: const Text("Ջնջել",
  //                           style: TextStyle(
  //                               color: Color.fromRGBO(255, 53, 53, 1),
  //                               fontSize: 18)))
  //                 ],
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 13),
  //               child: Container(
  //                   width: double.infinity,
  //                   height: 39,
  //                   decoration: const BoxDecoration(
  //                       color: Color.fromRGBO(255, 255, 255, 1),
  //                       borderRadius: BorderRadius.all(Radius.circular(8))),
  //                   child: TextButton(
  //                     child: const Text(
  //                       "Չեղարկել",
  //                       style: TextStyle(
  //                           color: Color.fromRGBO(12, 128, 64, 1),
  //                           fontSize: 18),
  //                     ),
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                   )),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  // Future<dynamic> showModalDeleteDialog(BuildContext context) {
  //   return showModalBottomSheet(
  //     elevation: 0,
  //     barrierColor: const Color.fromRGBO(38, 38, 38, 1),
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     builder: (context) => buildsheet(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (_valueRadio == 1) {
      isCheckedOne = true;
      setState(() {
        radioOneText = "100";
        sendBoolData = isCheckedOne;
      });
    } else if (_valueRadio == 2) {
      setState(() {
        isCheckedTwo = true;
        radioOneText = "300";
        sendBoolData = isCheckedTwo;
      });
    } else if (_valueRadio == 3) {
      setState(() {
        isCheckedThree = true;
        radioOneText = "500";
        sendBoolData = isCheckedThree;
      });
    } else if (_valueRadio == 4) {
      setState(() {
        isCheckedFour = true;
        radioOneText = "800";
        sendBoolData = isCheckedFour;
      });
    } else {
      setState(() {
        radioOneText = "";
        sendBoolData = false;
      });
    }
    if (sendBoolData == true) {
      setState(() {
        counterBorder++;
      });
    }
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        //  MaterialState.pressed,
        //MaterialState.hovered,
        //MaterialState.focused,
        MaterialState.selected
      };
      // if (states.any(interactiveStates.contains)) {
      //   return Color.fromARGB(0, 217, 31, 31);
      // }
      return const Color(0xFFA7A7A7);
    }

    // setState(() {
    //   if (listCarData.length >= 2) {
    //     hideCarData = false;
    //   }
    // });
    Widget okButton = Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 31),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(159, 205, 79, 1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              minimumSize: const Size(151, 36), //////// HERE
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              print("new prrovider");
              if (_passwordTwoController.text ==
                  _passwordthreeController.text) {
                setState(() {
                  doublePassword = false;
                });
              }
              if (_passwordTwoController.text !=
                  _passwordthreeController.text) {
                setState(() {
                  doublePassword = true;
                });
              }
              if (passKey.currentState!.validate() && doublePassword == false) {
                onPasswordChangeButtonPressed(_passwordController.text,
                    _passwordTwoController.text, _passwordthreeController.text);
                doublePassword = false;
              } else {
                return null;
              }
            },
            child: const Text('Հաստատել',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 16,
                )),
          )
        ],
      ),
    );
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color.fromARGB(255, 144, 138, 137)),
        borderRadius: BorderRadius.circular(20),
      ),
      actions: [okButton],
      title: const Text("Փոխել գաղտնաբառը",
          style: TextStyle(
            color: Color.fromRGBO(14, 14, 14, 1),
            fontSize: 16,
          )),
      content: SingleChildScrollView(
        child: Form(
          key: passKey,
          autovalidateMode: AutovalidateMode.always,
          child: StatefulBuilder(
            builder: (context, setState) => Container(
              height: 205,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                    child: Container(
                      width: 237,
                      height: 60,
                      child: Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ConstValid.partadir;
                                }
                              },
                              controller: _passwordController,
                              obscureText: !passwordVisibility,
                              decoration: InputDecoration(
                                hintText: 'Հին գաղտնաբառը',
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(235, 235, 232, 1),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
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
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xFF757575),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 7),
                    child: Container(
                      width: 237,
                      height: 60,
                      child: Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              validator: (value) {
                                Pattern password = r'[A-Z,a-z,0-9(]{6}';
                                RegExp regex = RegExp(password.toString());
                                if (value!.isEmpty) {
                                  return ConstValid.partadir;
                                } else if (!regex.hasMatch(value)) {
                                  return ConstValid.minPasswordLenght;
                                }
                              },
                              controller: _passwordTwoController,
                              obscureText: !passwordVisibilityTwo,
                              decoration: InputDecoration(
                                hintText: 'Նոր գաղտնաբառը',
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(235, 235, 232, 1),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00FFFFFF),
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFEBECE7),
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => passwordVisibilityTwo =
                                        !passwordVisibilityTwo,
                                  ),
                                  child: Icon(
                                    passwordVisibilityTwo
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xFF757575),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Container(
                      width: 237,
                      height: 60,
                      child: Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              validator: (value) {
                                if (value! == _passwordthreeController.text) {
                                  return doublePassword == false
                                      ? null
                                      : ConstValid.partadir;
                                }
                              },
                              controller: _passwordthreeController,
                              obscureText: !passwordVisibilityThree,
                              decoration: InputDecoration(
                                hintText: 'Կրնկնել նոր գաղտնաբառը',
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(235, 235, 232, 1),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00FFFFFF),
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFEBECE7),
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => passwordVisibilityThree =
                                        !passwordVisibilityThree,
                                  ),
                                  child: Icon(
                                    passwordVisibilityThree
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xFF757575),
                                fontSize: 16,
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
        ),
      ),
    );
    double width = MediaQuery.of(context).size.width;
    return BlocListener<PasswordChangeBloc, PasswordChangeState>(
      listener: (context, state) {
        if (state is PasswordChangeFailure) {
          FocusManager.instance.primaryFocus?.unfocus();
          ShowDialogs().showFailure(context).then((value) => null);
        }
        if (state is PasswordChangeInitial) {
          FocusManager.instance.primaryFocus?.unfocus();
          ShowDialogs().show(context, false).then((value) => null);
        }
      },
      child: Scaffold(
          body: BlocListener<ProfileEditBloc, ProfileEditState>(
        listener: (context, state) {
          String exeption = "Սխալ";
          if (state is ProfileEditFailure) {
            print(UserRepository.exeptionText);
            if (UserRepository.exeptionText ==
                "{message: user with phoneNumber: 374${_phoneNumberController.text} already registered }") {
              exeption =
                  "Հեռախոսահամարն արդեն գրանցված է խնդրում ենք փոխել այն";
            }
            FocusManager.instance.primaryFocus?.unfocus();
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
                      )
                    ],
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Color.fromARGB(255, 144, 138, 137)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    content: StatefulBuilder(
                      builder: (context, setState) => Container(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                          child: Text("$exeption"),
                        ),
                      ),
                    ));
              },
            ).then((value) => null);
          }
          if (state is ProfileEditInitial) {
            Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ProfileEditLoading) {
          } else if (state is ErrorProfileState) {
            Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        child: BlocBuilder<ProfileGetDataBloc, ProfileGetDataState>(
          builder: (context, state) {
            Color getColor(Set<MaterialState> states) {
              const Set<MaterialState> interactiveStates = <MaterialState>{
                //  MaterialState.pressed,
                //MaterialState.hovered,
                //MaterialState.focused,
                MaterialState.selected
              };
              // if (states.any(interactiveStates.contains)) {
              //   return Color.fromARGB(0, 217, 31, 31);
              // }
              return const Color(0xFFA7A7A7);
            }

//imdave
            if (state is ProfileLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileFetchSuccses) {
              bool? imageType;
              String imageAvatar = state.profileDatat[0].avatar;
              print(imageAvatar);

              if (imageAvatar == "http://159.223.29.24/null") {
                imageType = true;
              } else if (imageAvatar != "http://159.223.29.24/null") {
                imageType = false;
              }

              String? fullname =
                  "${state.profileDatat[0].firstname!} ${state.profileDatat[0].lastname!}";
              _fullNameController.text = fullname;
              _phoneNumberController.text =
                  state.profileDatat[0].phoneNumber!.substring(3);

              carOneNumberController.text =
                  state.profileDatat[0].vehicles![0].license_plate!;
              carOneNameController.text =
                  state.profileDatat[0].vehicles![0].title!;
              carOneColorController.text =
                  state.profileDatat[0].vehicles![0].color!;
              if (state.profileDatat[0].vehicles![0].volume! == "100") {
                _valueRadio = 1;
                radioOneText = state.profileDatat[0].vehicles![0].volume!;
              } else if (state.profileDatat[0].vehicles![0].volume! == "300") {
                _valueRadio = 2;
                radioOneText = state.profileDatat[0].vehicles![0].volume!;
              } else if (state.profileDatat[0].vehicles![0].volume! == "500") {
                _valueRadio = 3;
                radioOneText = state.profileDatat[0].vehicles![0].volume!;
              } else if (state.profileDatat[0].vehicles![0].volume! == "800") {
                _valueRadio = 4;
                radioOneText = state.profileDatat[0].vehicles![0].volume!;
              }

              return SingleChildScrollView(
                controller: scrollCOntroller,
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(247, 247, 247, 1)),
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
                        Column(
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 18, top: 50),
                                    child: TextButton(
                                      child: const Text(
                                        "Դուրս գալ",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color.fromRGBO(12, 128, 64, 1),
                                          fontSize: 18,
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2.5,
                                        ),
                                      ),
                                      onPressed: () async {
                                        await logout();
                                        // FlutterSession token =
                                        //     await FlutterSession().get('token');
                                        // token.prefs.remove("token");
                                        // // Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
                                        // Navigator.of(context).push(MaterialPageRoute(
                                        //     builder: (context) => LoginScreen(
                                        //         userRepository: UserRepository())));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              width: width,
                              height: 125,
                            ),
                            StatefulBuilder(
                              builder: (context, setState) => Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Stack(
                                  children: [
                                    image != null
                                        ? ClipOval(
                                            child: Image.file(
                                              image!,
                                              width: 160,
                                              height: 160,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : ClipOval(
                                            // get bloc image value
                                            child: imageType == true
                                                ? Image.asset(
                                                    "assets/profile.jpg",
                                                    width: 160,
                                                    height: 160,
                                                    fit: BoxFit.cover)
                                                : Image.network(imageAvatar,
                                                    width: 160,
                                                    height: 160,
                                                    fit: BoxFit.cover)),
                                    Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                        child: IconButton(
                                          onPressed: () {
                                            pickerImage();
                                          },
                                          icon: SvgPicture.asset(
                                              "assets/icon/camera.svg"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Stack(
                              children: [
                                Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 22),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 22),
                                              child: Container(
                                                width: 288,
                                                height: 40,
                                                child: Stack(
                                                  children: const [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                        -1,
                                                        0,
                                                      ),
                                                      child: Text(
                                                          'Անձնական տվյալներ',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 1),
                                                            fontSize: 18,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                              child: Container(
                                                width: 288,
                                                height: 40,
                                                child: Stack(
                                                  children: const [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                        -1,
                                                        0,
                                                      ),
                                                      child: Text(
                                                          'Անուն Ազգաունուն',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            color:
                                                                Color.fromRGBO(
                                                                    183,
                                                                    183,
                                                                    183,
                                                                    1),
                                                            fontSize: 14,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 12),
                                              child: Container(
                                                width: 288,
                                                height: 60,
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0, 0),
                                                      child: TextFormField(
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              30)
                                                        ],
                                                        validator: (value) {
                                                          Pattern pattern =
                                                              r"^(?:[ա-ֆԱ-Ֆա-ֆԱ-Ֆ\w+а-яА-Яа-яА-Яa-zA-Z]{3,} [ա-ֆԱ-Ֆա-ֆԱ-Ֆ\w+а-яА-Яа-яА-Яa-zA-Za-zA-Z]{1,}){0,1}$";
                                                          RegExp regex = RegExp(
                                                              pattern
                                                                  .toString());
                                                          if (value!.isEmpty) {
                                                            return ConstValid
                                                                .partadir;
                                                          } else if (!regex
                                                              .hasMatch(
                                                                  value)) {
                                                            AutovalidateMode
                                                                .disabled;
                                                            return ConstValid
                                                                .tery;
                                                          }
                                                        },
                                                        style: const TextStyle(
                                                          fontFamily: 'Lato',
                                                          color: Color.fromRGBO(
                                                              169, 169, 169, 1),
                                                          fontSize: 16,
                                                        ),
                                                        controller:
                                                            _fullNameController,
                                                        obscureText: false,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              'Անուն Ազգաունուն',
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x00FFFFFF),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10.0),
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          filled: true,
                                                          fillColor:
                                                              Color.fromRGBO(
                                                                  235,
                                                                  235,
                                                                  232,
                                                                  1),
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
                                                      .fromSTEB(0, 0, 0, 0),
                                              child: Container(
                                                width: 288,
                                                height: 40,
                                                child: Stack(
                                                  children: const [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                        -1,
                                                        0,
                                                      ),
                                                      child: Text(
                                                          'Հեռախոսահամար',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            color:
                                                                Color.fromRGBO(
                                                                    183,
                                                                    183,
                                                                    183,
                                                                    1),
                                                            fontSize: 14,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 10),
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
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              8)
                                                        ],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return ConstValid
                                                                .partadir;
                                                          } else if (value
                                                                  .length <
                                                              8) {
                                                            return ConstValid
                                                                .tery;
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
                                                              child:
                                                                  Text("+374"),
                                                            ),
                                                          ),
                                                          prefixStyle:
                                                              TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    5,
                                                                    2,
                                                                    2),
                                                          ),
                                                          hintText:
                                                              "Հեռախոսահամար",
                                                          hintStyle: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    169,
                                                                    169,
                                                                    169,
                                                                    1),
                                                          ),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0x00FFFFFF),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10.0),
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          filled: true,
                                                          fillColor:
                                                              Color.fromRGBO(
                                                                  235,
                                                                  235,
                                                                  232,
                                                                  1),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 0, 0, 22),
                                                  child: Container(
                                                    width: 288,
                                                    height: 50,
                                                    child: Stack(
                                                      children: const [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                            -1,
                                                            0,
                                                          ),
                                                          child: Text(
                                                              'Մեքենայի տվյալներ',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        1),
                                                                fontSize: 18,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
                                                  child: Container(
                                                    width: 288,
                                                    height: 40,
                                                    child: Stack(
                                                      children: const [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                            -1,
                                                            0,
                                                          ),
                                                          child: Text(
                                                              'Մեքենայի համարանիշը',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color
                                                                    .fromRGBO(
                                                                        183,
                                                                        183,
                                                                        183,
                                                                        1),
                                                                fontSize: 14,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 0, 0, 12),
                                                  child: Container(
                                                    width: 288,
                                                    height: 60,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, 0),
                                                          child: IgnorePointer(
                                                            ignoring: true,
                                                            child:
                                                                TextFormField(
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Lato',
                                                                color: Color
                                                                    .fromRGBO(
                                                                        169,
                                                                        169,
                                                                        169,
                                                                        1),
                                                                fontSize: 16,
                                                              ),
                                                              controller:
                                                                  carOneNumberController,
                                                              obscureText:
                                                                  false,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    'Մեքենայի համարանիշը',
                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0x00FFFFFF),
                                                                    width: 2,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        10.0),
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                    InputBorder
                                                                        .none,
                                                                filled: true,
                                                                fillColor: Color
                                                                    .fromRGBO(
                                                                        235,
                                                                        235,
                                                                        232,
                                                                        1),
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
                                                          .fromSTEB(0, 0, 0, 0),
                                                  child: Container(
                                                    width: 288,
                                                    height: 40,
                                                    child: Stack(
                                                      children: const [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                            -1,
                                                            0,
                                                          ),
                                                          child: Text(
                                                              'Մեքենայի մակնիշը',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color
                                                                    .fromRGBO(
                                                                        183,
                                                                        183,
                                                                        183,
                                                                        1),
                                                                fontSize: 14,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 0, 0, 12),
                                                  child: Container(
                                                    width: 288,
                                                    height: 60,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, 0),
                                                          child: TextFormField(
                                                            inputFormatters: [
                                                              LengthLimitingTextInputFormatter(
                                                                  20)
                                                            ],
                                                            validator: (value) {
                                                              if (value!
                                                                      .isEmpty ||
                                                                  value.length <
                                                                      2) {
                                                                return ConstValid
                                                                    .partadir;
                                                              }
                                                            },
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Lato',
                                                              color: Color
                                                                  .fromRGBO(
                                                                      169,
                                                                      169,
                                                                      169,
                                                                      1),
                                                              fontSize: 16,
                                                            ),
                                                            controller:
                                                                carOneNameController,
                                                            obscureText: false,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  'Մեքենայի մակնիշը',
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0x00FFFFFF),
                                                                  width: 2,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0),
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                              filled: true,
                                                              fillColor: Color
                                                                  .fromRGBO(
                                                                      235,
                                                                      235,
                                                                      232,
                                                                      1),
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
                                                          .fromSTEB(0, 0, 0, 0),
                                                  child: Container(
                                                    width: 288,
                                                    height: 40,
                                                    child: Stack(
                                                      children: const [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                            -1,
                                                            0,
                                                          ),
                                                          child: Text(
                                                              'Մեքենայի գույնը',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color
                                                                    .fromRGBO(
                                                                        183,
                                                                        183,
                                                                        183,
                                                                        1),
                                                                fontSize: 14,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 0, 0, 20),
                                                  child: Container(
                                                    width: 288,
                                                    height: 60,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, 0),
                                                          child: TextFormField(
                                                            inputFormatters: [
                                                              LengthLimitingTextInputFormatter(
                                                                  15)
                                                            ],
                                                            validator: (value) {
                                                              if (value!
                                                                      .isEmpty ||
                                                                  value.length <
                                                                      2) {
                                                                return ConstValid
                                                                    .partadir;
                                                              }
                                                            },
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Lato',
                                                              color: Color
                                                                  .fromRGBO(
                                                                      169,
                                                                      169,
                                                                      169,
                                                                      1),
                                                              fontSize: 16,
                                                            ),
                                                            controller:
                                                                carOneColorController,
                                                            obscureText: false,
                                                            decoration:
                                                                const InputDecoration(
                                                              hintText:
                                                                  'Մեքենայի գույնը',
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          235,
                                                                          235,
                                                                          232,
                                                                          1),
                                                                  width: 2,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0),
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFFEBECE7),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                //dddd
                                                StatefulBuilder(
                                                  builder:
                                                      (context, setState) =>
                                                          Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            0, 0, 0, 0),
                                                    child: Container(
                                                      width: 288,
                                                      height: 242,
                                                      child: Stack(
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    -1, 0),
                                                            child: Container(
                                                              width: 310,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: const Border
                                                                        .fromBorderSide(
                                                                    BorderSide(
                                                                        width:
                                                                            0.5,
                                                                        color: Color.fromRGBO(
                                                                            235,
                                                                            235,
                                                                            232,
                                                                            1))),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: const Color
                                                                        .fromRGBO(
                                                                    235,
                                                                    235,
                                                                    232,
                                                                    1),
                                                              ),
                                                              height: 400,
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            11,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          288,
                                                                      height:
                                                                          20,
                                                                      child:
                                                                          Stack(
                                                                        children: const [
                                                                          Align(
                                                                            alignment:
                                                                                AlignmentDirectional(
                                                                              -1,
                                                                              0,
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(left: 11),
                                                                              child: Text('Մեքենայի տարողությունը',
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Poppins',
                                                                                    color: Color.fromRGBO(0, 0, 0, 1),
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
                                                                        const EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            22,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          310,
                                                                      height:
                                                                          20,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(0, 0),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                              child: Container(
                                                                                width: 288,
                                                                                height: 20,
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: const AlignmentDirectional(0, 0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Theme(
                                                                                            data: Theme.of(context).copyWith(
                                                                                              unselectedWidgetColor: const Color.fromRGBO(167, 166, 166, 1),
                                                                                            ),
                                                                                            child: Radio(
                                                                                              activeColor: const Color.fromRGBO(12, 128, 64, 1),
                                                                                              value: 1,
                                                                                              groupValue: _valueRadio,
                                                                                              onChanged: (int? value) {
                                                                                                setState(() {
                                                                                                  _valueRadio = value!;
                                                                                                });
                                                                                                if (_valueRadio == 1) {
                                                                                                  radioOneText = "100";
                                                                                                }
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                          InkWell(
                                                                                            onTap: () {
                                                                                              setState(() {
                                                                                                _valueRadio = 1;
                                                                                              });
                                                                                            },
                                                                                            child: const Text("100 - 300",
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
                                                                        const EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            27,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          310,
                                                                      height:
                                                                          20,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(0, 0),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                              child: Container(
                                                                                width: 288,
                                                                                height: 20,
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: const AlignmentDirectional(0, 0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Theme(
                                                                                            data: Theme.of(context).copyWith(
                                                                                              unselectedWidgetColor: const Color.fromRGBO(167, 166, 166, 1),
                                                                                            ),
                                                                                            child: Radio(
                                                                                              activeColor: const Color.fromRGBO(12, 128, 64, 1),
                                                                                              value: 2,
                                                                                              groupValue: _valueRadio,
                                                                                              onChanged: (int? value) {
                                                                                                setState(() {
                                                                                                  _valueRadio = value!;
                                                                                                });
                                                                                                if (_valueRadio == 2) {
                                                                                                  radioOneText = "300";
                                                                                                }
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                          InkWell(
                                                                                            onTap: () {
                                                                                              setState(() {
                                                                                                _valueRadio = 2;
                                                                                              });
                                                                                            },
                                                                                            child: const Text("300 - 500",
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
                                                                        const EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            27,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          288,
                                                                      height:
                                                                          20,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(0, 0),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                              child: Container(
                                                                                width: 288,
                                                                                height: 20,
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: const AlignmentDirectional(0, 0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Theme(
                                                                                            data: Theme.of(context).copyWith(
                                                                                              unselectedWidgetColor: const Color.fromRGBO(167, 166, 166, 1),
                                                                                            ),
                                                                                            child: Radio(
                                                                                              activeColor: const Color.fromRGBO(12, 128, 64, 1),
                                                                                              value: 3,
                                                                                              groupValue: _valueRadio,
                                                                                              onChanged: (int? value) {
                                                                                                setState(() {
                                                                                                  _valueRadio = value!;
                                                                                                });
                                                                                                if (_valueRadio == 3) {
                                                                                                  radioOneText = "500";
                                                                                                }
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                          InkWell(
                                                                                            onTap: () {
                                                                                              setState(() {
                                                                                                _valueRadio = 3;
                                                                                              });
                                                                                            },
                                                                                            child: const Text("500 - 800",
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
                                                                        const EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            27,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          288,
                                                                      height:
                                                                          20,
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                const AlignmentDirectional(0, 0),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                                                              child: Container(
                                                                                width: 288,
                                                                                height: 20,
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: const AlignmentDirectional(0, 0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Theme(
                                                                                            data: Theme.of(context).copyWith(
                                                                                              unselectedWidgetColor: const Color.fromRGBO(167, 166, 166, 1),
                                                                                            ),
                                                                                            child: Radio(
                                                                                              activeColor: const Color.fromRGBO(12, 128, 64, 1),
                                                                                              value: 4,
                                                                                              groupValue: _valueRadio,
                                                                                              onChanged: (int? value) {
                                                                                                setState(() {
                                                                                                  _valueRadio = value!;
                                                                                                });
                                                                                                if (_valueRadio == 4) {
                                                                                                  radioOneText = "800";
                                                                                                }
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                          InkWell(
                                                                                            onTap: () {
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
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
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
                                                          child: const Text(
                                                            "Փոխել գաղտնաբառը",
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      12,
                                                                      128,
                                                                      64,
                                                                      1),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                barrierColor:
                                                                    const Color
                                                                            .fromARGB(
                                                                        38,
                                                                        38,
                                                                        38,
                                                                        1),
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return BlocProvider(
                                                                    create: (context) => PasswordChangeBloc(
                                                                        authenticationBloc:
                                                                            AuthBloc(),
                                                                        userRepository:
                                                                            UserRepository()),
                                                                    child:
                                                                        alert,
                                                                  );
                                                                }).then((value) => null);
                                                          },
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                // Padding(
                                                //     padding:
                                                //         const EdgeInsetsDirectional
                                                //                 .fromSTEB(
                                                //             0, 0, 0, 31),
                                                //     child: ElevatedButton(
                                                //       style: ElevatedButton
                                                //           .styleFrom(
                                                //         primary: const Color
                                                //                 .fromRGBO(
                                                //             247, 247, 247, 1),
                                                //         elevation: 0,
                                                //         shape: RoundedRectangleBorder(
                                                //             side: const BorderSide(
                                                //                 color: Color
                                                //                     .fromRGBO(
                                                //                         159,
                                                //                         205,
                                                //                         79,
                                                //                         1)),
                                                //             borderRadius:
                                                //                 BorderRadius
                                                //                     .circular(
                                                //                         10.0)),
                                                //         minimumSize:
                                                //             const Size(151, 36),
                                                //       ),
                                                //       onPressed: () {
                                                //         showModalDeleteDialog(
                                                //             context);
                                                //       },
                                                //       child: const Text(
                                                //           'Ջնջել էջը',
                                                //           style: TextStyle(
                                                //             fontFamily:
                                                //                 'Poppins',
                                                //             color:
                                                //                 Color.fromRGBO(
                                                //                     159,
                                                //                     205,
                                                //                     79,
                                                //                     1),
                                                //             fontSize: 16,
                                                //           )),
                                                //     )),
                                                Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            0, 0, 0, 31),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: const Color
                                                                .fromRGBO(
                                                            159, 205, 79, 1),
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        minimumSize: const Size(
                                                            151,
                                                            36), //////// HERE
                                                      ),
                                                      onPressed: () {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();

                                                        //   onProfileEditButtonPressed(
                                                        //       imageSend == null
                                                        //           ? _imageController
                                                        //               .text
                                                        //           : imageSend,
                                                        //       _fullNameController
                                                        //           .text,
                                                        //       number,
                                                        //       carOneNameController
                                                        //           .text,
                                                        //       carOneColorController
                                                        //           .text,
                                                        //       radioOneText);

                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          uploadImage(
                                                              this.image);
                                                        } else {
                                                          if (_fullNameController
                                                                  .value
                                                                  .composing
                                                                  .isValid ||
                                                              _phoneNumberController
                                                                  .value
                                                                  .composing
                                                                  .isValid) {
                                                          } else {
                                                            setState(() {
                                                              valueScroll = 580;
                                                            });
                                                          }

                                                          if (carOneNumberController.value.composing.isValid ||
                                                              carOneNameController
                                                                  .value
                                                                  .composing
                                                                  .isValid ||
                                                              carOneColorController
                                                                  .value
                                                                  .composing
                                                                  .isValid) {
                                                          } else {
                                                            setState(() {
                                                              valueScroll = 350;
                                                            });
                                                          }

                                                          scrollUp(valueScroll);
                                                          return null;
                                                        }
                                                      },
                                                      child: const Text(
                                                          'Հաստատել',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                            fontSize: 16,
                                                          )),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        )))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      )),
    );
  }

  Padding phoneNumberWidget(BuildContext context, var controller) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
      child: Container(
        width: 288,
        height: 70,
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: TextFormField(
                style: Theme.of(context).textTheme.subtitle1,
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
                controller: controller,
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
                    color: Color.fromRGBO(169, 169, 169, 1),
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
                  fillColor: Color.fromRGBO(235, 235, 232, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
