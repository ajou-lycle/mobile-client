import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:lycle/src/bloc/write_contract/write_contract_event.dart';
import 'package:lycle/src/constants/ui.dart';
import 'package:lycle/src/data/enum/contract_function.dart';
import 'package:lycle/src/repository/web3/web3_api_client.dart';
import 'package:lycle/src/ui/questList/components/quest.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

import '../../../bloc/current_quest/current_quest_bloc.dart';

import '../../../bloc/wallet/wallet_bloc.dart';
import '../../../bloc/wallet/wallet_event.dart';
import '../../../bloc/write_contract/write_contract_bloc.dart';
import '../../../bloc/write_contract/write_contract_state.dart';

import '../../../repository/quest/quest_repository.dart';
import '../../../utils/health_kit_helper.dart';

class QuestListSteps extends StatefulWidget {
  final EthereumAddress address;

  QuestListSteps({required this.address});

  @override
  State<QuestListSteps> createState() => QuestListStepsState();
}

class QuestListStepsState extends State<QuestListSteps> {
  Web3ApiClient web3apiClient = Web3ApiClient();

  final readTypes = [QuantityType.stepCount];
  final writeTypes = [QuantityType.stepCount];

  num steps = 0;

  late WriteContractBloc _writeContractBloc;
  late WalletBloc _walletBloc;
  late CurrentQuestBloc _questBloc;
  late CurrentQuestBloc _quest2Bloc;

  @override
  void initState() {
    super.initState();
    _writeContractBloc = BlocProvider.of<WriteContractBloc>(context);
    _walletBloc = BlocProvider.of<WalletBloc>(context);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  void _showDialog(String title, String content, List<Widget> actions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: Text(title), content: Text(content), actions: actions);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WriteContractBloc, WriteContractState>(
      bloc: _writeContractBloc,
      listener: (context, state) {
        if (state is TransactionSend) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
            children: [CircularProgressIndicator(), Text("요청을 처리 중입니다.")],
          )));
        } else if (state is TransactionSucceed) {
          _walletBloc.add(UpdateWallet());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
              ),
              Text("요청이 성공했습니다.")
            ],
          )));
        } else if (state is TransactionFailed || state is WriteContractError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
            children: [
              Icon(
                Icons.close_rounded,
                color: Colors.red,
              ),
              Text("요청이 실패했습니다.")
            ],
          )));
        }
      },
      child:  QuestComponent(
            writeContractBloc: _writeContractBloc, address: widget.address),
      );
  }
}
