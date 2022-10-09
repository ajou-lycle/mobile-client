import 'package:equatable/equatable.dart';

import '../../../data/model/quest.dart';

abstract class ActiveCurrentQuestEvent extends Equatable {}

class EmptyActiveCurrentQuest extends ActiveCurrentQuestEvent {
  @override
  String toString() => 'EmptyActiveCurrentQuest';

  @override
  List<Object?> get props => [];
}

class GetActiveCurrentQuest extends ActiveCurrentQuestEvent {
  @override
  String toString() => 'GetActiveCurrentQuest';

  @override
  List<Object?> get props => [];
}

class CreateActiveCurrentQuest extends ActiveCurrentQuestEvent {
  final Quest quest;

  CreateActiveCurrentQuest({required this.quest});

  @override
  String toString() => 'CreateActiveCurrentQuest { quest : $quest}';

  @override
  List<Object?> get props => [quest];
}

class ReplaceActiveCurrentQuest extends ActiveCurrentQuestEvent {
  final Quest quest;

  ReplaceActiveCurrentQuest({required this.quest});

  @override
  String toString() => 'ReplaceActiveCurrentQuest { quest : $quest}';

  @override
  List<Object?> get props => [quest];
}

class IncrementActiveCurrentQuest extends ActiveCurrentQuestEvent {
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

class AchieveActiveCurrentQuest extends ActiveCurrentQuestEvent {
  final Quest quest;

  AchieveActiveCurrentQuest({required this.quest});

  @override
  String toString() => 'AchieveActiveCurrentQuest : $quest';

  @override
  // TODO: implement props
  List<Object?> get props => [quest];
}

class DeniedActiveCurrentQuest extends ActiveCurrentQuestEvent {
  final int count;

  DeniedActiveCurrentQuest({required this.count});

  @override
  String toString() => 'DeniedActiveCurrentQuest { count: $count }';

  @override
  // TODO: implement props
  List<Object?> get props => [count];
}

class ErrorActiveCurrentQuest extends ActiveCurrentQuestEvent {
  final String? error;

  ErrorActiveCurrentQuest({this.error});

  @override
  String toString() => 'ErrorActiveCurrentQuest { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
