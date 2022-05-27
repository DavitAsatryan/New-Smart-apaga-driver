import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_apaga/bloc/Auth_Bloc/bloc/auth_bloc.dart';
import 'package:new_apaga/repository.dart';
part 'see_more_event.dart';
part 'see_more_state.dart';

class SeeMoreBloc extends Bloc<SeeMoreEvent, SeeMoreState> {
  UserRepository repository;
  AuthBloc authenticationBloc;
  List<OrderModel> orders = [];
  SeeMoreBloc({required this.authenticationBloc, required this.repository})
      : super(SeeMoreInitialState()) {
    on<SeeMoreEvent>((event, emit) async {
      if (event is SeeMoreEventPressed) {
        print("SeeMoreEventPressed ____");
        emit(SeeMoreLoadingState());
        try {
          await repository.seeMoreData(event.id).then((value) {
            orders.addAll(value);
          });
          emit(SeeMoreFetchSuccses(orders: orders));
        } catch (e) {
          emit(SeeMoreError(e.toString()));
        }
      }
    });
  }
}
