import 'package:flutter/material.dart';
import 'package:lycle/src/ui/quest_detail/component/available_quest_list.dart';

class QuestDetailBody extends StatelessWidget {
  int index;

  QuestDetailBody({required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [AvailableQuestList(index: index)],
    );
  }
}
