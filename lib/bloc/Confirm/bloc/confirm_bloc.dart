import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_session/flutter_session.dart';
import '../../../repository.dart';
import '../../Auth_Bloc/bloc/auth_bloc.dart';
part 'confirm_event.dart';
part 'confirm_state.dart';

class ConfirmBloc extends Bloc<ConfirmEvent, ConfirmState> {
  final UserRepository userRepository;
  final AuthBloc authenticationBloc;
  ConfirmBloc({required this.userRepository, required this.authenticationBloc})
      : super(ConfirmInitial()) {
    on<ConfirmEvent>((event, emit) async {
      if (event is ConfirmButtonPressed) {
        emit(ConfirmInitial());
        try {
          print(event.pickupId);
          var token = await FlutterSession().get("token");
          final confirm = await userRepository.confirm(event.pickupId);
          //authenticationBloc.add(LoggedIn(token: token));
          emit(ConfirmLoading());
        } catch (error) {
          emit(ConfirmFailure(error: error.toString()));
        }
      }
    });
  }
}
