import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

import 'package:lycle/src/bloc/current_quest/current_quest_event.dart';
import 'package:lycle/src/bloc/current_quest/current_quest_state.dart';
import 'package:lycle/src/bloc/wallet/wallet_bloc.dart';
import 'package:lycle/src/bloc/wallet/wallet_event.dart';

import 'package:lycle/src/repository/quest/quest_repository.dart';

import '../../data/enum/contract_function.dart';

import '../../data/model/quest.dart';
import '../../utils/health_kit_helper.dart';

class CurrentQuestBloc extends Bloc<CurrentQuestEvent, CurrentQuestState> {
  late QuantityHealthHelper healthHelper;
  final QuestRepository questRepository;

  CurrentQuestBloc({required this.healthHelper, required this.questRepository})
      : super(CurrentQuestEmpty()) {
    on<GetCurrentQuest>(_mapGetCurrentQuestToState);
    on<CreateCurrentQuest>(_mapCreateCurrentQuestToState);
    on<ReplaceCurrentQuest>(_mapReplaceCurrentQuestToState);
    on<IncrementCurrentQuest>(_mapIncrementCurrentQuestToState);
    on<AchieveCurrentQuest>(_mapAchieveCurrentQuestToState);
    on<DeniedCurrentQuest>(_mapDeniedCurrentQuestToState);
    on<ErrorCurrentQuest>(_mapErrorCurrentQuestToState);
  }

  void handleCount(int index, num acceptCount) {
    if (state is! CurrentQuestDenied) {
      print(acceptCount);
      add(IncrementCurrentQuest(index: index, count: acceptCount as int));
    }
  }

  void deniedCount(QuantityType type, num deniedCount) =>
      add(DeniedCurrentQuest(count: deniedCount as int));

  Future<bool> callbackWhenRequestQuestSucceed(
      ContractFunctionEnum contractFunctionEnum, List parameters) async {
    Quest quest = parameters[0];
    WalletBloc walletBloc = parameters[1];

    switch (contractFunctionEnum) {
      case ContractFunctionEnum.burn:
        if (!healthHelper.hasPermissions) {
          await healthHelper.requestPermission();
        }

        quest.finishDate =
            DateTime.now().add(quest.finishDate.difference(quest.startDate));
        quest.startDate = DateTime.now();

        walletBloc.add(UpdateWallet());
        add(CreateCurrentQuest(quest: quest));

        return true;
      default:
        return false;
    }
  }

  Future<bool> callbackWhenReceiveQuestRewardSucceed(
      ContractFunctionEnum contractFunctionEnum, List parameters) async {
    List<Quest> questList = parameters[0];
    WalletBloc walletBloc = parameters[1];

    switch (contractFunctionEnum) {
      case ContractFunctionEnum.mint:
        for (Quest quest in questList) {
          await questRepository.deleteQuest(quest);
        }

        walletBloc.add(UpdateWallet());
        add(GetCurrentQuest());
        return true;
      default:
        return false;
    }
  }

  CurrentQuestState get initialState => CurrentQuestEmpty();

  Future<void> _mapGetCurrentQuestToState(
      GetCurrentQuest event, Emitter<CurrentQuestState> emit) async {
    try {
      emit(CurrentQuestLoading());

      final questList = await questRepository.getAllCurrentQuest();

      healthHelper.observerQueryForQuantityQuery(
          questList, handleCount, deniedCount);

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

      emit(CurrentQuestUpdated(questList: questList));

      await questRepository.insertQuest(event.quest);
      questList = await questRepository.getAllCurrentQuest();

      healthHelper.observerQueryForQuantityQuery(
          questList, handleCount, deniedCount);

      emit(CurrentQuestLoaded(questList: questList));
    } catch (e) {
      emit(CurrentQuestError(error: "get error"));
    }
  }

  Future<void> _mapReplaceCurrentQuestToState(
      ReplaceCurrentQuest event, Emitter<CurrentQuestState> emit) async {
    try {
      if (state is CurrentQuestLoaded || state is CurrentQuestUpdated) {
        List<Quest> questList = state.props[0] as List<Quest>;

        emit(CurrentQuestLoading());

        await questRepository.updateQuest(event.quest);
        questList = await questRepository.getAllCurrentQuest();

        emit(CurrentQuestLoaded(questList: questList));
      }
    } catch (e) {
      emit(CurrentQuestError(error: "replace error"));
    }
  }

  void _mapIncrementCurrentQuestToState(
      IncrementCurrentQuest event, Emitter<CurrentQuestState> emit) async {
    try {
      if (state is CurrentQuestLoaded) {
        final questList = state.props[0] as List<Quest>;
        final Quest quest = questList[event.index];

        emit(CurrentQuestUpdated(questList: questList));
        if (quest.goal <= event.count) {
          quest.needTimes -= 1;

          if (quest.needTimes == 0) {
            quest.achieveDate = DateTime.now();
            quest.achievement = quest.goal;
          } else {
            quest.achievement = 0;
          }

          add(AchieveCurrentQuest(quest: quest));

          return;
        } else {
          quest.achievement = event.count;
        }
        emit(CurrentQuestLoaded(questList: questList));
      }
    } catch (e) {
      emit(CurrentQuestError(error: "increment error"));
    }
  }

  Future<void> _mapAchieveCurrentQuestToState(
      AchieveCurrentQuest event, Emitter<CurrentQuestState> emit) async {
    try {
      if (state is CurrentQuestUpdated) {
        List<Quest> questList = state.props[0] as List<Quest>;

        emit(CurrentQuestAchieved(questList: questList));

        await questRepository.updateQuest(event.quest);
        questList = await questRepository.getAllCurrentQuest();

        if (event.quest.needTimes == 0) {
          questList.remove(event.quest);
        }

        if (questList.isEmpty) {
          emit(CurrentQuestEmpty());
        } else {
          emit(CurrentQuestLoaded(questList: questList));
        }
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
