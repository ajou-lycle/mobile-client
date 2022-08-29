import 'package:equatable/equatable.dart';

import 'package:lycle/src/data/model/steps.dart';

abstract class QuestStepsState extends Equatable {}

class QuestStepsEmpty extends QuestStepsState {
  @override
  List<Object?> get props => [];
}

class QuestStepsLoading extends QuestStepsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class QuestStepsError extends QuestStepsState {
  final String? error;

  QuestStepsError({this.error});

  @override
  String toString() => 'ErrorState { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class QuestStepsLoaded extends QuestStepsState {
  final QuestSteps questSteps;

  QuestStepsLoaded({required this.questSteps});

  @override
  String toString() => 'LoadedState { steps: ${questSteps.currentSteps} }';

  @override
  // TODO: implement props
  List<Object?> get props => [questSteps];
}

class QuestStepsUpdated extends QuestStepsState {
  final QuestSteps questSteps;

  QuestStepsUpdated({required this.questSteps});

  @override
  String toString() => 'UpdatedState { steps: ${questSteps.currentSteps} }';

  @override
  // TODO: implement props
  List<Object?> get props => [questSteps];
}

class QuestStepsDenied extends QuestStepsState {
  final QuestSteps questSteps;
  final bool isDenied = false;

  QuestStepsDenied({required this.questSteps});

  @override
  String toString() => 'DeniedState { steps: ${questSteps.currentSteps}, isDenied: $isDenied }';

  @override
  // TODO: implement props
  List<Object?> get props => [questSteps, isDenied];
}
