import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:health_kit_reporter/model/type/quantity_type.dart';

import 'package:lycle/src/bloc/steps/steps_bloc.dart';
import 'package:lycle/src/bloc/steps/steps_events.dart';
import 'package:lycle/src/utils/health_kit_helper.dart';
import 'package:lycle/src/utils/wallet_helper.dart';
import 'package:web3dart/web3dart.dart';

import '../../../data/model/steps.dart';
import '../../../bloc/steps/steps_state.dart';
import '../../../repository/web3/web3_api_client.dart';

class QuestListBody extends StatefulWidget {
  @override
  State<QuestListBody> createState() => QuestListBodyState();
}

class QuestListBodyState extends State<QuestListBody> {
  WalletHelper walletHelper = WalletHelper();
  Web3ApiClient web3apiClient = Web3ApiClient();

  final readTypes = [QuantityType.stepCount];
  final writeTypes = [QuantityType.stepCount];

  num steps = 0;

  late QuestStepsBloc _todayStepsBloc;
  late QuantityHealthHelper healthHelper;

  @override
  void initState() {
    super.initState();
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
    return SafeArea(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () async {
                await walletHelper.loginUsingMetamask();
                await web3apiClient.init();
                await web3apiClient.burn(
                    EthereumAddress.fromHex(walletHelper.session!.accounts[0]),
                    EtherAmount.fromUnitAndValue(EtherUnit.ether, 1).getInWei);
                await web3apiClient.mint(
                    EthereumAddress.fromHex(walletHelper.session!.accounts[0]),
                    EtherAmount.fromUnitAndValue(EtherUnit.ether, 2).getInWei);
                await _todayStepsBloc.healthHelper.requestPermission();
                int goal = 1000;
                final QuestSteps questSteps = QuestSteps.byTodaySteps(goal);
                _todayStepsBloc.add(CreateQuestSteps(questSteps: questSteps));
              },
              child: Text("걸음 수 가져오기")),
          BlocBuilder<QuestStepsBloc, QuestStepsState>(
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

                _showDialog("비매너 행위 경고",
                    "1회 더 데이터 임의 수정을 할 시, 현재 퀘스트 도전이 실패합니다.", actions);
              }
            }

            return true;
          }, builder: (context, state) {
            if (state is QuestStepsLoaded ||
                state is QuestStepsUpdated ||
                state is QuestStepsDenied) {
              final QuestSteps questSteps = state.props[0] as QuestSteps;
              double progressValue = questSteps.currentSteps / questSteps.goal;
              return Column(
                children: [
                  Text(
                      "Steps: ${(_todayStepsBloc.state.props[0] as Steps).currentSteps}"),
                  LinearProgressIndicator(
                    value: progressValue,
                  )
                ],
              );
            } else if (state is QuestStepsEmpty) {
              return const Text("Steps: 0");
            } else if (state is QuestStepsError) {
              return Text("${state.error}");
            }
            return const CircularProgressIndicator();
          }),
        ],
      )),
    );
  }
}
