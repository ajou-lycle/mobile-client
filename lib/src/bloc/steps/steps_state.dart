import 'package:equatable/equatable.dart';

import 'package:lycle/src/data/model/steps.dart';

abstract class TodayStepsState extends Equatable {}

class TodayStepsEmpty extends TodayStepsState {
  @override
  List<Object?> get props => [];
}

class TodayStepsLoading extends TodayStepsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TodayStepsError extends TodayStepsState {
  final String? error;

  TodayStepsError({this.error});

  @override
  String toString() => 'ErrorState { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class TodayStepsLoaded extends TodayStepsState {
  final Steps steps;

  TodayStepsLoaded({required this.steps});

  @override
  String toString() => 'LoadedState { steps: ${steps.currentSteps} }';

  @override
  // TODO: implement props
  List<Object?> get props => [steps];
}

class TodayStepsUpdated extends TodayStepsState {
  final Steps steps;

  TodayStepsUpdated({required this.steps});

  @override
  String toString() => 'UpdatedState { steps: ${steps.currentSteps} }';

  @override
  // TODO: implement props
  List<Object?> get props => [steps];
}
