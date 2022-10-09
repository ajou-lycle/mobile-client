import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/data/enum/quest_data_type.dart';

import '../../bloc/current_quest/active/active_current_quest_bloc.dart';
import '../../bloc/current_quest/manager/manager_current_quest_bloc.dart';
import '../../bloc/current_quest/manager/manager_current_quest_event.dart';
import '../../bloc/quest/quest_bloc.dart';
import '../../bloc/quest/quest_event.dart';
import 'components/body.dart';

class QuestListPage extends StatefulWidget {
  @override
  State<QuestListPage> createState() => QuestListPageState();
}

class QuestListPageState extends State<QuestListPage> {
  late QuestBloc _questBloc;
  late ManagerCurrentQuestBloc _managerCurrentQuestBloc;

  @override
  void initState() {
    super.initState();

    _questBloc = BlocProvider.of<QuestBloc>(context);
    _managerCurrentQuestBloc =
        BlocProvider.of<ManagerCurrentQuestBloc>(context);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await _managerCurrentQuestBloc.questRepository.init();
    _managerCurrentQuestBloc.activeCurrentQuestBlocList = [];
    for (QuestDataType questDataType in _questBloc.availableQuestDataTypeList) {
      _managerCurrentQuestBloc.activeCurrentQuestBlocList.add(
          ActiveCurrentQuestBloc(
              questRepository: _managerCurrentQuestBloc.questRepository,
              questDataType: questDataType));
    }
    _managerCurrentQuestBloc.add(GetCurrentQuest());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: QuestListBody());
  }
}
