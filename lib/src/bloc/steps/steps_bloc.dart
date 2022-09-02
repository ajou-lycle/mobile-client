import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:lycle/src/bloc/steps/steps_event.dart';
import 'package:lycle/src/bloc/steps/steps_state.dart';

import 'package:lycle/src/data/model/steps.dart';
import 'package:lycle/src/utils/geolocation_helper.dart';

import '../../utils/health_kit_helper.dart';

class QuestStepsBloc extends Bloc<QuestStepsEvent, QuestStepsState> {
  late QuantityHealthHelper healthHelper;
  GeolocationHelper geolocationHelper = GeolocationHelper();

  QuestStepsBloc({required this.healthHelper}) : super(QuestStepsEmpty()) {
    on<GetQuestSteps>(_mapGetQuestStepsToState);
    on<CreateQuestSteps>(_mapCreateQuestStepsToState);
    on<IncrementQuestSteps>(_mapIncrementQuestStepsToState);
    on<ReplacementQuestSteps>(_mapReplacementQuestStepsToState);
    on<DeniedQuestSteps>(_mapDeniedQuestStepsToState);
    on<ErrorQuestSteps>(_mapErrorQuestStepsToState);
  }

  void handleStepCount(num acceptCount) {
    if (state is! QuestStepsDenied) {
      add(IncrementQuestSteps(count: acceptCount as int));
    }
  }

  void deniedStepCount(num deniedCount) =>
      add(DeniedQuestSteps(count: deniedCount as int));

  QuestStepsState get initialState => QuestStepsEmpty();

  Future<void> _mapGetQuestStepsToState(
      GetQuestSteps event, Emitter<QuestStepsState> emit) async {
    try {
      emit(QuestStepsLoading());

      // TODO: local db에서 데이터 가져오는 로직

      int goal = 0;

      final questSteps = QuestSteps.byTodaySteps(goal);

      healthHelper.observerQueryForQuantityQuery(
          questSteps.startAt, questSteps.finishAt, handleStepCount, deniedStepCount);

      emit(QuestStepsLoaded(questSteps: questSteps));
    } catch (e) {
      emit(QuestStepsError(error: "get error"));
    }
  }

  Future<void> _mapCreateQuestStepsToState(
      CreateQuestSteps event, Emitter<QuestStepsState> emit) async {
    try {
      emit(QuestStepsLoading());

      int goal = 0;
      final questSteps = QuestSteps.byTodaySteps(0);
      healthHelper.observerQueryForQuantityQuery(
          questSteps.startAt, questSteps.finishAt, handleStepCount, deniedStepCount);

      emit(QuestStepsLoaded(questSteps: event.questSteps));
    } catch (e) {
      emit(QuestStepsError(error: "get error"));
    }
  }

  void _mapIncrementQuestStepsToState(
      IncrementQuestSteps event, Emitter<QuestStepsState> emit) async {
    try {
      final questSteps = state.props[0] as QuestSteps;

      emit(QuestStepsUpdated(questSteps: questSteps));

      questSteps.currentSteps = event.count;

      emit(QuestStepsLoaded(questSteps: questSteps));
    } catch (e) {
      emit(QuestStepsError(error: "increment error"));
    }
  }

  Future<void> _mapReplacementQuestStepsToState(
      ReplacementQuestSteps event, Emitter<QuestStepsState> emit) async {
    try {
      emit(QuestStepsLoading());

      int goal = 0;
      // TODO: local db에 저장하기
      QuestSteps questSteps = QuestSteps.byTodaySteps(0);

      emit(QuestStepsLoaded(questSteps: questSteps));
    } catch (e) {
      emit(QuestStepsError(error: "replacement error"));
    }
  }

  void _mapDeniedQuestStepsToState(
      DeniedQuestSteps event, Emitter<QuestStepsState> emit) {
    try {
      QuestStepsDenied questStepsDenied =
          QuestStepsDenied(questSteps: state.props[0] as QuestSteps);

      if (event.count == 2) {
        (questStepsDenied.props[0] as QuestSteps).currentSteps = 0;
        questStepsDenied.props[1] = false;
      }

      emit(questStepsDenied);
    } catch (e) {
      emit(QuestStepsError(error: "Denied error"));
    }
  }

  void _mapErrorQuestStepsToState(
      ErrorQuestSteps event, Emitter<QuestStepsState> emit) {
    emit(QuestStepsError(error: "error"));
  }
}
