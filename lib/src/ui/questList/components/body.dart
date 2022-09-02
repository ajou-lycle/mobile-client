import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:health_kit_reporter/model/type/quantity_type.dart';

import 'package:lycle/src/bloc/steps/steps_bloc.dart';

import 'package:lycle/src/bloc/wallet/wallet_bloc.dart';
import 'package:lycle/src/bloc/wallet/wallet_event.dart';
import 'package:lycle/src/bloc/wallet/wallet_state.dart';
import 'package:lycle/src/ui/questList/components/steps.dart';
import 'package:web3dart/web3dart.dart';

import '../../../repository/web3/web3_api_client.dart';
import '../../../utils/balance_to_string.dart';

class QuestListBody extends StatefulWidget {
  @override
  State<QuestListBody> createState() => QuestListBodyState();
}

class QuestListBodyState extends State<QuestListBody> {
  Web3ApiClient web3apiClient = Web3ApiClient();

  final readTypes = [QuantityType.stepCount];
  final writeTypes = [QuantityType.stepCount];

  num steps = 0;

  late WalletBloc _walletBloc;
  late QuestStepsBloc _todayStepsBloc;

  @override
  void initState() {
    super.initState();
    _walletBloc = BlocProvider.of<WalletBloc>(context);
    _todayStepsBloc = BlocProvider.of<QuestStepsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                _walletBloc.add(ConnectWallet(walletAddress: null));
              },
              child: Text("로그인하기")),
          TextButton(onPressed: () async {}, child: Text("세션 업데이트하기")),
          TextButton(
              onPressed: () async {
                _walletBloc.add(DisconnectWallet());
              },
              child: Text("로그아웃하기")),
          BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
            if (state is WalletEmpty) {
              return Text("지갑이 연결되지 않았습니다.");
            } else if (state is WalletConnected || state is WalletUpdated) {
              return Column(
                children: [
                  Text("지갑 주소 : ${_walletBloc.web3Repository.wallet.address}"),
                  Text(
                      "지갑 잔고 : ${ethereumBalanceToString(_walletBloc.web3Repository.wallet.ethereumBalance)}"),
                  Text(
                      "토큰 잔고 : ${tokenBalanceToString(_walletBloc.web3Repository.wallet.tokenBalance)}"),
                  QuestListSteps(
                      address: _walletBloc.web3Repository.wallet.address!)
                ],
              );
            } else if (state is WalletDisconnected) {
              return Text("지갑 연결이 끊어졌습니다.");
            } else if (state is WalletError) {
              return Text("에러 발생 : ${_walletBloc.state.props[0]}");
            }
            return CircularProgressIndicator();
          }),
        ],
      )),
    );
  }
}
