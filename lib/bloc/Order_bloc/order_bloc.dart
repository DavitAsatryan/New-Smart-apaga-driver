import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:new_apaga/Cubit/Internet/cubit/internet_cubit.dart';
import 'package:new_apaga/Enum/internetEnum.dart';
import '../../repository.dart';
import '../Auth_Bloc/bloc/auth_bloc.dart';
part 'order_event.dart';
part 'order_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  //late StreamSubscription internetStreamSubscription;
  static var orderAPI = 'https://jsonplaceholder.typicode.com/posts';
  UserRepository repository;
  AuthBloc authenticationBloc;
  List<OrderModel> orders = [];
  // void data() {
  //   repository.orderMassage().then((value) {
  //     orders.addAll(value);
  //   });
  // }
  ListBloc({
    required this.authenticationBloc,
    required this.repository,
  }) : super(InitialState()) {
    on<ListEvent>((event, emit) async {
      orders.clear();
      if (event is FetchEvent) {
        print("fetchEvent ____");
        emit(LoadingState());
        try {
          await repository.pickups([], 1).then((value) {
            orders.addAll(value);
          });
          emit(FetchSuccses(orders: orders));
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      }
      if (event is SectionButtonPressed) {
        orders.clear();
        print("SectionButtonPressed  ____");
        emit(LoadingState());
        try {
          orders = await repository.pickups(event.section, 2);
          emit(SectionsSuccses(orders: orders));
          print("ssss");
          print(event.section);
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      }
      if (event is SectionMyButtonPressed) {
        orders.clear();
        print("SectionmyButtonPressed  ____");
        emit(LoadingState());
        try {
          orders = await repository.orderMassage(event.section, 4);
          emit(SectionsMySuccses(orders: orders));
          print("my filtr $orders");
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      }
      if (event is AssignedEvent) {
        orders.clear();

        emit(LoadingState());
        try {
          orders = await repository.ordersListGet(event.assignedStatus);
          emit(AssignedSuccses(orders: orders));
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      }
      if (event is CompletedEvent) {
        orders.clear();
        print("__");
        emit(LoadingState());
        try {
          orders = await repository.ordersListGet(event.completedStatus);
          emit(CompletedSuccses(orders: orders));
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      }
      if (event is IncompleteEvent) {
        orders.clear();
        print("____");
        emit(LoadingState());
        try {
          orders = await repository.ordersListGet(event.incompleteStatus);
          emit(IncompleteSuccses(orders: orders));
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      }
      if (event is MissedEvent) {
        orders.clear();
        print(" ____");
        emit(LoadingState());
        try {
          orders = await repository.ordersListGet(event.missedStatus);
          emit(MissedSuccses(orders: orders));
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      }
      // await monitorInternetBlocCubit(event, emit);
    });
    // Future<StreamSubscription<InternetState>> monitorInternetBlocCubit(
    //     StreamSubscription internetStreamSubscription,
    //     ListEvent event,
    //     Emitter<ListState> emit) async {
    //   return internetStreamSubscription =
    //       internetCubit.stream.listen((internetState) async {
    //     if (internetState is InternetConnected &&
    //         internetState.connectionTYpe == ConnectionType.Wifi) {}
    //   });
    // }
    @override
    Future<void> close() {
      ListBloc(
        authenticationBloc: authenticationBloc,
        repository: repository,
      ).close();
      return super.close();
    }
  }
}
