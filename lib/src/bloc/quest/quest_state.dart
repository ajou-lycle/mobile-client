import 'package:equatable/equatable.dart';

import '../../data/model/quest.dart';

abstract class QuestState extends Equatable {}

class QuestEmpty extends QuestState {
  @override
  List<Object?> get props => [];
}

class QuestLoading extends QuestState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class QuestError extends QuestState {
  final String? error;

  QuestError({this.error});

  @override
  String toString() => 'ErrorState { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class QuestLoaded extends QuestState {
  final List<List<Quest>> questList;

  QuestLoaded({required this.questList});

  @override
  String toString() => 'QuestLoaded { questList: $questList }';

  @override
  // TODO: implement props
  List<Object?> get props => [questList];
}

class QuestUpdated extends QuestState {
  final List<List<Quest>> questList;

  QuestUpdated({required this.questList});

  @override
  String toString() => 'QuestUpdated { questList: $questList }';

  @override
  // TODO: implement props
  List<Object?> get props => [questList];
}
