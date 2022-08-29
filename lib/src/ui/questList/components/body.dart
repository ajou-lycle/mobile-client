import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/update_frequency.dart';

import 'package:lycle/src/bloc/steps/steps_bloc.dart';
import 'package:lycle/src/bloc/steps/steps_events.dart';
import 'package:lycle/src/utils/health_kit_helper.dart';

import '../../../data/model/steps.dart';
import '../../../bloc/steps/steps_state.dart';

class QuestListBody extends StatefulWidget {
  @override
  State<QuestListBody> createState() => QuestListBodyState();
}

class QuestListBodyState extends State<QuestListBody> {
  final readTypes = [QuantityType.stepCount];
  final writeTypes = [QuantityType.stepCount];

  num steps = 0;

  late TodayStepsBloc _todayStepsBloc;
  late QuantityHealthHelper healthHelper;

  @override
  void initState() {
    super.initState();
    _todayStepsBloc = BlocProvider.of<TodayStepsBloc>(context);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
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
                await _todayStepsBloc.healthHelper.requestPermission();
                print("hello");
                final Steps steps = Steps.byTodaySteps();
                _todayStepsBloc.add(CreateTodaySteps(steps: steps));
              },
              child: Text("걸음 수 가져오기")),
          BlocBuilder<TodayStepsBloc, TodayStepsState>(
              builder: (context, state) {
            print(state);
            if (state is TodayStepsLoaded) {
              return Text(
                  "Steps: ${(_todayStepsBloc.state.props[0] as Steps).currentSteps}");
            } else if (state is TodayStepsError) {
              return Text("${state.error}");
            }
            return const CircularProgressIndicator();
          }),
        ],
      )),
    );
  }
}
