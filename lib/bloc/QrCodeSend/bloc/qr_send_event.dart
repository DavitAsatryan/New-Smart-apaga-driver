part of 'qr_send_bloc.dart';

abstract class QrSendEvent extends Equatable {
  const QrSendEvent();
  @override
  List<Object> get props => [];
}

class QrSendButtonPressed extends QrSendEvent {
  final String qrSendCode;
  final int id;
  const QrSendButtonPressed({
    required this.qrSendCode,
    required this.id,
  });
  @override
  List<Object> get props => [qrSendCode, id];
  @override
  String toString() => 'qrSendButtonPressed {qrSend: $qrSendCode: id $id }';
}
