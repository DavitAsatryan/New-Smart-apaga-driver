part of 'profile_get_data_bloc.dart';
abstract class ProfileGetDataEvent extends Equatable {
  const ProfileGetDataEvent();
  @override
  List<Object> get props => [];}
class ProfileFetchEvent extends ProfileGetDataEvent {}
