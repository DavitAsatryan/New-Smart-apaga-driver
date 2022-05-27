part of 'qr_counter_reason_bloc.dart';

abstract class QrCounterReasonEvent extends Equatable {
  const QrCounterReasonEvent();
  @override
  List<Object> get props => [];
}

class QrCounterReasonButtonPressed extends QrCounterReasonEvent {
  final int pickup_id;
  final String comment_driver;
  final String status;
  const QrCounterReasonButtonPressed({
    required this.pickup_id,
    required this.comment_driver,
    required this.status,
  });
  @override
  List<Object> get props => [pickup_id, comment_driver];
  @override
  String toString() =>
      'QrCounterReason {comment_driver: $comment_driver, pickup_id: $pickup_id }';
}
