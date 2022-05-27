part of 'see_more_bloc.dart';

abstract class SeeMoreEvent extends Equatable {
  const SeeMoreEvent();
  @override
  List<Object> get props => [];
}

class SeeMoreEventPressed extends SeeMoreEvent {
  final int id;
  const SeeMoreEventPressed({
    required this.id,
  });
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'SeeMoreEvent {SeeMoreEvent: $id }';
}
