import 'package:equatable/equatable.dart';

import '../../../data/model/quest.dart';

abstract class ManagerCurrentQuestState extends Equatable {}

class ActiveCurrentQuestEmpty extends ManagerCurrentQuestState {
  @override
  List<Object?> get props => [];
}

class ActiveCurrentQuestLoading extends ManagerCurrentQuestState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ActiveCurrentQuestError extends ManagerCurrentQuestState {
  final String? error;

  ActiveCurrentQuestError({this.error});

  @override
  String toString() => 'ActiveCurrentQuestError { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class ActiveCurrentQuestLoaded extends ManagerCurrentQuestState {
  final List<Quest> questList;

  ActiveCurrentQuestLoaded({required this.questList});

  @override
  String toString() => 'ActiveCurrentQuestLoaded { questList: $questList }';

  @override
  // TODO: implement props
  List<Object?> get props => [questList];
}

class ActiveCurrentQuestUpdated extends ManagerCurrentQuestState {
  final List<Quest> questList;

  ActiveCurrentQuestUpdated({required this.questList});

  @override
  String toString() => 'ActiveCurrentQuestUpdated { quest: $questList }';

  @override
  // TODO: implement props
  List<Object?> get props => [questList];
}

class ActiveCurrentQuestAchieved extends ManagerCurrentQuestState {
  final List<Quest> questList;

  ActiveCurrentQuestAchieved({required this.questList});

  @override
  String toString() => 'ActiveCurrentQuestAchieved { quest: $questList }';

  @override
  // TODO: implement props
  List<Object?> get props => [questList];
}

class ActiveCurrentQuestDenied extends ManagerCurrentQuestState {
  final Quest quest;
  final bool isDenied = false;

  ActiveCurrentQuestDenied({required this.quest});

  @override
  String toString() =>
      'ActiveCurrentQuestDenied { quest: $quest, isDenied: $isDenied }';

  @override
  // TODO: implement props
  List<Object?> get props => [quest, isDenied];
}
