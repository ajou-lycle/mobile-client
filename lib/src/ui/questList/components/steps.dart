import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:lycle/src/bloc/write_contract/write_contract_event.dart';
import 'package:lycle/src/constants/ui.dart';
import 'package:lycle/src/data/enum/contract_function.dart';
import 'package:lycle/src/repository/web3/web3_api_client.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

import '../../../bloc/steps/steps_bloc.dart';
import '../../../bloc/steps/steps_event.dart';
import '../../../bloc/steps/steps_state.dart';
import '../../../bloc/wallet/wallet_bloc.dart';
import '../../../bloc/wallet/wallet_event.dart';
import '../../../bloc/write_contract/write_contract_bloc.dart';
import '../../../bloc/write_contract/write_contract_state.dart';
import '../../../data/model/steps.dart';

class QuestListSteps extends StatefulWidget {
  final EthereumAddress address;

  QuestListSteps({required this.address});

  @override
  State<QuestListSteps> createState() => QuestListStepsState();
}

class QuestListStepsState extends State<QuestListSteps> {
  Web3ApiClient web3apiClient = Web3ApiClient();

  final readTypes = [QuantityType.stepCount];
  final writeTypes = [QuantityType.stepCount];

  num steps = 0;

  late WriteContractBloc _writeContractBloc;
  late WalletBloc _walletBloc;
  late QuestStepsBloc _todayStepsBloc;

  @override
  void initState() {
    super.initState();
    _writeContractBloc = BlocProvider.of<WriteContractBloc>(context);
    _walletBloc = BlocProvider.of<WalletBloc>(context);
    _todayStepsBloc = BlocProvider.of<QuestStepsBloc>(context);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  void _showDialog(String title, String content, List<Widget> actions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: Text(title), content: Text(content), actions: actions);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WriteContractBloc, WriteContractState>(
        bloc: _writeContractBloc,
        listener: (context, state) {
          if (state is TransactionSend) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
              children: [CircularProgressIndicator(), Text("요청을 처리 중입니다.")],
            )));
          } else if (state is TransactionSucceed) {
            _walletBloc.add(UpdateWallet());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                ),
                Text("요청이 성공했습니다.")
              ],
            )));
          } else if (state is TransactionFailed ||
              state is WriteContractError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
              children: [
                Icon(
                  Icons.close_rounded,
                  color: Colors.red,
                ),
                Text("요청이 실패했습니다.")
              ],
            )));
          }
        },
        child: BlocBuilder<QuestStepsBloc, QuestStepsState>(
            buildWhen: (previous, current) {
          if (previous is QuestStepsLoaded && current is QuestStepsDenied) {
            if (current.isDenied) {
              List<Widget> actions = <Widget>[
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("확인"))
              ];

              _showDialog(
                  "퀘스트 실패", "반복되는 데이터 임의 수정으로, 현재 퀘스트에 실패하였습니다.", actions);
            } else {
              List<Widget> actions = <Widget>[
                OutlinedButton(
                    onPressed: () {
                      _todayStepsBloc.add(IncrementQuestSteps(
                          count: previous.questSteps.currentSteps));
                      Navigator.pop(context);
                    },
                    child: const Text("확인"))
              ];

              _showDialog("비매너 행위 경고", "1회 더 데이터 임의 수정을 할 시, 현재 퀘스트 도전이 실패합니다.",
                  actions);
            }
          }

          return true;
        }, builder: (context, state) {
          print(state);
          if (state is QuestStepsLoaded ||
              state is QuestStepsUpdated ||
              state is QuestStepsDenied) {
            final QuestSteps questSteps = state.props[0] as QuestSteps;
            double progressValue = questSteps.currentSteps / questSteps.goal;
            return Column(
              children: [
                TextButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                  title: Text("토큰을 받으시겠습니까?"),
                                  content: Text("이 퀘스트를 완료할 시, 토큰을 2개 획득합니다."),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
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
                                                  to: widget.address,
                                                  amount: EtherAmount
                                                          .fromUnitAndValue(
                                                              EtherUnit.ether,
                                                              2)
                                                      .getInWei));
                                        },
                                        child: Text(
                                          "확인",
                                          style: TextStyle(color: Colors.red),
                                        )),
                                  ]));
                    },
                    child: Text("걷기 퀘스트 보상 받기")),
                Text(
                    "Steps: ${(_todayStepsBloc.state.props[0] as QuestSteps).currentSteps}"),
                Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: LinearProgressIndicator(
                      value: progressValue,
                    ))
              ],
            );
          } else if (state is QuestStepsEmpty) {
            return Column(children: [
              TextButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                              title: Text("토큰이 소비됩니다."),
                              content: Text("이 퀘스트를 등록할 시, 토큰이 1개 소비됩니다."),
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
                                          questStepsBloc: _todayStepsBloc,
                                          to: widget.address,
                                          amount: EtherAmount.fromUnitAndValue(
                                                  EtherUnit.ether, 1)
                                              .getInWei));
                                    },
                                    child: Text(
                                      "확인",
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            ));
                  },
                  child: Text("걷기 퀘스트 등록하기")),
              Text("Steps: 0")
            ]);
          } else if (state is QuestStepsError) {
            return Text("${state.error}");
          }
          return const CircularProgressIndicator();
        }));
  }
}
