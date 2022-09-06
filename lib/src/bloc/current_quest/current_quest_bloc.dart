import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

import 'package:lycle/src/bloc/current_quest/current_quest_event.dart';
import 'package:lycle/src/bloc/current_quest/current_quest_state.dart';

import 'package:lycle/src/repository/quest/quest_repository.dart';

import '../../data/model/quest.dart';
import '../../utils/health_kit_helper.dart';

class CurrentQuestBloc extends Bloc<CurrentQuestEvent, CurrentQuestState> {
  late QuantityHealthHelper healthHelper;
  final QuestRepository questRepository;

  CurrentQuestBloc({required this.healthHelper, required this.questRepository})
      : super(CurrentQuestEmpty()) {
    on<GetCurrentQuest>(_mapGetCurrentQuestToState);
    on<CreateCurrentQuest>(_mapCreateCurrentQuestToState);
    on<IncrementCurrentQuest>(_mapIncrementCurrentQuestToState);
    on<AchieveCurrentQuest>(_mapAchieveCurrentQuestToState);
    on<DeniedCurrentQuest>(_mapDeniedCurrentQuestToState);
    on<ErrorCurrentQuest>(_mapErrorCurrentQuestToState);
  }

  void handleCount(int index, num acceptCount) {
    if (state is! CurrentQuestDenied) {
      add(IncrementCurrentQuest(index: index, count: acceptCount as int));
    }
  }

  void deniedCount(QuantityType type, num deniedCount) =>
      add(DeniedCurrentQuest(count: deniedCount as int));

  CurrentQuestState get initialState => CurrentQuestEmpty();

  Future<void> _mapGetCurrentQuestToState(
      GetCurrentQuest event, Emitter<CurrentQuestState> emit) async {
    try {
      emit(CurrentQuestLoading());

      final questList = await questRepository.getAllCurrentQuest();

      healthHelper.observerQueryForQuantityQuery(
          DateTime.now().add(const Duration(days: -1)),
          DateTime.now().add(const Duration(days: 1)),
          questList,
          handleCount,
          deniedCount);

      emit(CurrentQuestLoaded(questList: questList));
    } catch (e) {
      emit(CurrentQuestError(error: "get error"));
    }
  }

  Future<void> _mapCreateCurrentQuestToState(
      CreateCurrentQuest event, Emitter<CurrentQuestState> emit) async {
    try {
      List<Quest> questList = List<Quest>.empty(growable: true);

      if (state is CurrentQuestLoaded) {
        questList = state.props[0] as List<Quest>;
      }

      emit(CurrentQuestLoading());

      questList.add(event.quest);

      healthHelper.observerQueryForQuantityQuery(
          DateTime.now().add(const Duration(days: -1)),
          DateTime.now().add(const Duration(days: 1)),
          questList,
          handleCount,
          deniedCount);

      emit(CurrentQuestLoaded(questList: questList));
    } catch (e) {
      emit(CurrentQuestError(error: "get error"));
    }
  }

  void _mapIncrementCurrentQuestToState(
      IncrementCurrentQuest event, Emitter<CurrentQuestState> emit) async {
    try {
      if (state is CurrentQuestLoaded) {
        final questList = state.props[0] as List<Quest>;
        final Quest quest = questList[event.index];

        if (quest.goal <= event.count) {
          return;
        }

        emit(CurrentQuestUpdated(questLsit: questList));
        quest.achievement = event.count;
        emit(CurrentQuestLoaded(questList: questList));
      }
    } catch (e) {
      emit(CurrentQuestError(error: "increment error"));
    }
  }

  Future<void> _mapAchieveCurrentQuestToState(
      AchieveCurrentQuest event, Emitter<CurrentQuestState> emit) async {
    try {
      if (state is CurrentQuestLoaded) {
        Quest quest = state.props[0] as Quest;

        emit(CurrentQuestLoading());

        await questRepository.insertQuest(quest);

        emit(CurrentQuestEmpty());
      }
    } catch (e) {
      emit(CurrentQuestError(error: "replacement error"));
    }
  }

  void _mapDeniedCurrentQuestToState(
      DeniedCurrentQuest event, Emitter<CurrentQuestState> emit) {
    try {
      CurrentQuestDenied questDenied =
          CurrentQuestDenied(quest: state.props[0] as Quest);

      if (event.count == 2) {
        (questDenied.props[0] as Quest).achievement = 0;
        questDenied.props[1] = false;
      }

      emit(questDenied);
    } catch (e) {
      emit(CurrentQuestError(error: "Denied error"));
    }
  }

  void _mapErrorCurrentQuestToState(
      ErrorCurrentQuest event, Emitter<CurrentQuestState> emit) {
    emit(CurrentQuestError(error: "error"));
  }
}
