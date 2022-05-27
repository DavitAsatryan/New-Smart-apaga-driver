import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_apaga/bloc/Confirm/bloc/confirm_bloc.dart';
import 'package:new_apaga/bloc/ForgetPassword_Bloc/bloc/forget_password_bloc.dart';
import 'package:new_apaga/bloc/ForgetPassword_Bloc/bloc/forget_password_new_bloc.dart';
import 'package:new_apaga/bloc/ForgetPassword_Bloc/bloc/pincode_forget_pass_bloc.dart';
import 'package:new_apaga/bloc/Notification/bloc/notification_bloc.dart';
import 'package:new_apaga/bloc/QRCounterAndReason/bloc/qr_counter_reason_bloc.dart';
import 'package:new_apaga/bloc/QrCodeSend/bloc/qr_send_bloc.dart';
import 'package:new_apaga/bloc/Register_bloc/register_bloc.dart';
import 'package:new_apaga/bloc/SeeMorde/bloc/see_more_bloc.dart';
import 'package:new_apaga/bloc/profileEdit_send/Password_Bloc/bloc/password_change_bloc.dart';
import 'package:new_apaga/bloc/profileEdit_send/Password_Bloc/bloc/profile_edit_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthBloc() : super(AuthenticationUninitialized()) {
    on<AuthenticationEvent>((event, emit) {
      if (event is LoggedIn) {
        emit(AuthenticationLoading());
        emit(AuthenticationAuthenticated());
      }
      if (event is NotificationFetchSuccses) {
        emit(AuthenticationLoading());
        emit(AuthenticationAuthenticated());
      }
      if (event is ConfirmButtonPressed) {
        emit(AuthenticationLoading());
        emit(AuthenticationAuthenticated());
      }
      if (event is ProfileEditButtonPressed) {
        emit(AuthenticationLoading());
        emit(AuthenticationAuthenticated());
      }
      if (event is SeeMoreEventPressed) {
        emit(AuthenticationLoading());
        emit(AuthenticationAuthenticated());
      }
      if (event is QrCounterReasonButtonPressed) {
        emit(AuthenticationLoading());
        emit(AuthenticationAuthenticated());
      }
      if (event is QrSendButtonPressed) {
        emit(AuthenticationLoading());
        emit(AuthenticationAuthenticated());
      }
      if (event is PasswordChangeButtonPressed) {
        emit(AuthenticationLoading());
        emit(AuthenticationAuthenticated());
      }
      if (event is RegisternButtonPressed) {
        emit(AuthenticationLoading());
        emit(AuthenticationAuthenticated());
      }
      if (event is LoggedOut) {
        emit(AuthenticationLoading());
        emit(AuthenticationUnauthenticated());
      }
    });
  }
}
