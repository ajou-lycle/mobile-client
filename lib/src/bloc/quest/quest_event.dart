import 'package:equatable/equatable.dart';

abstract class QuestEvent extends Equatable {}

class GetQuest extends QuestEvent {
  @override
  String toString() => 'GetQuest';

  @override
  List<Object?> get props => [];
}

class AvailableQuest extends QuestEvent {
  @override
  String toString() => 'AvailableQuest';

  @override
  List<Object?> get props => [];
}

class ErrorQuest extends QuestEvent {
  final String? error;

  ErrorQuest({this.error});

  @override
  String toString() => 'ErrorQuest { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
