part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String phoneNumber;
  final String password;
  final String firebase_token;
  const LoginButtonPressed({
    required this.phoneNumber,
    required this.password,
    required this.firebase_token,
  });
  @override
  List<Object> get props => [phoneNumber, password];
  @override
  String toString() =>
      'LoginButtonPressed { phoneNumber: $phoneNumber, password: $password }';
}
