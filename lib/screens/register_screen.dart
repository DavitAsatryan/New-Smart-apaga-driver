import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/screens/register_form.dart';
import '../bloc/Register_bloc/register_bloc.dart';
import '../repository.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository userRepository;
  const RegisterScreen({Key? key, required this.userRepository})
      : assert(userRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: BlocProvider(
        create: (context) {
          return RegisterBloc(
            authenticationBloc: BlocProvider.of<AuthBloc>(context),
            userRepository: userRepository,
          );
        },
        child: RegisterForm(
          userRepository: userRepository,
        ),
      ),
    );
  }
}
