import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/current_quest/manager/manager_current_quest_bloc.dart';
import '../../../bloc/current_quest/manager/manager_current_quest_event.dart';
import '../../../bloc/current_quest/manager/manager_current_quest_state.dart';

import '../../../bloc/wallet/wallet_bloc.dart';
import '../../../data/model/quest.dart';
import 'card.dart';
import 'receive_reward_button.dart';

class QuestListBody extends StatefulWidget {
  @override
  State<QuestListBody> createState() => QuestListBodyState();
}

class QuestListBodyState extends State<QuestListBody> {
  late WalletBloc _walletBloc;
  late ManagerCurrentQuestBloc _managerCurrentQuestBloc;

  @override
  void initState() {
    super.initState();

    _walletBloc = BlocProvider.of<WalletBloc>(context);
    _managerCurrentQuestBloc =
        BlocProvider.of<ManagerCurrentQuestBloc>(context);
    _managerCurrentQuestBloc.questRepository.ethereumAddress =
        _walletBloc.web3Repository.wallet.address;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          child: Center(
              child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          QuestListCard(),
          BlocBuilder<ManagerCurrentQuestBloc, ManagerCurrentQuestState>(
              bloc: _managerCurrentQuestBloc,
              builder: (context, state) {
                if (state is ManagerCurrentQuestEmpty) {
                  return Text("퀘스트가 없습니다.");
                } else if (state is ManagerCurrentQuestLoading) {
                  return Column(
                    children: [
                      CircularProgressIndicator(),
                      Text("퀘스트를 불러오는 중입니다.")
                    ],
                  );
                } else if (state is ManagerCurrentQuestLoaded ||
                    state is ManagerCurrentQuestUpdated) {
                  List<Quest> questList = state.props[0] as List<Quest>;
                  return Column(
                    children: [Text("퀘스트를 불러왔습니다."), ReceiveRewardButton()],
                  );
                }

                return Text("에러가 발생했습니다.");
              })
        ],
      ))),
    );
  }
}
