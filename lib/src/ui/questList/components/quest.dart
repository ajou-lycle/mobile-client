// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:web3dart/web3dart.dart';
//
// import '../../../bloc/current_quest/current_quest_bloc.dart';
// import '../../../bloc/current_quest/current_quest_event.dart';
// import '../../../bloc/current_quest/current_quest_state.dart';
// import '../../../bloc/write_contract/write_contract_bloc.dart';
// import '../../../bloc/write_contract/write_contract_event.dart';
// import '../../../constants/ui.dart';
// import '../../../data/enum/contract_function.dart';
// import '../../../data/model/quest.dart';
//
// class QuestComponent extends StatefulWidget {
//   final WriteContractBloc writeContractBloc;
//   final EthereumAddress address;
//
//   QuestComponent({required this.writeContractBloc, required this.address});
//
//   @override
//   State<QuestComponent> createState() => QuestComponentState();
// }
//
// class QuestComponentState extends State<QuestComponent> {
//   late CurrentQuestBloc _questBloc;
//
//   @override
//   void initState() {
//     _questBloc = BlocProvider.of<CurrentQuestBloc>(context);
//   }
//
//   @override
//   void didChangeDependencies() async {
//     super.didChangeDependencies();
//     await _questBloc.questRepository.init();
//   }
//
//   void _showDialog(String title, String content, List<Widget> actions) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // return object of type Dialog
//         return AlertDialog(
//             title: Text(title), content: Text(content), actions: actions);
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CurrentQuestBloc, CurrentQuestState>(
//         buildWhen: (previous, current) {
//       if (previous is CurrentQuestLoaded && current is CurrentQuestDenied) {
//         if (current.isDenied) {
//           List<Widget> actions = <Widget>[
//             OutlinedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text("확인"))
//           ];
//
//           _showDialog("퀘스트 실패", "반복되는 데이터 임의 수정으로, 현재 퀘스트에 실패하였습니다.", actions);
//         } else {
//           List<Widget> actions = <Widget>[
//             OutlinedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text("확인"))
//           ];
//
//           _showDialog(
//               "비매너 행위 경고", "1회 더 데이터 임의 수정을 할 시, 현재 퀘스트 도전이 실패합니다.", actions);
//         }
//       }
//
//       return true;
//     }, builder: (context, state) {
//       if (state is CurrentQuestLoaded ||
//           state is CurrentQuestUpdated ||
//           state is CurrentQuestDenied) {
//         final Quest quest = state.props[0] as Quest;
//         double progressValue = quest.achievement / quest.goal;
//         return Column(
//           children: [
//             TextButton(
//                 onPressed: () async {
//                   showDialog(
//                       context: context,
//                       builder: (context) => CupertinoAlertDialog(
//                               title: Text("토큰을 받으시겠습니까?"),
//                               content: Text(
//                                   "이 퀘스트를 완료할 시, 토큰을 ${quest.rewardToken}개 획득합니다."),
//                               actions: [
//                                 TextButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     child: Text("취소")),
//                                 TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                       widget.writeContractBloc.add(
//                                           SendTransaction(
//                                               contractFunctionEnum:
//                                                   ContractFunctionEnum
//                                                       .getByFunctionName(
//                                                           'mint'),
//                                               to: widget.address,
//                                               amount:
//                                                   EtherAmount.fromUnitAndValue(
//                                                           EtherUnit.ether,
//                                                           quest.rewardToken)
//                                                       .getInWei));
//                                     },
//                                     child: Text(
//                                       "확인",
//                                       style: TextStyle(color: Colors.red),
//                                     )),
//                               ]));
//                 },
//                 child: Text("걷기 퀘스트 보상 받기")),
//             Text("Steps: ${(_questBloc.state.props[0] as Quest).achievement}"),
//             Padding(
//                 padding: const EdgeInsets.all(kDefaultPadding),
//                 child: LinearProgressIndicator(
//                   value: progressValue,
//                 ))
//           ],
//         );
//       } else if (state is CurrentQuestEmpty) {
//         return Column(children: [
//           TextButton(
//               onPressed: () async {
//                 showDialog(
//                     context: context,
//                     builder: (context) => CupertinoAlertDialog(
//                           title: Text("토큰이 소비됩니다."),
//                           content: Text("이 퀘스트를 등록할 시, 토큰이 0개 소비됩니다."),
//                           actions: [
//                             TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: Text("취소")),
//                             TextButton(
//                                 onPressed: () async {
//                                   Navigator.pop(context);
//                                   widget.writeContractBloc.add(SendTransaction(
//                                       contractFunctionEnum: ContractFunctionEnum
//                                           .getByFunctionName('burn'),
//                                       to: widget.address,
//                                       amount: EtherAmount.fromUnitAndValue(
//                                               EtherUnit.ether, 1)
//                                           .getInWei,
//                                       currentQuestBloc: _questBloc,
//                                       category: "걷기",
//                                       level: 0));
//                                 },
//                                 child: Text(
//                                   "확인",
//                                   style: TextStyle(color: Colors.red),
//                                 )),
//                           ],
//                         ));
//               },
//               child: Text("걷기 퀘스트 등록하기")),
//           Text("Steps: 0")
//         ]);
//       } else if (state is CurrentQuestError) {
//         return Text("${state.error}");
//       }
//       return const CircularProgressIndicator();
//     });
//   }
// }
