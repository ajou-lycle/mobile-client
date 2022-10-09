import 'package:equatable/equatable.dart';

import '../../../data/model/quest.dart';

abstract class ManagerCurrentQuestState extends Equatable {}

class ManagerCurrentQuestEmpty extends ManagerCurrentQuestState {
  @override
  List<Object?> get props => [];
}

class ManagerCurrentQuestLoading extends ManagerCurrentQuestState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ManagerCurrentQuestError extends ManagerCurrentQuestState {
  final String? error;

  ManagerCurrentQuestError({this.error});

  @override
  String toString() => 'ManagerCurrentQuestError { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class ManagerCurrentQuestLoaded extends ManagerCurrentQuestState {
  final List<Quest> questList;

  ManagerCurrentQuestLoaded({required this.questList});

  @override
  String toString() => 'ManagerCurrentQuestLoaded { questList: $questList }';

  @override
  // TODO: implement props
  List<Object?> get props => [questList];
}

class ManagerCurrentQuestCreated extends ManagerCurrentQuestState {
  final List<Quest> questList;

  ManagerCurrentQuestCreated({required this.questList});

  @override
  String toString() => 'ManagerCurrentQuestCreated { quest: $questList }';

  @override
  // TODO: implement props
  List<Object?> get props => [questList];
}

class ManagerCurrentQuestUpdated extends ManagerCurrentQuestState {
  final List<Quest> questList;

  ManagerCurrentQuestUpdated({required this.questList});

  @override
  String toString() => 'ManagerCurrentQuestUpdated { quest: $questList }';

  @override
  // TODO: implement props
  List<Object?> get props => [questList];
}
