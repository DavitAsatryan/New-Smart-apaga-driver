import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:new_apaga/Cubit/Internet/cubit/internet_cubit.dart';
import 'package:new_apaga/Enum/internetEnum.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import '../../../../repository.dart';
part 'profile_edit_event.dart';
part 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final UserRepository userRepository;
  final AuthBloc authenticationBloc;
  final InternetCubit internetCubit;
  ProfileEditBloc(
      {required this.authenticationBloc,
      required this.userRepository,
      required this.internetCubit})
      : super(ProfileEditInitial()) {
    on<ProfileEditEvent>((event, emit) async {
      if (event is ProfileEditButtonPressed) {
        emit(ProfileEditInitial());
        try {
          var token = await FlutterSession().get("token");
          final profileEdit = await userRepository.profileSend(ProfileModel(
              avatar: event.imagePath,
              firstname: event.firstname,
              lastname: event.lastname,
              phoneNumber: event.phoneOne,
              title: event.title,
              color: event.color,
              volume: event.volume));
          //authenticationBloc.add(LoggedIn(token: token));
          emit(ProfileEditLoading());
        } catch (error) {
          emit(ProfileEditFailure(error: error.toString()));
        }
      }
    });
  }
}
