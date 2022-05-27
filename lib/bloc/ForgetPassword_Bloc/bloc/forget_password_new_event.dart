part of 'forget_password_new_bloc.dart';

abstract class ForgetPasswordNewEvent extends Equatable {
  const ForgetPasswordNewEvent();
  @override
  List<Object> get props => [];
}

class ButtonForgetPasswordNew extends ForgetPasswordNewEvent {
  final String phoneNumber;
  final String passwordText;
  const ButtonForgetPasswordNew(
      {required this.phoneNumber, required this.passwordText});
  @override
  List<Object> get props => [phoneNumber, passwordText];
  @override
  String toString() =>
      'ButtonForgetPasswordNew {phoneNumber: $phoneNumber: passwordText: $passwordText}';
}
