part of 'profile_edit_bloc.dart';

abstract class ProfileEditEvent extends Equatable {
  const ProfileEditEvent();
  @override
  List<Object> get props => [];
}

class ProfileEditButtonPressed extends ProfileEditEvent {
  int? id;
  dynamic imagePath;
  final String? firstname;
  final String? lastname;
  final String? phoneOne;
  final int? idD;
  final int? userId;
  final List<Vehicles>? vehicles;

  ProfileEditButtonPressed({
    required this.id,
    required this.imagePath,
    required this.firstname,
    required this.lastname,
    required this.phoneOne,
    required this.idD,
    required this.userId,
    required this.vehicles,
  });
  @override
  List<Object> get props =>
      [imagePath, firstname!, lastname!, phoneOne!, vehicles!];
  @override
  String toString() =>
      'ProfileEditButtonPressed {id: $id: imagePAth: $imagePath firstname: $firstname lastname: $lastname: phoneOne: $phoneOne: idD: $idD: userId: $userId: vehicles: $vehicles }';
}
