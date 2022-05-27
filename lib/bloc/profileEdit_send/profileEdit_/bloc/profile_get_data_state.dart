part of 'profile_get_data_bloc.dart';

abstract class ProfileGetDataState extends Equatable {
  const ProfileGetDataState();
  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileGetDataState {}

class ProfileLoadingState extends ProfileGetDataState {}

class ProfileFetchSuccses extends ProfileGetDataState {
  List<ProfileModel> profileDatat = [];
  ProfileFetchSuccses({required this.profileDatat}) {}
}

class ErrorProfileState extends ProfileGetDataState {
  String error;
  ErrorProfileState(this.error);
}
