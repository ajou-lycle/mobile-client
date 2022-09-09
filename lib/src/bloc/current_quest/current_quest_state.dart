import 'package:equatable/equatable.dart';

import '../../data/model/quest.dart';

abstract class CurrentQuestState extends Equatable {}

class CurrentQuestEmpty extends CurrentQuestState {
  @override
  List<Object?> get props => [];
}

class CurrentQuestLoading extends CurrentQuestState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CurrentQuestError extends CurrentQuestState {
  final String? error;

  CurrentQuestError({this.error});

  @override
  String toString() => 'ErrorState { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class CurrentQuestLoaded extends CurrentQuestState {
  final List<Quest> questList;

  CurrentQuestLoaded({required this.questList});

  @override
  String toString() => 'LoadedState { questList: $questList }';

  @override
  // TODO: implement props
  List<Object?> get props => [questList];
}

class CurrentQuestUpdated extends CurrentQuestState {
  final List<Quest> questList;

  CurrentQuestUpdated({required this.questList});

  @override
  String toString() => 'UpdatedState { quest: $questList }';

  @override
  // TODO: implement props
  List<Object?> get props => [questList];
}

class CurrentQuestAchieved extends CurrentQuestState {
  final List<Quest> questList;

  CurrentQuestAchieved({required this.questList});

  @override
  String toString() => 'AchievedState { quest: $questList }';

  @override
  // TODO: implement props
  List<Object?> get props => [questList];
}

class CurrentQuestDenied extends CurrentQuestState {
  final Quest quest;
  final bool isDenied = false;

  CurrentQuestDenied({required this.quest});

  @override
  String toString() =>
      'DeniedState { quest: $quest, isDenied: $isDenied }';

  @override
  // TODO: implement props
  List<Object?> get props => [quest, isDenied];
}
