import 'package:equatable/equatable.dart';

import '../../../data/model/quest.dart';

abstract class ManagerCurrentQuestEvent extends Equatable {}

class EmptyActiveCurrentQuest extends ManagerCurrentQuestEvent {
  @override
  String toString() => 'EmptyActiveCurrentQuest';

  @override
  List<Object?> get props => [];
}

class GetActiveCurrentQuest extends ManagerCurrentQuestEvent {
  @override
  String toString() => 'GetActiveCurrentQuest';

  @override
  List<Object?> get props => [];
}

class CreateActiveCurrentQuest extends ManagerCurrentQuestEvent {
  final Quest quest;

  CreateActiveCurrentQuest({required this.quest});

  @override
  String toString() => 'CreateActiveCurrentQuest { quest : $quest}';

  @override
  List<Object?> get props => [quest];
}

class ReplaceActiveCurrentQuest extends ManagerCurrentQuestEvent {
  final Quest quest;

  ReplaceActiveCurrentQuest({required this.quest});

  @override
  String toString() => 'ReplaceActiveCurrentQuest { quest : $quest}';

  @override
  List<Object?> get props => [quest];
}

class IncrementActiveCurrentQuest extends ManagerCurrentQuestEvent {
  final int index;
  final int count;

  IncrementActiveCurrentQuest({required this.index, required this.count});

  @override
  String toString() =>
      'IncrementActiveCurrentQuest { index: $index, count : $count }';

  @override
  // TODO: implement props
  List<Object?> get props => [index, count];
}

class AchieveActiveCurrentQuest extends ManagerCurrentQuestEvent {
  final Quest quest;

  AchieveActiveCurrentQuest({required this.quest});

  @override
  String toString() => 'AchieveActiveCurrentQuest : $quest';

  @override
  // TODO: implement props
  List<Object?> get props => [quest];
}

class DeniedActiveCurrentQuest extends ManagerCurrentQuestEvent {
  final int count;

  DeniedActiveCurrentQuest({required this.count});

  @override
  String toString() => 'DeniedActiveCurrentQuest { count: $count }';

  @override
  // TODO: implement props
  List<Object?> get props => [count];
}

class ErrorActiveCurrentQuest extends ManagerCurrentQuestEvent {
  final String? error;

  ErrorActiveCurrentQuest({this.error});

  @override
  String toString() => 'ErrorActiveCurrentQuest { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
