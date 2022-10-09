import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/constants/ui.dart';

import '../../../bloc/quest/quest_bloc.dart';
import 'app_bar.dart';
import 'available_quest_list.dart';
import 'balance.dart';
import 'card.dart';

class QuestDetailBody extends StatefulWidget {
  int index;

  QuestDetailBody({required this.index});

  @override
  State<StatefulWidget> createState() => QuestDetailBodyState();
}

class QuestDetailBodyState extends State<QuestDetailBody> {
  late QuestBloc _questBloc;

  @override
  void initState() {
    super.initState();

    _questBloc = BlocProvider.of<QuestBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final availableQuests =
        _questBloc.questRepository.availableQuests[widget.index];
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const QuestDetailAppBar(),
        const SizedBox(
          height: kDefaultPadding,
        ),
        Padding(
            padding: const EdgeInsets.only(
                top: kHalfPadding,
                bottom: kDefaultPadding,
                left: kDefaultPadding,
                right: kDefaultPadding),
            child: QuestDetailBalance()),
        Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: QuestDetailCard(
              quest: availableQuests.first,
            )),
        Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: AvailableQuestList(
              availableQuests: availableQuests,
            ))
      ],
    ));
  }
}
