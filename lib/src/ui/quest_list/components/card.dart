import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/ui/quest_list/components/achieve_bar.dart';

import '../../../bloc/current_quest/active/active_current_quest_bloc.dart';
import '../../../bloc/current_quest/manager/manager_current_quest_bloc.dart';
import '../../../bloc/current_quest/manager/manager_current_quest_state.dart';
import '../../../bloc/quest/quest_bloc.dart';
import '../../../bloc/quest/quest_state.dart';
import '../../../data/enum/quest_data_type.dart';
import '../../../data/model/quest.dart';
import '../../../routes/routes_enum.dart';
import '../../quest_detail/quest_detail.dart';

class QuestListCard extends StatefulWidget {
  @override
  State<QuestListCard> createState() => QuestListCardState();
}

class QuestListCardState extends State<QuestListCard> {
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
                      onPressed: () => Navigator.pushNamed(
                          context, PageRoutes.questDetail.routeName,
                          arguments: QuestDetailArguments(index: index)),
                      child: Text(quest.category)),
                  BlocBuilder<ManagerCurrentQuestBloc,
                      ManagerCurrentQuestState>(builder: (context, state) {
                    if (state is ManagerCurrentQuestLoaded ||
                        state is ManagerCurrentQuestUpdated) {
                      List<Quest> questList = state.props[0] as List<Quest>;

                      if (questList.isNotEmpty) {
                        for (Quest currentQuest in questList) {
                          if (currentQuest.category == quest.category) {
                            return BlocProvider<ActiveCurrentQuestBloc>.value(
                                value: _managerCurrentQuestBloc
                                    .activeCurrentQuestBlocList
                                    .singleWhere((activeCurrentQuestBloc) =>
                                        activeCurrentQuestBloc.questDataType ==
                                        QuestDataType.getByCategory(
                                            quest.category)),
                                child: AchieveBar(quest: currentQuest));
                          }
                        }
                      }
                    }

                    return const SizedBox();
                  })
                ],
              );
            });
      }
      return CircularProgressIndicator();
    });
  }
}
