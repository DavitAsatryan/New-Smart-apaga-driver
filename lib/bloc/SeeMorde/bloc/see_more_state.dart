part of 'see_more_bloc.dart';

abstract class SeeMoreState extends Equatable {
  const SeeMoreState();
  @override
  List<Object> get props => [];
}

class SeeMoreInitialState extends SeeMoreState {}

class SeeMoreLoadingState extends SeeMoreState {}

class SeeMoreFetchSuccses extends SeeMoreState {
  List<OrderModel> orders = [];
  SeeMoreFetchSuccses({required this.orders});
}

class SeeMoreError extends SeeMoreState {
  String error;
  SeeMoreError(this.error);
}
