import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/bloc/Login_bloc/login_bloc.dart';
import 'package:new_apaga/main.dart';
import '../repository.dart';
import 'login_form.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;
  final AuthBloc auth;
  const LoginScreen(
      {Key? key, required this.userRepository, required this.auth})
      : assert(userRepository != null),
        super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthBloc>(context),
            userRepository: widget.userRepository,
          );
        },
        child: LoginForm(
          userRepository: widget.userRepository,
          auth: widget.auth,
        ),
      ),
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
                    fontSize: 12, color: Color.fromRGBO(65, 132, 130, 1)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                "Privacy Policy",
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(65, 132, 130, 1)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
