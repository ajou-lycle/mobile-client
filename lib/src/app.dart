import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

import 'package:lycle/src/ui/home/home.dart';
import 'package:lycle/src/utils/health_kit_helper.dart';

import 'bloc/steps/steps_bloc.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final readTypes = [QuantityType.stepCount];
  final writeTypes = [QuantityType.stepCount];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<QuestStepsBloc>(
          create: (BuildContext context) => QuestStepsBloc(
              healthHelper: QuantityHealthHelper(
                  readTypes: readTypes, writeTypes: writeTypes)),
          child: HomePage()),
    );
  }
}
