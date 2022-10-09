import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

import '../../../data/enum/quest_data_type.dart';
import '../../../data/model/quest.dart';
import '../../../data/repository/quest_repository.dart';

import 'active_current_quest_event.dart';
import 'active_current_quest_state.dart';

class ActiveCurrentQuestBloc
    extends Bloc<ActiveCurrentQuestEvent, ActiveCurrentQuestState> {
  final QuestRepository questRepository;
  final QuestDataType questDataType;

  ActiveCurrentQuestBloc(
      {required this.questRepository, required this.questDataType})
      : super(ActiveCurrentQuestEmpty()) {
    on<EmptyActiveCurrentQuest>(_mapEmptyActiveCurrentQuestToState);
    on<CreateActiveCurrentQuest>(_mapCreateActiveCurrentQuestToState);
    on<IncrementActiveCurrentQuest>(_mapIncrementActiveCurrentQuestToState);
    on<AchieveActiveCurrentQuest>(_mapAchieveActiveCurrentQuestToState);
    on<ErrorActiveCurrentQuest>(_mapErrorActiveCurrentQuestToState);
  }

  void handleCount(QuantityType quantityType, num acceptCount) {
    if (state is ActiveCurrentQuestLoaded) {
      if ((state as ActiveCurrentQuestLoaded)
          .quest
          .readTypes
          .contains(quantityType)) {
        add(IncrementActiveCurrentQuest(
          count: acceptCount as int,
        ));
      }
    }
  }

  ActiveCurrentQuestState get initialState => ActiveCurrentQuestEmpty();

  Future<void> _mapEmptyActiveCurrentQuestToState(EmptyActiveCurrentQuest event,
      Emitter<ActiveCurrentQuestState> emit) async {
    emit(ActiveCurrentQuestEmpty());
  }

  Future<void> _mapCreateActiveCurrentQuestToState(
      CreateActiveCurrentQuest event,
      Emitter<ActiveCurrentQuestState> emit) async {
    try {
      Quest quest = await questRepository.getCurrentQuest(
          questRepository.ethereumAddress.toString(), event.quest.category);

      print('create $quest');

      emit(ActiveCurrentQuestLoaded(quest: quest));
    } catch (e) {
      emit(ActiveCurrentQuestError(error: "get error"));
    }
  }

  void _mapIncrementActiveCurrentQuestToState(IncrementActiveCurrentQuest event,
      Emitter<ActiveCurrentQuestState> emit) async {
    try {
      if (state is ActiveCurrentQuestLoaded) {
        final Quest quest = (state as ActiveCurrentQuestLoaded).quest;

        emit(ActiveCurrentQuestUpdated(quest: quest));

        if (quest.goal <= event.count) {
          quest.needTimes -= 1;

          if (quest.needTimes == 0) {
            quest.achieveDate = DateTime.now();
            quest.achievement = quest.goal;
          } else {
            quest.achievement = 0;
          }

          add(AchieveActiveCurrentQuest(quest: quest));

          return;
        } else {
          quest.achievement = event.count;

          await questRepository.updateQuest(
              questRepository.ethereumAddress.toString(), quest);
        }
        emit(ActiveCurrentQuestLoaded(quest: quest));
      }
    } catch (e) {
      emit(ActiveCurrentQuestError(error: "increment error"));
    }
  }

  Future<void> _mapAchieveActiveCurrentQuestToState(
      AchieveActiveCurrentQuest event,
      Emitter<ActiveCurrentQuestState> emit) async {
    try {
      if (state is ActiveCurrentQuestUpdated) {
        final Quest quest = (state as ActiveCurrentQuestUpdated).quest;

        emit(ActiveCurrentQuestAchieved(quest: quest));

        await questRepository.updateQuest(
            questRepository.ethereumAddress.toString(), event.quest);

        emit(ActiveCurrentQuestEmpty());
      }
    } catch (e) {
      emit(ActiveCurrentQuestError(error: "achieve error"));
    }
  }

  void _mapErrorActiveCurrentQuestToState(
      ErrorActiveCurrentQuest event, Emitter<ActiveCurrentQuestState> emit) {
    emit(ActiveCurrentQuestError(error: "error"));
  }
}
