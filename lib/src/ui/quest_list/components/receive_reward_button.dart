import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/constants/ui.dart';

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
    return ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(kDefaultRadius)),
            )),
            backgroundColor: MaterialStateProperty.all(kPrimaryColor),
            foregroundColor: MaterialStateProperty.all(Colors.white)),
        onPressed: () async {
          if (_managerCurrentQuestBloc.questRepository.ethereumAddress ==
              null) {
            _managerCurrentQuestBloc.add(EmptyCurrentQuest());
            return;
          }
          List<Quest> finishQuests =
              await _managerCurrentQuestBloc.questRepository.getAllFinishQuest(
                  _managerCurrentQuestBloc.questRepository.ethereumAddress
                      .toString());

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
                        Expanded(child: Center(child: Text("?????? ?????? : $reward"))),
                        OutlinedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                          title: const Text("????????? ??????????????????????"),
                                          content: Text(
                                              "??? ???????????? ????????? ???, ????????? ${reward}??? ???????????????."),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("??????")),
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
                                                child: const Text(
                                                  "??????",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                          ]));
                            },
                            child: const Text("????????????")),
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
                                  "${quest.achieveDate} ${QuestDataType.getByCategory(quest.category).korean} ?????? ${quest.level + 1} ?????? ?????? : ${quest.rewardToken}")
                            ],
                          );
                        })
                  ],
                ));
              } else {
                return Center(
                  child: Text("????????? ???????????? ????????????."),
                );
              }
            },
          );
        },
        child: Text("????????? ?????? ??????"));
  }
}
