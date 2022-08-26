import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pedometer/pedometer.dart';

import 'package:lycle/src/blocs/steps/steps_events.dart';
import 'package:lycle/src/blocs/steps/steps_state.dart';

import 'package:lycle/src/data/model/steps.dart';

class TodayStepsBloc extends Bloc<TodayStepsEvent, TodayStepsState> {
  TodayStepsBloc() : super(TodayStepsEmpty()) {
    Pedometer.stepCountStream.listen(_onStepCount).onError(_onStepCountError);

    _mapEventToState();
  }

  Future<void> _onStepCount(StepCount event) async {
    print(event);
    if (state is TodayStepsLoaded) {
      final DateTime now = DateTime.now();
      final Steps steps = state.props[0] as Steps;

      bool isDatePassed = (now.day - steps.startAt.day) != 0 ? true : false;

      if (isDatePassed) {
        add(ReplacementTodaySteps(steps: steps));
      } else {
        add(IncrementTodaySteps(count: event.steps));
      }
    } else if (state is TodayStepsEmpty) {
      // TODO: local db에 오늘 날짜 데이터가 없다면 create, 있다면 get event 발생시키기
      Steps steps = Steps.byTodaySteps();

      add(CreateTodaySteps(steps: steps));
    } else {
      print(state);
    }
  }

  void _onStepCountError(error) {
    print(error.toString());
  }

  TodayStepsState get initialState => TodayStepsEmpty();

  void _mapEventToState() {
    on<GetTodaySteps>(_mapGetTodayStepsToState);
    on<CreateTodaySteps>(_mapCreateTodayStepsToState);
    on<IncrementTodaySteps>(_mapIncrementTodayStepsToState);
    on<ReplacementTodaySteps>(_mapReplacementTodayStepsToState);
    on<SensorErrorTodaySteps>(_mapSensorErrorTodayStepsToState);
  }

  Future<void> _mapGetTodayStepsToState(
      GetTodaySteps event, Emitter<TodayStepsState> emit) async {
    try {
      emit(TodayStepsLoading());

      final steps = Steps.byTodaySteps();

      emit(TodayStepsLoaded(steps: steps));
    } catch (e) {
      emit(TodayStepsError(error: "get error"));
    }
  }

  Future<void> _mapCreateTodayStepsToState(
      CreateTodaySteps event, Emitter<TodayStepsState> emit) async {
    try {
      emit(TodayStepsLoading());

      event.steps.previousSteps = (await Pedometer.stepCountStream.first).steps;
      event.steps.currentSteps = 0;

      emit(TodayStepsLoaded(steps: event.steps));

      print(state);
    } catch (e) {
      emit(TodayStepsError(error: "get error"));
    }
  }

  void _mapIncrementTodayStepsToState(
      IncrementTodaySteps event, Emitter<TodayStepsState> emit) async {
    try {
      final Steps steps = state.props[0] as Steps;

      steps.currentSteps += (event.count - steps.previousSteps);

      emit(TodayStepsLoaded(steps: steps));
    } catch (e) {
      emit(TodayStepsError(error: "increment error"));
    }
  }

  Future<void> _mapReplacementTodayStepsToState(
      ReplacementTodaySteps event, Emitter<TodayStepsState> emit) async {
    try {
      emit(TodayStepsLoading());

      final Steps yesterdaySteps = state.props[0] as Steps;

      // TODO: local db에 저장하기
      Steps todaySteps = Steps.byTodaySteps();

      emit(TodayStepsLoaded(steps: todaySteps));
    } catch (e) {
      emit(TodayStepsError(error: "replacement error"));
    }
  }

  void _mapSensorErrorTodayStepsToState(
      SensorErrorTodaySteps event, Emitter<TodayStepsState> emit) {
    emit(TodayStepsError(error: "sensor error"));
  }
}
