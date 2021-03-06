import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/repository.dart';
part 'qr_counter_reason_event.dart';
part 'qr_counter_reason_state.dart';

class QrCounterReasonBloc
    extends Bloc<QrCounterReasonEvent, QrCounterReasonState> {
  final UserRepository userRepository;
  final AuthBloc authenticationBloc;
  QrCounterReasonBloc(
      {required this.authenticationBloc, required this.userRepository})
      : super(QrCounterReasonInitial()) {
    on<QrCounterReasonEvent>((event, emit) async {
      if (event is QrCounterReasonButtonPressed) {
        emit(QrCounterReasonLoading());
        try {
          var token = await FlutterSession().get("token");
          final confirm = await userRepository
              .qrCounterAndReasonModel(QrCounterAndReasonModel(
            comment_driver: event.comment_driver,
            pickup_id: event.pickup_id,
            status: event.status,
          ));
          // authenticationBloc.add(LoggedIn(token: token));
          emit(QrCounterReasonInitial());
        } catch (error) {
          emit(QrCounterReasonFailure(error: error.toString()));
        }
      }
    });
  }
}
