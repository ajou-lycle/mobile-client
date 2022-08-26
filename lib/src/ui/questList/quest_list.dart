import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/bloc/steps/steps_bloc.dart';
import 'package:lycle/src/ui/questList/components/body.dart';

class QuestListPage extends StatefulWidget {
  @override
  State<QuestListPage> createState() => QuestListPageState();
}

class QuestListPageState extends State<QuestListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: QuestListBody());
  }
}
