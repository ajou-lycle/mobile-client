import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:health_kit_reporter/model/type/quantity_type.dart';

import 'package:lycle/src/bloc/wallet/wallet_bloc.dart';
import 'package:lycle/src/bloc/wallet/wallet_event.dart';
import 'package:lycle/src/bloc/wallet/wallet_state.dart';
import 'package:lycle/src/ui/questList/components/card.dart';
import 'package:lycle/src/ui/questList/components/receive_reward_button.dart';

import '../../../utils/balance_to_string.dart';

class QuestListBody extends StatefulWidget {
  @override
  State<QuestListBody> createState() => QuestListBodyState();
}

class QuestListBodyState extends State<QuestListBody> {
  final readTypes = [QuantityType.stepCount];
  final writeTypes = [QuantityType.stepCount];

  late WalletBloc _walletBloc;

  @override
  void initState() {
    super.initState();

    _walletBloc = BlocProvider.of<WalletBloc>(context);
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
          TextButton(
              onPressed: () async {
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
                  QuestListCard(),
                  ReceiveRewardButton()
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
      ))),
    );
  }
}
