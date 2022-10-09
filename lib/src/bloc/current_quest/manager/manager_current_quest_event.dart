import 'package:equatable/equatable.dart';

import '../../../data/model/quest.dart';

abstract class ManagerCurrentQuestEvent extends Equatable {}

class EmptyCurrentQuest extends ManagerCurrentQuestEvent {
  @override
  String toString() => 'EmptyCurrentQuest';

  @override
  List<Object?> get props => [];
}

class GetCurrentQuest extends ManagerCurrentQuestEvent {
  @override
  String toString() => 'GetCurrentQuest';

  @override
  List<Object?> get props => [];
}

class CreateCurrentQuest extends ManagerCurrentQuestEvent {
  final Quest quest;

  CreateCurrentQuest({required this.quest});

  @override
  String toString() => 'CreateCurrentQuest { quest : $quest}';

  @override
  List<Object?> get props => [quest];
}

class AchieveCurrentQuest extends ManagerCurrentQuestEvent {
  final Quest quest;

  AchieveCurrentQuest({required this.quest});

  @override
  String toString() => 'AchieveCurrentQuest { quest : $quest}';

  @override
  List<Object?> get props => [quest];
}

class DeleteCurrentQuest extends ManagerCurrentQuestEvent {
  final List<Quest> questList;

  DeleteCurrentQuest({required this.questList});

  @override
  String toString() => 'DeleteCurrentQuest { count:  }';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ErrorCurrentQuest extends ManagerCurrentQuestEvent {
  final String? error;

  ErrorCurrentQuest({this.error});

  @override
  String toString() => 'ErrorActiveCurrentQuest { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
