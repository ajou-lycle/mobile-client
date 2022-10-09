import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/bloc/current_quest/manager/manager_current_quest_event.dart';

import '../../../bloc/current_quest/active/active_current_quest_bloc.dart';
import '../../../bloc/current_quest/active/active_current_quest_event.dart';
import '../../../bloc/current_quest/active/active_current_quest_state.dart';
import '../../../bloc/current_quest/manager/manager_current_quest_bloc.dart';
import '../../../bloc/current_quest/manager/manager_current_quest_state.dart';
import '../../../constants/ui.dart';
import '../../../data/enum/quest_data_type.dart';
import '../../../data/model/quest.dart';

class AchieveBar extends StatefulWidget {
  final Quest quest;

  AchieveBar({required this.quest});

  @override
  State<AchieveBar> createState() => AchieveBarState();
}

class AchieveBarState extends State<AchieveBar> {
  late ManagerCurrentQuestBloc _managerCurrentQuestBloc;
  late ActiveCurrentQuestBloc _activeCurrentQuestBloc;

  @override
  void initState() {
    super.initState();
    _managerCurrentQuestBloc =
        BlocProvider.of<ManagerCurrentQuestBloc>(context);
    _activeCurrentQuestBloc = BlocProvider.of<ActiveCurrentQuestBloc>(context);
    _activeCurrentQuestBloc.add(CreateActiveCurrentQuest(quest: widget.quest));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActiveCurrentQuestBloc, ActiveCurrentQuestState>(
        bloc: _activeCurrentQuestBloc,
        listener: (context, state) {
          if (state is ActiveCurrentQuestAchieved) {
            Quest quest = state.quest;
            if (quest.achieveDate != null) {
              if (!isSnackbarActive) {
                isSnackbarActive = true;

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                        content: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                        ),
                        Text("${quest.category} 퀘스트를 완료했습니다.")
                      ],
                    )))
                    .closed
                    .then((value) => isSnackbarActive = false);
              }
            }
            _managerCurrentQuestBloc.add(AchieveCurrentQuest(quest: quest));
          }
        },
        builder: (context, state) {
          if (state is ActiveCurrentQuestLoaded ||
              state is ActiveCurrentQuestUpdated) {
            Quest quest = state.props[0] as Quest;
            if (quest.category == widget.quest.category) {
              final value = quest.achievement / quest.goal;
              return Column(children: [
                Text(
                    "목표 : ${quest.goal} ${QuestDataType.getByCategory(quest.category).unit}"),
                Text(
                    "달성 : ${quest.achievement} ${QuestDataType.getByCategory(quest.category).unit}"),
                Row(
                  children: [
                    Expanded(child: LinearProgressIndicator(value: value)),
                    Text("${value * 100 ~/ 1}%")
                  ],
                )
              ]);
            }
          }
          return const SizedBox();
        });
  }
}
