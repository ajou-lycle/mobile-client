import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../bloc/current_quest/active/active_current_quest_bloc.dart';
import '../../../bloc/current_quest/manager/manager_current_quest_bloc.dart';
import '../../../bloc/current_quest/manager/manager_current_quest_state.dart';
import '../../../bloc/quest/quest_bloc.dart';
import '../../../bloc/quest/quest_state.dart';
import '../../../constants/assets.dart';
import '../../../constants/ui.dart';
import '../../../data/enum/quest_data_type.dart';
import '../../../data/hero_tag.dart';
import '../../../data/model/quest.dart';

import '../../../routes/routes_enum.dart';
import '../../quest_detail/quest_detail.dart';
import '../constant.dart';
import 'achieve_bar.dart';

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

              return Hero(
                  tag: HeroTag.text(quest.category),
                  child: Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: FractionallySizedBox(
                          child: Ink(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(kDefaultRadius)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            QuestListConstant.cardShadowColor,
                                        offset: Offset(10, 10),
                                        blurRadius: 20,
                                        spreadRadius: 0)
                                  ]),
                              child: InkWell(
                                  onTap: () => Navigator.pushNamed(
                                      context, PageRoutes.questDetail.routeName,
                                      arguments:
                                          QuestDetailArguments(index: index)),
                                  borderRadius:
                                      BorderRadius.circular(kDefaultRadius),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(kDefaultPadding),
                                    child: Column(children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              questDirectionsRunSvg),
                                          const Expanded(
                                              child: Text(
                                            " 걷기",
                                            style: TextStyle(
                                                color: Color(0xff1f1f1f),
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 20.0),
                                          )),
                                          const Text(
                                            "전체보기",
                                            style: TextStyle(
                                                color: kDisableColor,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_right_rounded,
                                            color: kDisableColor,
                                          )
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1,
                                      ),
                                      Row(children: [
                                        Image.asset(
                                          questFirePng,
                                          height:
                                              QuestListConstant.fireIconSize,
                                          width: QuestListConstant.fireIconSize,
                                        ),
                                        const Text(
                                          " 현황",
                                          style: TextStyle(
                                              color: kDisableColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: kDefaultFontSize),
                                        ),
                                      ]),
                                      const SizedBox(
                                        height: kDefaultPadding,
                                      ),
                                      BlocBuilder<ManagerCurrentQuestBloc,
                                              ManagerCurrentQuestState>(
                                          builder: (context, state) {
                                        if (state
                                                is ManagerCurrentQuestLoaded ||
                                            state
                                                is ManagerCurrentQuestUpdated) {
                                          List<Quest> questList =
                                              state.props[0] as List<Quest>;

                                          if (questList.isNotEmpty) {
                                            for (Quest currentQuest
                                                in questList) {
                                              if (currentQuest.category ==
                                                  quest.category) {
                                                return BlocProvider<ActiveCurrentQuestBloc>.value(
                                                    value: _managerCurrentQuestBloc
                                                        .activeCurrentQuestBlocList
                                                        .singleWhere((activeCurrentQuestBloc) =>
                                                            activeCurrentQuestBloc
                                                                .questDataType ==
                                                            QuestDataType.getByCategory(
                                                                quest
                                                                    .category)),
                                                    child: Padding(
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            horizontal:
                                                                kDefaultPadding),
                                                        child: AchieveBar(
                                                            quest:
                                                                currentQuest)));
                                              }
                                            }
                                          }
                                        }

                                        return const SizedBox();
                                      })
                                    ]),
                                  ))))));
            });
      }
      return const CircularProgressIndicator();
    });
  }
}
