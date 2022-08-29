import 'package:equatable/equatable.dart';

import '../../data/model/steps.dart';

abstract class TodayStepsEvent extends Equatable {}

class GetTodaySteps extends TodayStepsEvent {
  @override
  String toString() => 'GetTodaySteps';

  @override
  List<Object?> get props => [];
}

class CreateTodaySteps extends TodayStepsEvent {
  final Steps steps;

  CreateTodaySteps({required this.steps});

  @override
  String toString() => 'CreateTodaySteps : $steps';

  @override
  List<Object?> get props => [steps];
}

class IncrementTodaySteps extends TodayStepsEvent {
  final int count;

  IncrementTodaySteps({required this.count});

  @override
  String toString() => 'IncrementTodaySteps : $count';

  @override
  // TODO: implement props
  List<Object?> get props => [count];
}

class ReplacementTodaySteps extends TodayStepsEvent {
  final Steps steps;

  ReplacementTodaySteps({required this.steps});

  @override
  String toString() => 'ReplacementTodaySteps : $steps';

  @override
  // TODO: implement props
  List<Object?> get props => [steps];
}

class ErrorTodaySteps extends TodayStepsEvent {
  final String? error;

  ErrorTodaySteps({this.error});

  @override
  String toString() => 'ErrorTodaySteps { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
