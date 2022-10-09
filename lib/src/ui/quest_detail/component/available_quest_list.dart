import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:web3dart/web3dart.dart';

import '../../../bloc/current_quest/manager/manager_current_quest_bloc.dart';
import '../../../bloc/current_quest/manager/manager_current_quest_event.dart';
import '../../../bloc/wallet/wallet_bloc.dart';
import '../../../bloc/write_contract/write_contract_bloc.dart';
import '../../../bloc/write_contract/write_contract_event.dart';
import '../../../constants/assets.dart';
import '../../../constants/ui.dart';
import '../../../data/enum/contract_function.dart';
import '../../../data/enum/quest_data_type.dart';
import '../../../data/model/quest.dart';

class AvailableQuestList extends StatefulWidget {
  final List<Quest> availableQuests;

  const AvailableQuestList({Key? key, required this.availableQuests})
      : super(key: key);

  @override
  State<AvailableQuestList> createState() => AvailableQuestListState();
}

class AvailableQuestListState extends State<AvailableQuestList> {
  late ManagerCurrentQuestBloc _managerCurrentQuestBloc;
  late WalletBloc _walletBloc;
  late WriteContractBloc _writeContractBloc;
  late final List<bool> _isOpen;

  Future<void> requestQuest(Quest quest) async {
    if (quest.needToken > 0) {
      _writeContractBloc.add(SendTransaction(
          contractFunctionEnum: ContractFunctionEnum.getByFunctionName('burn'),
          to: _walletBloc.web3Repository.wallet.address,
          amount: EtherAmount.fromUnitAndValue(EtherUnit.ether, quest.needToken)
              .getInWei,
          successCallback:
              _managerCurrentQuestBloc.callbackWhenRequestQuestSucceed,
          successCallbackParameter: [quest, _walletBloc]));
    } else {
      _managerCurrentQuestBloc.add(CreateCurrentQuest(quest: quest));
    }
  }

