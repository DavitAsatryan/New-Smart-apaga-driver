import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import '../../repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthBloc authenticationBloc;
  LoginBloc({required this.userRepository, required this.authenticationBloc})
      : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginButtonPressed) {
        emit(LoginLoading());
        try {
          var token = await FlutterSession().get("token");
          final user = await userRepository.login(UserLogin(
              phoneNumber: event.phoneNumber,
              password: event.password,
              firebase_token: event.firebase_token));
          authenticationBloc.add(LoggedIn(token: token));
          emit(LoginInitial());
        } catch (error) {
          emit(LoginFailure(error: error.toString()));
        }
      }
    });
  }
}
