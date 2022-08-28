import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/update_frequency.dart';

import 'package:lycle/src/bloc/steps/steps_bloc.dart';
import 'package:lycle/src/utils/health_kit_helper.dart';

import '../../../data/model/steps.dart';
import '../../../bloc/steps/steps_state.dart';

class QuestListBody extends StatefulWidget {
  @override
  State<QuestListBody> createState() => QuestListBodyState();
}

class QuestListBodyState extends State<QuestListBody> {
  final readTypes = <String>[QuantityType.stepCount.identifier];
  final writeTypes = <String>[QuantityType.stepCount.identifier];

  late TodayStepsBloc _todayStepsBloc;
  late HealthHelper healthHelper;

  @override
  void initState() {
    super.initState();
    _todayStepsBloc = BlocProvider.of<TodayStepsBloc>(context);
    healthHelper = HealthHelper(readTypes: readTypes, writeTypes: writeTypes);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await healthHelper.requestPermission();
    observerQuery();
  }

  void observerQuery() async {
    Predicate predicate = Predicate(
        DateTime.now().add(const Duration(days: -6, hours: -15, minutes: -20)),
        DateTime.now());

    final sub = HealthKitReporter.observerQuery(readTypes, predicate,
        onUpdate: (identifier) async {
      print('\n\n\n\nUpdates for observerQuerySub - $identifier');
      try {
        final preferredUnits = await HealthKitReporter.preferredUnits([
          QuantityType.stepCount,
        ]);

        preferredUnits.forEach((preferredUnit) async {
          final identifier = preferredUnit.identifier;
          final unit = preferredUnit.unit;
          print('preferredUnit: ${preferredUnit.map}');
          final type = QuantityTypeFactory.from(identifier);
          try {
            final quantities =
                await HealthKitReporter.quantityQuery(type, unit, predicate);
            num steps = 0;
            quantities.map((e) => e.map).toList().forEach((element) {
              steps += element['harmonized']['value'];
            });
            print('quantity: ${steps / 7}\n');
            final statistics =
                await HealthKitReporter.statisticsQuery(type, unit, predicate);
            print('statistics: ${statistics.map}');
          } catch (e) {
            print(e);
          }
        });
      } catch (e) {
        print(e);
      }
    });

    print('observerQuerySub: $sub');

    final isSet = await HealthKitReporter.enableBackgroundDelivery(
        readTypes.first, UpdateFrequency.immediate);
    print('enableBackgroundDelivery: $isSet');
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
                // result = await exampleHealth();
                setState(() {});
              },
              child: Text("걸음 수 가져오기")),
          // Text(result?.toString() ?? "연동 안 됌"),
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
          // Text("Status: $_status")
        ],
      )),
    );
  }
}
