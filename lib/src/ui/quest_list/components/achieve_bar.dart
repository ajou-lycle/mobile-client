import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/bloc/current_quest/manager/manager_current_quest_event.dart';
import 'package:lycle/src/ui/quest_list/constant.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(kDefaultRadius)),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        QuestListConstant.achieveBarShadowColor,
                                    offset: Offset(3, 3),
                                    blurRadius: 6,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(kDefaultRadius)),
                              child: LinearPercentIndicator(
                                padding: const EdgeInsets.all(0),
                                animation: true,
                                lineHeight: 20,
                                animationDuration: 1000,
                                percent: quest.achievement / quest.goal,
                                center:
                                    Text("${quest.achievement * 100 / quest.goal}%"),
                                barRadius: Radius.circular(kDefaultRadius),
                                backgroundColor:
                                    QuestListConstant.achieveBarBackgroundColor,
                                progressColor: kPrimaryColor,
                              ),
                            ))),
                  ],
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Text(
                    "${quest.achievement} / ${quest.goal} ${QuestDataType.getByCategory(quest.category).unit}"),
              ]);
            }
          }
          return const SizedBox();
        });
  }
}
