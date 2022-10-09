import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web3dart/web3dart.dart';

import '../../../bloc/current_quest/manager/manager_current_quest_bloc.dart';
import '../../../bloc/current_quest/manager/manager_current_quest_event.dart';
import '../../../bloc/wallet/wallet_bloc.dart';
import '../../../bloc/write_contract/write_contract_bloc.dart';
import '../../../bloc/write_contract/write_contract_event.dart';
import '../../../data/enum/contract_function.dart';
import '../../../data/enum/quest_data_type.dart';
import '../../../data/model/quest.dart';
import '../../widgets/snack_bar/transaction_snack_bar.dart';

class ReceiveRewardButton extends StatefulWidget {
  @override
  State<ReceiveRewardButton> createState() => ReceiveRewardButtonState();
}

class ReceiveRewardButtonState extends State<ReceiveRewardButton> {
  late WalletBloc _walletBloc;
  late WriteContractBloc _writeContractBloc;
  late ManagerCurrentQuestBloc _managerCurrentQuestBloc;

  @override
  void initState() {
    super.initState();

    _walletBloc = BlocProvider.of<WalletBloc>(context);
    _writeContractBloc = BlocProvider.of<WriteContractBloc>(context);
    _managerCurrentQuestBloc =
        BlocProvider.of<ManagerCurrentQuestBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () async {
          if (_managerCurrentQuestBloc.questRepository.ethereumAddress == null) {
            _managerCurrentQuestBloc.add(EmptyCurrentQuest());
            return;
          }
          List<Quest> finishQuests =
              await _managerCurrentQuestBloc.questRepository.getAllFinishQuest(
                  _managerCurrentQuestBloc.questRepository.ethereumAddress.toString());

          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              if (finishQuests.isNotEmpty) {
                int reward = 0;
                for (Quest quest in finishQuests) {
                  reward += quest.rewardToken;
                }

                return TransactionSnackBar(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Center(child: Text("보상 토큰 : $reward"))),
                        OutlinedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                          title: Text("토큰을 받으시겠습니까?"),
                                          content: Text(
                                              "이 퀘스트를 완료할 시, 토큰을 ${reward}개 획득합니다."),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("취소")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _writeContractBloc.add(
                                                    SendTransaction(
                                                        contractFunctionEnum:
                                                            ContractFunctionEnum
                                                                .getByFunctionName(
                                                                    'mint'),
                                                        to: _walletBloc
                                                            .web3Repository
                                                            .wallet
                                                            .address,
                                                        amount: EtherAmount
                                                                .fromUnitAndValue(
                                                                    EtherUnit
                                                                        .ether,
                                                                    reward)
                                                            .getInWei,
                                                        successCallbackParameter: [
                                                          finishQuests,
                                                          _walletBloc
                                                        ],
                                                        successCallback:
                                                            _managerCurrentQuestBloc
                                                                .callbackWhenReceiveQuestRewardSucceed),
                                                  );
                                                },
                                                child: Text(
                                                  "확인",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                          ]));
                            },
                            child: Text("획득하기")),
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: finishQuests.length,
                        itemBuilder: (_, index) {
                          Quest quest = finishQuests[index];

                          return Row(
                            children: [
                              Text(
                                  "${quest.achieveDate} ${QuestDataType.getByCategory(quest.category).korean} 레벨 ${quest.level + 1} 토큰 보상 : ${quest.rewardToken}")
                            ],
                          );
                        })
                  ],
                ));
              } else {
                return Center(
                  child: Text("완료한 퀘스트가 없습니다."),
                );
              }
            },
          );
        },
        child: Text("퀘스트 보상 받기"));
  }
}
