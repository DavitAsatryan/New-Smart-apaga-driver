import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_apaga/repository.dart';
import '../../Auth_Bloc/bloc/auth_bloc.dart';
part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  UserRepository repository;
  AuthBloc authenticationBloc;
  List<NotificationModel> notificationList = [];
  NotificationBloc({required this.authenticationBloc, required this.repository})
      : super(NotificationInitialState()) {
    on<NotificationEvent>((event, emit) async {
      notificationList.clear();
      if (event is NotificationFetchEvent) {
        print("NotificationfetchEvent ____");
        emit(NotificationLoadingState());
        try {
          await repository.notification().then((value) {
            notificationList.addAll(value);
          });
          emit(NotificationFetchSuccses(notification: notificationList));
        } catch (e) {
          emit(NotificationErrorState(e.toString()));
        }
      } else if (event is NotificationDelete) {
        notificationList.clear();
        await repository.deleteItem(event.id);
        print("NotificationdeleteIvent ____");
        emit(NotificationLoadingState());
        try {
          emit(NotificationDeleeteSuccses());
        } catch (e) {
          emit(NotificationErrorState(e.toString()));
        }
      }
    });
    // @override
    // Future<void> close() {
    //   NotificationBloc(
    //           authenticationBloc: authenticationBloc, repository: repository)
    //       .close();
    //   return super.close();
    // }
  }
}
