part of 'order_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();
  @override
  List<Object> get props => [];
}

class FetchEvent extends ListEvent {}

class SectionButtonPressed extends ListEvent {
  final List<String> section;
  const SectionButtonPressed({
    required this.section,
  });
  @override
  List<Object> get props => [section];
  @override
  String toString() => 'SectionButtonPressed {Section: $section }';
}

class SectionMyButtonPressed extends ListEvent {
  final List<String> section;
  const SectionMyButtonPressed({
    required this.section,
  });
  @override
  List<Object> get props => [section];
  @override
  String toString() => 'SectionMyButtonPressed {SectionMy: $section }';
}

class UnassignedEvent extends ListEvent {}

class AssignedEvent extends ListEvent {
  String assignedStatus;
  AssignedEvent({required this.assignedStatus});
}

class CompletedEvent extends ListEvent {
  String completedStatus;
  CompletedEvent({required this.completedStatus});
}

class IncompleteEvent extends ListEvent {
  String incompleteStatus;
  IncompleteEvent({required this.incompleteStatus});
}

class MissedEvent extends ListEvent {
  String missedStatus;
  MissedEvent({required this.missedStatus});
}
