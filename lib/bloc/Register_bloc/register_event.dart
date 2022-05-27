part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}

class RegisternButtonPressed extends RegisterEvent {
  final String fullname;
  final String phoneNumber;
  final String carNumber;
  final String carName;
  final String carColor;
  final String carCapacity;
  final String password;
  final String firebase_token;
  const RegisternButtonPressed({
    required this.fullname,
    required this.phoneNumber,
    required this.carNumber,
    required this.carName,
    required this.carColor,
    required this.carCapacity,
    required this.password,
    required this.firebase_token,
  });
  @override
  List<Object> get props => [
        fullname,
        phoneNumber,
        carNumber,
        carName,
        carColor,
        carCapacity,
        password,
        firebase_token
      ];
  @override
  String toString() =>
      'RegisternButtonPressed { fullname: $fullname, phoneNumber: $phoneNumber, carNnumber: $carNumber,carName: $carName, carColor: $carColor, carCapacity: $carCapacity, password: $password, firebase_token $firebase_token }';
}