  void addQuest(Quest quest) {
    if (_managerCurrentQuestBloc.iosHealthRepository.questDataTypeList
        .contains(QuestDataType.getByCategory(quest.category))) {
      showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: const Text("진행 중인 퀘스트가 있습니다."),
                content: const Text("이 퀘스트를 등록할 시,\n현재 진행 중인 퀘스트는 중도 취소됩니다."),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("취소")),
                  TextButton(
                      onPressed: () async {
                        _managerCurrentQuestBloc.iosHealthRepository
                            .deleteAccessAuthority(
                                questDataType: QuestDataType.getByCategory(
                                    quest.category));
                        _managerCurrentQuestBloc
                            .add(DeleteCurrentQuest(questList: [quest]));
                        Navigator.pop(context);
                        requestQuest(quest);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "확인",
                        style: TextStyle(color: Colors.red),
                      )),
                ],
              ));
      return;
    }

    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("토큰이 소비됩니다."),
              content: Text("이 퀘스트를 등록할 시, 토큰이 ${quest.needToken}개 소비됩니다."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("취소")),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await requestQuest(quest);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "확인",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ));
  }

  String goalText(String category) {
    final type = QuestDataType.getByCategory(category);

    switch (type) {
      case (QuestDataType.walking):
        return "걸음";
      case (QuestDataType.running):
        return "km";
      default:
        return "오류";
    }
  }

  String timeLimitText(Duration timeLimit) {
    if (timeLimit.inDays > 0) {
      return "${timeLimit.inDays}일";
    } else {
      return "${timeLimit.inMinutes}분";
    }
  }

  @override
  void initState() {
    super.initState();

    _managerCurrentQuestBloc =
        BlocProvider.of<ManagerCurrentQuestBloc>(context);
    _walletBloc = BlocProvider.of<WalletBloc>(context);
    _writeContractBloc = BlocProvider.of<WriteContractBloc>(context);
    _isOpen = List<bool>.filled(widget.availableQuests.length, false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.availableQuests.length,
        itemBuilder: (context, index) {
          Quest quest = widget.availableQuests[index];
          Duration questDuration = quest.finishDate.difference(quest.startDate);

          return GestureDetector(
              onTap: () => setState(
                    () => _isOpen[index] = !_isOpen[index],
                  ),
              child: Stack(children: [
                AnimatedSize(
                    duration: const Duration(milliseconds: 150),
                    child: Column(children: [
                      Container(
                          height: _isOpen[index] ? 150 : 0,
                          width: size.width - kDefaultPadding * 2,
                          padding: const EdgeInsets.all(kDefaultPadding),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x14000000),
                                    offset: Offset(10, 10),
                                    blurRadius: 20,
                                    spreadRadius: 0)
                              ],
                              color: Color(0xffffffff)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    questRewardSvg,
                                    height: 12,
                                    width: 12,
                                  ),
                                  const Text(
                                    " 보상 : NFT 1개",
                                    style: TextStyle(
                                        color: Color(0xff3e3e3e),
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    questTimeSvg,
                                    height: 12,
                                    width: 12,
                                  ),
                                  Text(
                                    " 기간 : ${questDuration.inDays}일 ${questDuration.inHours - questDuration.inDays * 24}시간 ${questDuration.inMinutes - questDuration.inHours * 60}분",
                                    style: const TextStyle(
                                        color: Color(0xff3e3e3e),
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                  )
                                ],
                              )
                            ],
                          )),
                      const SizedBox(
                        height: kDefaultPadding,
                      )
                    ])),
                Padding(
                    padding: const EdgeInsets.only(bottom: kDefaultPadding),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: kHalfPadding,
                            horizontal: kDefaultPadding),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultRadius)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x14000000),
                                  offset: Offset(10, 10),
                                  blurRadius: 5,
                                  spreadRadius: 0)
                            ],
                            color: Color(0xffffffff)),
                        child: Row(
                          children: [
                            Text(
                              "${quest.level + 1} 단계",
                              style: const TextStyle(
                                  color: const Color(0xff606060),
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18.0),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kHalfPadding),
                                child: Container(
                                    width: 1,
                                    height: 56,
                                    decoration: const BoxDecoration(
                                        color: Color(0xffe1e1e1)))),
                            Expanded(
                                child: RichText(
                                    text: TextSpan(children: [
                              TextSpan(
                                  style: const TextStyle(
                                      color: Color(0xff606060),
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0),
                                  text: "${quest.goal} "),
                              TextSpan(
                                  style: const TextStyle(
                                      color: Color(0xff606060),
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  text: "${goalText(quest.category)}")
                            ]))),
                            Material(
                                child: Ink(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16 + 4)),
                                        color: kPrimaryColor),
                                    child: InkWell(
                                      onTap: () => addQuest(quest),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(
                                              kHalfPadding),
                                          child: Row(
                                            children: [
                                              Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal:
                                                          kHalfPadding / 2),
                                                  height: 24,
                                                  decoration:
                                                      const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color(
                                                                    0x14000000),
                                                                offset: Offset(
                                                                    10, 10),
                                                                blurRadius: 20,
                                                                spreadRadius: 0)
                                                          ],
                                                          color: Color(
                                                              0x44000000)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        questTokenPng,
                                                        height: 16,
                                                        width: 16,
                                                      ),
                                                      Text(
                                                        " ${quest.needToken}",
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      )
                                                    ],
                                                  )),
                                              const Text(" 도전하기",
                                                  style: TextStyle(
                                                      color: Color(0xffffffff),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 14.0),
                                                  textAlign: TextAlign.center),
                                            ],
                                          )),
                                    ))),
                            const SizedBox(
                              width: kHalfPadding,
                            ),
                            Icon(
                              _isOpen[index]
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: Color(0xffa2a2a2),
                            )
                          ],
                        ))),
              ]));
        });
  }
}
