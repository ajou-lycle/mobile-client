import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/bloc/current_quest/current_quest_bloc.dart';
import 'package:lycle/src/bloc/current_quest/current_quest_state.dart';
import 'package:lycle/src/bloc/quest/quest_state.dart';
import 'package:lycle/src/ui/questList/components/achieve_bar.dart';

import '../../../bloc/quest/quest_bloc.dart';
import '../../../data/model/quest.dart';
import '../../questDetail/quest_detail.dart';

class QuestListCard extends StatefulWidget {
  @override
  State<QuestListCard> createState() => QuestListCardState();
}

class QuestListCardState extends State<QuestListCard> {
  late QuestBloc _questBloc;
  late CurrentQuestBloc _currentQuestBloc;

  @override
  void initState() {
    super.initState();

    _questBloc = BlocProvider.of<QuestBloc>(context);
    _currentQuestBloc = BlocProvider.of<CurrentQuestBloc>(context);
  }

  Widget getAchieveBar(Quest quest) {
    if (_currentQuestBloc.state is CurrentQuestLoaded ||
        _currentQuestBloc.state is CurrentQuestUpdated) {
      final questList = _currentQuestBloc.state.props[0] as List<Quest>;

      for (Quest currentQuest in questList) {
        if (currentQuest.category == quest.category) {
          final value = currentQuest.achievement / currentQuest.goal;
          return AchieveBar(value: value);
        }
      }
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestBloc, QuestState>(builder: (context, state) {
      if (state is QuestEmpty) {
        return Container();
      } else if (state is QuestLoaded || state is QuestUpdated) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: _questBloc.questRepository.availableQuests.length,
            itemBuilder: (context, index) {
              Quest quest =
                  _questBloc.questRepository.availableQuests[index][0];
              return Column(
                children: [
                  OutlinedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestDetailPage(
                                    index: index,
                                  ))),
                      child: Text(quest.category)),
                  getAchieveBar(quest)
                ],
              );
            });
      }
      return CircularProgressIndicator();
    });
  }
}
