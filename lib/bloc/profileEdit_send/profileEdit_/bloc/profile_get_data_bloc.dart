import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';

import '../../../../repository.dart';
part 'profile_get_data_event.dart';
part 'profile_get_data_state.dart';

class ProfileGetDataBloc
    extends Bloc<ProfileGetDataEvent, ProfileGetDataState> {
  UserRepository repository;
  AuthBloc auth;
  ProfileGetDataBloc({required this.auth, required this.repository})
      : super(ProfileInitialState()) {
    List<ProfileModel> listProfile = [];
    on<ProfileGetDataEvent>((event, emit) async {
      if (event is ProfileFetchEvent) {
        emit(ProfileLoadingState());
        try {
          await repository.profileDataGet().then((value) {
            listProfile.addAll(value);
          });
          emit(ProfileFetchSuccses(profileDatat: listProfile));
        } catch (e) {
          emit(ErrorProfileState(e.toString()));
        }
      }
    });
  }
}
