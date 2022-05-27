part of 'pincode_forget_pass_bloc.dart';

abstract class PincodeForgetPassEvent extends Equatable {
  const PincodeForgetPassEvent();
  @override
  List<Object> get props => [];
}

class ButtonPinCode extends PincodeForgetPassEvent {
  final String pinCodeText;
  final String phoneNumber;
  const ButtonPinCode({
    required this.pinCodeText,
    required this.phoneNumber,
  });
  @override
  List<Object> get props => [pinCodeText, phoneNumber];

  @override
  String toString() =>
      'ButtonPinCode {pinCodeText: $pinCodeText: phoneNumber: $phoneNumber }';
}
