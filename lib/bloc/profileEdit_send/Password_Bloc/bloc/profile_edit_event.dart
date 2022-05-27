part of 'profile_edit_bloc.dart';

abstract class ProfileEditEvent extends Equatable {
  const ProfileEditEvent();
  @override
  List<Object> get props => [];
}

class ProfileEditButtonPressed extends ProfileEditEvent {
  dynamic imagePath;
  final String? firstname;
  final String? lastname;
  final String? phoneOne;
  final String? title;
  final String? color;
  final String? volume;
  ProfileEditButtonPressed({
    required this.imagePath,
    required this.firstname,
    required this.lastname,
    required this.phoneOne,
    required this.title,
    required this.color,
    required this.volume,
  });
  @override
  List<Object> get props =>
      [imagePath, firstname!, lastname!, phoneOne!, title!, color!, volume!];
  @override
  String toString() =>
      'ProfileEditButtonPressed {imagePAth: $imagePath firstname: $firstname lastname: $lastname: phoneOne: $phoneOne title $title color $color volume $volume }';
}
