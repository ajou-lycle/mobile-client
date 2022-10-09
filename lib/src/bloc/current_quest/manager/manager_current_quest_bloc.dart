import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/enum/contract_function.dart';
import '../../../data/enum/quest_data_type.dart';
import '../../../data/model/quest.dart';
import '../../../data/repository/health/ios_health_repository.dart';
import '../../../data/repository/quest_repository.dart';
import '../../wallet/wallet_bloc.dart';
import '../../wallet/wallet_event.dart';

import '../active/active_current_quest_bloc.dart';
import '../active/active_current_quest_event.dart';
import 'manager_current_quest_event.dart';
import 'manager_current_quest_state.dart';

class ManagerCurrentQuestBloc
    extends Bloc<ManagerCurrentQuestEvent, ManagerCurrentQuestState> {
  final IOSHealthRepository iosHealthRepository = IOSHealthRepository();
  final QuestRepository questRepository;

  List<ActiveCurrentQuestBloc> activeCurrentQuestBlocList =
      List<ActiveCurrentQuestBloc>.empty(growable: true);

  ManagerCurrentQuestBloc({required this.questRepository})
      : super(ManagerCurrentQuestEmpty()) {
    on<EmptyCurrentQuest>(_mapEmptyCurrentQuestToState);
    on<GetCurrentQuest>(_mapGetCurrentQuestToState);
    on<CreateCurrentQuest>(_mapCreateCurrentQuestToState);
    on<AchieveCurrentQuest>(_mapAchieveCurrentQuestToState);
    on<DeleteCurrentQuest>(_mapDeleteCurrentQuestToState);
    on<ErrorCurrentQuest>(_mapErrorCurrentQuestToState);
  }

  Future<void> registerQuestToiOSHealthHelper(Quest quest,
      {bool isCreated = false}) async {
    addPermissionAndCallbackIfNotExists(quest, isCreated: isCreated);
    await iosHealthRepository.requestPermission();
    if (state is ManagerCurrentQuestLoaded ||
        state is ManagerCurrentQuestUpdated) {
      print('register');
      print(iosHealthRepository.questDataTypeList);
      print(state.props[0] as List<Quest>);
      iosHealthRepository
          .observerQueryForQuantityQuery(state.props[0] as List<Quest>);
    }
  }

  void addPermissionAndCallbackIfNotExists(Quest quest,
      {bool isCreated = false}) {
    QuestDataType questDataType = QuestDataType.getByCategory(quest.category);
    if (!iosHealthRepository.questDataTypeList.contains(questDataType)) {
      ActiveCurrentQuestBloc activeCurrentQuestBloc =
          activeCurrentQuestBlocList.singleWhere((activeCurrentQuestBloc) =>
              activeCurrentQuestBloc.questDataType == questDataType);

      iosHealthRepository.questDataTypeList.add(questDataType);

      iosHealthRepository.acceptCallbackList
          .add(activeCurrentQuestBloc.handleCount);

      if (isCreated) {
        activeCurrentQuestBloc.add(CreateActiveCurrentQuest(quest: quest));
      }
    }
  }

  Future<bool> callbackWhenRequestQuestSucceed(
      ContractFunctionEnum contractFunctionEnum, List parameters) async {
    Quest quest = parameters[0];
    WalletBloc walletBloc = parameters[1];

    switch (contractFunctionEnum) {
      case ContractFunctionEnum.burn:
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
        if (questRepository.ethereumAddress == null) {
          return false;
        }

        walletBloc.add(UpdateWallet());
        add(DeleteCurrentQuest(questList: questList));
        return true;
      default:
        return false;
    }
  }

  ManagerCurrentQuestState get initialState => ManagerCurrentQuestEmpty();

  Future<void> _mapEmptyCurrentQuestToState(
      EmptyCurrentQuest event, Emitter<ManagerCurrentQuestState> emit) async {
    emit(ManagerCurrentQuestEmpty());
  }

  Future<void> _mapGetCurrentQuestToState(
      GetCurrentQuest event, Emitter<ManagerCurrentQuestState> emit) async {
    try {
      emit(ManagerCurrentQuestLoading());

      if (questRepository.ethereumAddress == null) {
        emit(ManagerCurrentQuestEmpty());
        return;
      }

      final questList = await questRepository
          .getAllCurrentQuest(questRepository.ethereumAddress.toString());

      for (Quest quest in questList) {
        await registerQuestToiOSHealthHelper(quest);
      }

      iosHealthRepository.observerQueryForQuantityQuery(questList);

      emit(ManagerCurrentQuestLoaded(questList: questList));
    } catch (e) {
      emit(ManagerCurrentQuestError(error: "get error"));
    }
  }

  Future<void> _mapCreateCurrentQuestToState(
      CreateCurrentQuest event, Emitter<ManagerCurrentQuestState> emit) async {
    try {
      if (questRepository.ethereumAddress == null) {
        emit(ManagerCurrentQuestEmpty());
        return;
      }

      List<Quest> questList = List<Quest>.empty(growable: true);

      if (state is ManagerCurrentQuestLoaded) {
        questList = state.props[0] as List<Quest>;
      }

      emit(ManagerCurrentQuestUpdated(questList: questList));

      event.quest.finishDate = DateTime.now()
          .add(event.quest.finishDate.difference(event.quest.startDate));
      event.quest.startDate = DateTime.now();

      await questRepository.insertQuest(
          questRepository.ethereumAddress.toString(), event.quest);
      questList = await questRepository
          .getAllCurrentQuest(questRepository.ethereumAddress.toString());

      emit(ManagerCurrentQuestLoaded(questList: questList));
      await registerQuestToiOSHealthHelper(event.quest, isCreated: true);
    } catch (e) {
      emit(ManagerCurrentQuestError(error: "get error"));
    }
  }

  Future<void> _mapAchieveCurrentQuestToState(
      AchieveCurrentQuest event, Emitter<ManagerCurrentQuestState> emit) async {
    try {
      List<Quest> questList = List<Quest>.empty(growable: true);

      print("achieve");

      if (state is ManagerCurrentQuestLoaded) {
        questList = state.props[0] as List<Quest>;
      }

      emit(ManagerCurrentQuestUpdated(questList: questList));

      var toRemove = [];

      for (Quest quest in questList) {
        if (quest.category == event.quest.category) {
          toRemove.add(quest);
        }
      }

      questList.removeWhere((quest) => toRemove.contains(quest));
      iosHealthRepository.deleteAccessAuthority(
          questDataType: QuestDataType.getByCategory(event.quest.category));
      iosHealthRepository.observerQueryForQuantityQuery(questList);

      emit(ManagerCurrentQuestLoaded(questList: questList));
    } catch (e) {
      print(e);
      emit(ManagerCurrentQuestError(error: "achieve error"));
    }
  }

  Future<void> _mapDeleteCurrentQuestToState(
      DeleteCurrentQuest event, Emitter<ManagerCurrentQuestState> emit) async {
    try {
      List<Quest> questList = List<Quest>.empty(growable: true);

      if (state is ManagerCurrentQuestLoaded) {
        questList = state.props[0] as List<Quest>;
      }

      emit(ManagerCurrentQuestUpdated(questList: questList));

      for (Quest quest in event.questList) {
        await questRepository.deleteQuest(
            questRepository.ethereumAddress.toString(), quest);

        int index = iosHealthRepository.questDataTypeList
            .indexOf(QuestDataType.getByCategory(quest.category));

        if (index > -1) {
          iosHealthRepository.questDataTypeList.removeAt(index);
          iosHealthRepository.acceptCallbackList.removeAt(index);
        }
      }

      questList = await questRepository
          .getAllCurrentQuest(questRepository.ethereumAddress.toString());
      iosHealthRepository.observerQueryForQuantityQuery(questList);

      emit(ManagerCurrentQuestLoaded(questList: questList));
    } catch (e) {
      emit(ManagerCurrentQuestError(error: "Denied error"));
    }
  }

  void _mapErrorCurrentQuestToState(
      ErrorCurrentQuest event, Emitter<ManagerCurrentQuestState> emit) {
    emit(ManagerCurrentQuestError(error: "error"));
  }
}
