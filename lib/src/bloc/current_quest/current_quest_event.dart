import 'package:equatable/equatable.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

import '../../data/model/quest.dart';

abstract class CurrentQuestEvent extends Equatable {}

class GetCurrentQuest extends CurrentQuestEvent {
  @override
  String toString() => 'GetQuest ';

  @override
  List<Object?> get props => [];
}

class CreateCurrentQuest extends CurrentQuestEvent {
  final Quest quest;

  CreateCurrentQuest({required this.quest});

  @override
  String toString() => 'CreateToday { quest : $quest}';

  @override
  List<Object?> get props => [quest];
}

class IncrementCurrentQuest extends CurrentQuestEvent {
  final int index;
  final int count;

  IncrementCurrentQuest({required this.index, required this.count});

  @override
  String toString() => 'IncrementToday { index: $index, count : $count }';

  @override
  // TODO: implement props
  List<Object?> get props => [index, count];
}

class AchieveCurrentQuest extends CurrentQuestEvent {
  final Quest quest;

  AchieveCurrentQuest({required this.quest});

  @override
  String toString() => 'AchieveQuest : $quest';

  @override
  // TODO: implement props
  List<Object?> get props => [quest];
}

class DeniedCurrentQuest extends CurrentQuestEvent {
  final int count;

  DeniedCurrentQuest({required this.count});

  @override
  String toString() => 'DeniedToday { count: $count }';

  @override
  // TODO: implement props
  List<Object?> get props => [count];
}

class ErrorCurrentQuest extends CurrentQuestEvent {
  final String? error;

  ErrorCurrentQuest({this.error});

  @override
  String toString() => 'ErrorQuest { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
