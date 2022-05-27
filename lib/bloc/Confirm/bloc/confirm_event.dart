part of 'confirm_bloc.dart';
abstract class ConfirmEvent extends Equatable {
  const ConfirmEvent();
  @override
  List<Object> get props => [];}
class ConfirmButtonPressed extends ConfirmEvent {
  final int pickupId;
  const ConfirmButtonPressed({
    required this.pickupId,
  });
  @override
  List<Object> get props => [pickupId];
  @override
  String toString() => 'ConfirmButtonPressed {Confirm: $pickupId }';
}