import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/data/enum/quest_data_type.dart';
import 'package:web3dart/web3dart.dart';

import '../../../bloc/current_quest/current_quest_bloc.dart';
import '../../../bloc/quest/quest_bloc.dart';
import '../../../bloc/wallet/wallet_bloc.dart';
import '../../../bloc/write_contract/write_contract_bloc.dart';
import '../../../bloc/write_contract/write_contract_event.dart';
import '../../../data/enum/contract_function.dart';
import '../../../data/model/quest.dart';

class AvailableQuestList extends StatefulWidget {
  int index;

  AvailableQuestList({required this.index});

  @override
  State<AvailableQuestList> createState() => AvailableQuestListState();
}

class AvailableQuestListState extends State<AvailableQuestList> {
  late QuestBloc _questBloc;
  late CurrentQuestBloc _currentQuestBloc;
  late WalletBloc _walletBloc;
  late WriteContractBloc _writeContractBloc;

  @override
  void initState() {
    super.initState();

    _questBloc = BlocProvider.of<QuestBloc>(context);
    _currentQuestBloc = BlocProvider.of<CurrentQuestBloc>(context);
    _walletBloc = BlocProvider.of<WalletBloc>(context);
    _writeContractBloc = BlocProvider.of<WriteContractBloc>(context);
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
                      "${quest.category} ${quest.level + 1} 단계 : ${quest.goal} ${goalText(quest.category)} ${quest.times}회"),
                  Row(
                    children: [
                      Text(
                          "시간제한 : ${timeLimitText(quest.finishDate.difference(quest.startDate))}"),
                      Text("${quest.needToken}개 필요"),
                      Text("보상 ${quest.rewardToken}개"),
                    ],
                  )
                ],
              ),
              TextButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                              title: Text("토큰이 소비됩니다."),
                              content: Text(
                                  "이 퀘스트를 등록할 시, 토큰이 ${quest.needToken}개 소비됩니다."),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("취소")),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      _writeContractBloc.add(SendTransaction(
                                          contractFunctionEnum:
                                              ContractFunctionEnum
                                                  .getByFunctionName('burn'),
                                          to: _walletBloc
                                              .web3Repository.wallet.address,
                                          amount: EtherAmount.fromUnitAndValue(
                                                  EtherUnit.ether, 1)
                                              .getInWei,
                                          currentQuestBloc: _currentQuestBloc,
                                          category: quest.category,
                                          level: 0));
                                    },
                                    child: Text(
                                      "확인",
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            ));
                  },
                  child: Text("퀘스트 등록하기")),
            ],
          );
        });
  }
}
