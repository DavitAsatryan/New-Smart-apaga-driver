import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import '../../repository.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;
  final AuthBloc authenticationBloc;
  RegisterBloc({required this.userRepository, required this.authenticationBloc})
      : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) async {
      print("register");
      if (event is RegisternButtonPressed) {
        print("registerjjjjjjjjj");
        emit(RegisterLoading());
        try {
          var token = await FlutterSession().get("token");
          final user = await userRepository.register(UserRegister(
              fullName: event.fullname,
              phoneNumber: event.phoneNumber,
              carNumber: event.carNumber,
              carName: event.carName,
              carColor: event.carColor,
              carCapacity: event.carCapacity,
              password: event.password,
              firebase_token: event.firebase_token,
              ));
          authenticationBloc.add(LoggedIn(token: token));
          emit(RegisterInitial());
        } catch (error) {
          print(error);
          emit(RegisterFailure(error: error.toString()));
        }
      }
    });
    // @override
    // Stream<RegisterState> mapEventToState(RegisterEvent event) async* {}
  }
}
