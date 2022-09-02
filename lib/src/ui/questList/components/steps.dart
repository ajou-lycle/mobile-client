import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:lycle/src/repository/web3/web3_api_client.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

import '../../../bloc/steps/steps_bloc.dart';
import '../../../bloc/steps/steps_event.dart';
import '../../../bloc/steps/steps_state.dart';
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

  late QuestStepsBloc _todayStepsBloc;

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
    return BlocBuilder<QuestStepsBloc, QuestStepsState>(
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

          _showDialog("퀘스트 실패", "반복되는 데이터 임의 수정으로, 현재 퀘스트에 실패하였습니다.", actions);
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

          _showDialog(
              "비매너 행위 경고", "1회 더 데이터 임의 수정을 할 시, 현재 퀘스트 도전이 실패합니다.", actions);
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
            TextButton(
                onPressed: () async {
                  await web3apiClient.init();
                  await web3apiClient.burn(
                      widget.address,
                      EtherAmount.fromUnitAndValue(EtherUnit.ether, 1)
                          .getInWei);
                  await web3apiClient.mint(
                      widget.address,
                      EtherAmount.fromUnitAndValue(EtherUnit.ether, 2)
                          .getInWei);
                  await _todayStepsBloc.healthHelper.requestPermission();
                  int goal = 1000;
                  final QuestSteps questSteps = QuestSteps.byTodaySteps(goal);
                  _todayStepsBloc.add(CreateQuestSteps(questSteps: questSteps));
                },
                child: Text("걸음 수 가져오기")),
            Text(
                "Steps: ${(_todayStepsBloc.state.props[0] as QuestSteps).currentSteps}"),
            LinearProgressIndicator(
              value: progressValue,
            )
          ],
        );
      } else if (state is QuestStepsEmpty) {
        return Column(children: [
          TextButton(
              onPressed: () async {
                await web3apiClient.init();
                await web3apiClient.burn(widget.address,
                    EtherAmount.fromUnitAndValue(EtherUnit.ether, 1).getInWei);
                await web3apiClient.mint(widget.address,
                    EtherAmount.fromUnitAndValue(EtherUnit.ether, 2).getInWei);
                await _todayStepsBloc.healthHelper.requestPermission();
                int goal = 1000;
                final QuestSteps questSteps = QuestSteps.byTodaySteps(goal);
                _todayStepsBloc.add(CreateQuestSteps(questSteps: questSteps));
              },
              child: Text("걸음 수 가져오기")),
          Text("Steps: 0")
        ]);
      } else if (state is QuestStepsError) {
        return Text("${state.error}");
      }
      return const CircularProgressIndicator();
    });
  }
}
