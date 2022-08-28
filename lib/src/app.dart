import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lycle/src/ui/home/home.dart';

import 'bloc/steps/steps_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<TodayStepsBloc>(
          create: (BuildContext context) => TodayStepsBloc(),
          child: HomePage()),
    );
  }
}
