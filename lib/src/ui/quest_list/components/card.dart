import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lycle/src/bloc/quest/quest_state.dart';

import 'package:lycle/src/ui/quest_list/components/achieve_bar.dart';

import '../../../bloc/quest/quest_bloc.dart';
import '../../../data/model/quest.dart';
import '../../quest_detail/quest_detail.dart';

class QuestListCard extends StatefulWidget {
  @override
  State<QuestListCard> createState() => QuestListCardState();
}

class QuestListCardState extends State<QuestListCard> {
  late QuestBloc _questBloc;

  @override
  void initState() {
    super.initState();

    _questBloc = BlocProvider.of<QuestBloc>(context);
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
            itemBuilder: (_, index) {
              Quest quest =
                  _questBloc.questRepository.availableQuests[index][0];

              return Column(
                children: [
                  OutlinedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => QuestDetailPage(
                                    index: index,
                                  ))),
                      child: Text(quest.category)),
                  AchieveBar(quest: quest)
                ],
              );
            });
      }
      return CircularProgressIndicator();
    });
  }
}
