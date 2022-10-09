import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/current_quest/active/active_current_quest_bloc.dart';
import '../../../bloc/current_quest/active/active_current_quest_state.dart';
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
  late ActiveCurrentQuestBloc _currentQuestBloc;

  @override
  void initState() {
    _currentQuestBloc = BlocProvider.of<ActiveCurrentQuestBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActiveCurrentQuestBloc, ActiveCurrentQuestState>(
        bloc: _currentQuestBloc,
        listener: (context, state) {
          if (state is ActiveCurrentQuestAchieved) {
            final questList = state.props[0] as List<Quest>;
            for (Quest quest in questList) {
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
            }
          }
        },
        builder: (context, state) {
          if (state is ActiveCurrentQuestLoaded || state is ActiveCurrentQuestUpdated) {
            final questList = state.props[0] as List<Quest>;

            for (Quest currentQuest in questList) {
              if (currentQuest.category == widget.quest.category) {
                final value = currentQuest.achievement / currentQuest.goal;
                return Column(children: [
                  Text(
                      "목표 : ${currentQuest.goal} ${QuestDataType.getByCategory(currentQuest.category).unit}"),
                  Text(
                      "달성 : ${currentQuest.achievement} ${QuestDataType.getByCategory(currentQuest.category).unit}"),
                  Row(
                    children: [
                      Expanded(child: LinearProgressIndicator(value: value)),
                      Text("${value * 100 ~/ 1}%")
                    ],
                  )
                ]);
              }
            }
          }

          return Container();
        });
  }
}
