import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lycle/src/ui/quest_list/components/body.dart';

import '../../bloc/current_quest/active/active_current_quest_bloc.dart';
import '../../bloc/current_quest/active/active_current_quest_event.dart';
import '../../bloc/quest/quest_bloc.dart';
import '../../bloc/quest/quest_event.dart';
import '../../bloc/wallet/wallet_bloc.dart';

class QuestListPage extends StatefulWidget {
  @override
  State<QuestListPage> createState() => QuestListPageState();
}

class QuestListPageState extends State<QuestListPage> {
  // late QuestBloc _questBloc;
  // late WalletBloc _walletBloc;
  // late ActiveCurrentQuestBloc _currentQuestBloc;
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   _questBloc = BlocProvider.of<QuestBloc>(context);
  //   _walletBloc = BlocProvider.of<WalletBloc>(context);
  //   _currentQuestBloc = BlocProvider.of<ActiveCurrentQuestBloc>(context);
  //   _currentQuestBloc.ethereumAddress =
  //       _walletBloc.web3Repository.wallet.address;
  // }
  //
  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //
  //   await _questBloc.questRepository.init();
  //   await _currentQuestBloc.healthHelper.requestPermission();
  //   await _currentQuestBloc.questRepository.init().then((value) {
  //     _questBloc.add(GetQuest());
  //     _currentQuestBloc.add(GetActiveCurrentQuest());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: QuestListBody());
  }
}
