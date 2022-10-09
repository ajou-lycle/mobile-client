import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:web3dart/credentials.dart';

import '../../../data/enum/contract_function.dart';
import '../../../data/model/quest.dart';
import '../../../data/repository/quest_repository.dart';

import '../../../utils/health_kit_helper.dart';

import '../../wallet/wallet_bloc.dart';
import '../../wallet/wallet_event.dart';

import 'manager_current_quest_event.dart';
import 'manager_current_quest_state.dart';

class ManagerCurrentQuestBloc
    extends Bloc<ManagerCurrentQuestEvent, ManagerCurrentQuestState> {
  late QuantityHealthHelper healthHelper;
  final QuestRepository questRepository;
  EthereumAddress? ethereumAddress;

  ManagerCurrentQuestBloc(
      {required this.healthHelper, required this.questRepository})
      : super(ActiveCurrentQuestEmpty()) {
    on<EmptyActiveCurrentQuest>(_mapEmptyActiveCurrentQuestToState);
    on<GetActiveCurrentQuest>(_mapGetActiveCurrentQuestToState);
    on<CreateActiveCurrentQuest>(_mapCreateActiveCurrentQuestToState);
    on<ReplaceActiveCurrentQuest>(_mapReplaceActiveCurrentQuestToState);
    on<IncrementActiveCurrentQuest>(_mapIncrementActiveCurrentQuestToState);
    on<AchieveActiveCurrentQuest>(_mapAchieveActiveCurrentQuestToState);
    on<DeniedActiveCurrentQuest>(_mapDeniedActiveCurrentQuestToState);
    on<ErrorActiveCurrentQuest>(_mapErrorActiveCurrentQuestToState);
  }

  void handleCount(int index, num acceptCount) {
    if (state is! ActiveCurrentQuestDenied) {
      print(acceptCount);
      add(IncrementActiveCurrentQuest(index: index, count: acceptCount as int));
    }
  }

  void deniedCount(QuantityType type, num deniedCount) =>
      add(DeniedActiveCurrentQuest(count: deniedCount as int));

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
        add(CreateActiveCurrentQuest(quest: quest));

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
        if (ethereumAddress == null) {
          return false;
        }
        for (Quest quest in questList) {
          await questRepository.deleteQuest(ethereumAddress.toString(), quest);
        }

        walletBloc.add(UpdateWallet());
        add(GetActiveCurrentQuest());
        return true;
      default:
        return false;
    }
  }

  ManagerCurrentQuestState get initialState => ActiveCurrentQuestEmpty();

  Future<void> _mapEmptyActiveCurrentQuestToState(EmptyActiveCurrentQuest event,
      Emitter<ManagerCurrentQuestState> emit) async {
    emit(ActiveCurrentQuestEmpty());
  }

  Future<void> _mapGetActiveCurrentQuestToState(GetActiveCurrentQuest event,
      Emitter<ManagerCurrentQuestState> emit) async {
    try {
      emit(ActiveCurrentQuestLoading());

      if (ethereumAddress == null) {
        emit(ActiveCurrentQuestEmpty());
        return;
      }

      final questList =
          await questRepository.getAllCurrentQuest(ethereumAddress.toString());

      healthHelper.observerQueryForQuantityQuery(
          questList, handleCount, deniedCount);

      emit(ActiveCurrentQuestLoaded(questList: questList));
    } catch (e) {
      emit(ActiveCurrentQuestError(error: "get error"));
    }
  }

  Future<void> _mapCreateActiveCurrentQuestToState(
      CreateActiveCurrentQuest event,
      Emitter<ManagerCurrentQuestState> emit) async {
    try {
      if (ethereumAddress == null) {
        emit(ActiveCurrentQuestEmpty());
        return;
      }

      List<Quest> questList = List<Quest>.empty(growable: true);

      if (state is ActiveCurrentQuestLoaded) {
        questList = state.props[0] as List<Quest>;
      }

      emit(ActiveCurrentQuestUpdated(questList: questList));

      await questRepository.insertQuest(
          ethereumAddress.toString(), event.quest);
      questList =
          await questRepository.getAllCurrentQuest(ethereumAddress.toString());

      healthHelper.observerQueryForQuantityQuery(
          questList, handleCount, deniedCount);

      emit(ActiveCurrentQuestLoaded(questList: questList));
    } catch (e) {
      emit(ActiveCurrentQuestError(error: "get error"));
    }
  }

  Future<void> _mapReplaceActiveCurrentQuestToState(
      ReplaceActiveCurrentQuest event,
      Emitter<ManagerCurrentQuestState> emit) async {
    try {
      if (ethereumAddress == null) {
        emit(ActiveCurrentQuestEmpty());
        return;
      }

      if (state is ActiveCurrentQuestLoaded ||
          state is ActiveCurrentQuestUpdated) {
        List<Quest> questList = state.props[0] as List<Quest>;

        emit(ActiveCurrentQuestLoading());

        await questRepository.updateQuest(
            ethereumAddress.toString(), event.quest);
        questList = await questRepository
            .getAllCurrentQuest(ethereumAddress.toString());

        emit(ActiveCurrentQuestLoaded(questList: questList));
      }
    } catch (e) {
      emit(ActiveCurrentQuestError(error: "replace error"));
    }
  }

  void _mapIncrementActiveCurrentQuestToState(IncrementActiveCurrentQuest event,
      Emitter<ManagerCurrentQuestState> emit) async {
    try {
      if (state is ActiveCurrentQuestLoaded) {
        final questList = state.props[0] as List<Quest>;
        final Quest quest = questList[event.index];

        emit(ActiveCurrentQuestUpdated(questList: questList));
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
        }
        emit(ActiveCurrentQuestLoaded(questList: questList));
      }
    } catch (e) {
      emit(ActiveCurrentQuestError(error: "increment error"));
    }
  }

  Future<void> _mapAchieveActiveCurrentQuestToState(
      AchieveActiveCurrentQuest event,
      Emitter<ManagerCurrentQuestState> emit) async {
    if (ethereumAddress == null) {
      emit(ActiveCurrentQuestEmpty());
      return;
    }

    try {
      if (state is ActiveCurrentQuestUpdated) {
        List<Quest> questList = state.props[0] as List<Quest>;

        emit(ActiveCurrentQuestAchieved(questList: questList));

        await questRepository.updateQuest(
            ethereumAddress.toString(), event.quest);
        questList = await questRepository.getAllCurrentQuest(
          ethereumAddress.toString(),
        );

        if (event.quest.needTimes == 0) {
          questList.remove(event.quest);
        }

        if (questList.isEmpty) {
          emit(ActiveCurrentQuestEmpty());
        } else {
          emit(ActiveCurrentQuestLoaded(questList: questList));
        }
      }
    } catch (e) {
      emit(ActiveCurrentQuestError(error: "replacement error"));
    }
  }

  void _mapDeniedActiveCurrentQuestToState(
      DeniedActiveCurrentQuest event, Emitter<ManagerCurrentQuestState> emit) {
    try {
      ActiveCurrentQuestDenied questDenied =
          ActiveCurrentQuestDenied(quest: state.props[0] as Quest);

      if (event.count == 2) {
        (questDenied.props[0] as Quest).achievement = 0;
        questDenied.props[1] = false;
      }

      emit(questDenied);
    } catch (e) {
      emit(ActiveCurrentQuestError(error: "Denied error"));
    }
  }

  void _mapErrorActiveCurrentQuestToState(
      ErrorActiveCurrentQuest event, Emitter<ManagerCurrentQuestState> emit) {
    emit(ActiveCurrentQuestError(error: "error"));
  }
}
