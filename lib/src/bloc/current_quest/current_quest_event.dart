import 'package:equatable/equatable.dart';

import '../../data/model/quest.dart';

abstract class CurrentQuestEvent extends Equatable {}

class GetCurrentQuest extends CurrentQuestEvent {
  @override
  String toString() => 'GetCurrentQuest';

  @override
  List<Object?> get props => [];
}

class CreateCurrentQuest extends CurrentQuestEvent {
  final Quest quest;

  CreateCurrentQuest({required this.quest});

  @override
  String toString() => 'CreateCurrentQuest { quest : $quest}';

  @override
  List<Object?> get props => [quest];
}

class ReplaceCurrentQuest extends CurrentQuestEvent {
  final Quest quest;

  ReplaceCurrentQuest({required this.quest});

  @override
  String toString() => 'ReplaceCurrentQuest { quest : $quest}';

  @override
  List<Object?> get props => [quest];
}

class IncrementCurrentQuest extends CurrentQuestEvent {
  final int index;
  final int count;

  IncrementCurrentQuest({required this.index, required this.count});

  @override
  String toString() =>
      'IncrementCurrentQuest { index: $index, count : $count }';

  @override
  // TODO: implement props
  List<Object?> get props => [index, count];
}

class AchieveCurrentQuest extends CurrentQuestEvent {
  final Quest quest;

  AchieveCurrentQuest({required this.quest});

  @override
  String toString() => 'AchieveCurrentQuest : $quest';

  @override
  // TODO: implement props
  List<Object?> get props => [quest];
}

class DeniedCurrentQuest extends CurrentQuestEvent {
  final int count;

  DeniedCurrentQuest({required this.count});

  @override
  String toString() => 'DeniedCurrentQuest { count: $count }';

  @override
  // TODO: implement props
  List<Object?> get props => [count];
}

class ErrorCurrentQuest extends CurrentQuestEvent {
  final String? error;

  ErrorCurrentQuest({this.error});

  @override
  String toString() => 'ErrorCurrentQuest { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
