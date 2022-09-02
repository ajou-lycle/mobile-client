import 'package:equatable/equatable.dart';

import '../../data/model/steps.dart';

abstract class QuestStepsEvent extends Equatable {}

class GetQuestSteps extends QuestStepsEvent {
  @override
  String toString() => 'GetTodaySteps';

  @override
  List<Object?> get props => [];
}

class CreateQuestSteps extends QuestStepsEvent {
  final QuestSteps questSteps;

  CreateQuestSteps({required this.questSteps});

  @override
  String toString() => 'CreateTodaySteps : $questSteps';

  @override
  List<Object?> get props => [questSteps];
}

class IncrementQuestSteps extends QuestStepsEvent {
  final int count;

  IncrementQuestSteps({required this.count});

  @override
  String toString() => 'IncrementTodaySteps : $count';

  @override
  // TODO: implement props
  List<Object?> get props => [count];
}

class ReplacementQuestSteps extends QuestStepsEvent {
  final QuestSteps questSteps;

  ReplacementQuestSteps({required this.questSteps});

  @override
  String toString() => 'ReplacementTodaySteps : $questSteps';

  @override
  // TODO: implement props
  List<Object?> get props => [questSteps];
}

class DeniedQuestSteps extends QuestStepsEvent {
  final int count;

  DeniedQuestSteps({required this.count});

  @override
  String toString() => 'DeniedTodaySteps { count: $count }';

  @override
  // TODO: implement props
  List<Object?> get props => [count];
}

class ErrorQuestSteps extends QuestStepsEvent {
  final String? error;

  ErrorQuestSteps({this.error});

  @override
  String toString() => 'ErrorQuestSteps { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
