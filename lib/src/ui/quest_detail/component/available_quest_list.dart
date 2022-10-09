import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web3dart/web3dart.dart';

import '../../../bloc/current_quest/active/active_current_quest_bloc.dart';
import '../../../bloc/current_quest/active/active_current_quest_event.dart';

import '../../../bloc/current_quest/manager/manager_current_quest_bloc.dart';
import '../../../bloc/current_quest/manager/manager_current_quest_event.dart';
import '../../../bloc/quest/quest_bloc.dart';
import '../../../bloc/wallet/wallet_bloc.dart';
import '../../../bloc/write_contract/write_contract_bloc.dart';
import '../../../bloc/write_contract/write_contract_event.dart';
import '../../../data/enum/contract_function.dart';
import '../../../data/enum/quest_data_type.dart';
import '../../../data/model/quest.dart';

class AvailableQuestList extends StatefulWidget {
  int index;

  AvailableQuestList({required this.index});

  @override
  State<AvailableQuestList> createState() => AvailableQuestListState();
}

class AvailableQuestListState extends State<AvailableQuestList> {
  late QuestBloc _questBloc;
  late ManagerCurrentQuestBloc _managerCurrentQuestBloc;
  late WalletBloc _walletBloc;
  late WriteContractBloc _writeContractBloc;

  Future<void> requestQuest(Quest quest) async {
    if (quest.needToken > 0) {
      _writeContractBloc.add(SendTransaction(
          contractFunctionEnum: ContractFunctionEnum.getByFunctionName('burn'),
          to: _walletBloc.web3Repository.wallet.address,
          amount: EtherAmount.fromUnitAndValue(EtherUnit.ether, quest.needToken)
              .getInWei,
          successCallback:
              _managerCurrentQuestBloc.callbackWhenRequestQuestSucceed,
          successCallbackParameter: [quest, _walletBloc]));
    } else {
      _managerCurrentQuestBloc.add(CreateCurrentQuest(quest: quest));
    }
  }

  String goalText(String category) {
    final type = QuestDataType.getByCategory(category);

    switch (type) {
      case (QuestDataType.walking):
        return "걸음";
      case (QuestDataType.running):
        return "km";
      default:
        return "오류";
    }
  }

  String timeLimitText(Duration timeLimit) {
    if (timeLimit.inDays > 0) {
      return "${timeLimit.inDays}일";
    } else {
      return "${timeLimit.inMinutes}분";
    }
  }

  @override
  void initState() {
    super.initState();

    _questBloc = BlocProvider.of<QuestBloc>(context);
    _managerCurrentQuestBloc =
        BlocProvider.of<ManagerCurrentQuestBloc>(context);
    _walletBloc = BlocProvider.of<WalletBloc>(context);
    _writeContractBloc = BlocProvider.of<WriteContractBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount:
            _questBloc.questRepository.availableQuests[widget.index].length,
        itemBuilder: (context, index) {
          Quest quest =
              _questBloc.questRepository.availableQuests[widget.index][index];

          return Row(
            children: [
              Column(
                children: [
                  Text(
                      "${quest.category} ${quest.level + 1} 단계 : ${quest.goal} ${goalText(quest.category)} ${quest.needTimes}회"),
                  Row(
                    children: [
                      Text(
                          "시간제한 : ${timeLimitText(quest.finishDate.difference(quest.startDate))} "),
                      Text("${quest.needToken}개 필요"),
                      Text("보상 ${quest.rewardToken}개"),
                    ],
                  )
                ],
              ),
              TextButton(
                  onPressed: () async {
                    if (_managerCurrentQuestBloc
                        .iosHealthRepository.questDataTypeList
                        .contains(
                            QuestDataType.getByCategory(quest.category))) {
                      showDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                title: const Text("진행 중인 퀘스트가 있습니다."),
                                content: const Text(
                                    "이 퀘스트를 등록할 시,\n현재 진행 중인 퀘스트는 중도 취소됩니다."),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("취소")),
                                  TextButton(
                                      onPressed: () async {
                                        _managerCurrentQuestBloc
                                            .iosHealthRepository
                                            .deleteAccessAuthority(
                                                questDataType:
                                                    QuestDataType.getByCategory(
                                                        quest.category));
                                        _managerCurrentQuestBloc.add(
                                            DeleteCurrentQuest(
                                                questList: [quest]));
                                        Navigator.pop(context);
                                        requestQuest(quest);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "확인",
                                        style: TextStyle(color: Colors.red),
                                      )),
                                ],
                              ));
                      return;
                    }

                    showDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                              title: const Text("토큰이 소비됩니다."),
                              content: Text(
                                  "이 퀘스트를 등록할 시, 토큰이 ${quest.needToken}개 소비됩니다."),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("취소")),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await requestQuest(quest);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "확인",
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            ));
                  },
                  child: const Text("퀘스트 등록하기")),
            ],
          );
        });
  }
}
