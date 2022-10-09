import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:health_kit_reporter/model/type/quantity_type.dart';

import '../../../bloc/health_manager/ios/health_manager_bloc.dart';

class QuestListBody extends StatefulWidget {
  @override
  State<QuestListBody> createState() => QuestListBodyState();
}

class QuestListBodyState extends State<QuestListBody> {
  late IOSHealthManagerBloc _iosHealthManagerBloc;

  @override
  void initState() {
    super.initState();

    _iosHealthManagerBloc = BlocProvider.of<IOSHealthManagerBloc>(context);
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
          OutlinedButton(
              onPressed: () async {
                final readTypes = [QuantityType.stepCount];
                // final writeTypes = [QuantityType.stepCount];
                _iosHealthManagerBloc.iosHealthRepository.addAccessAuthority(
                    readTypes: readTypes, writeTypes: []);
                await _iosHealthManagerBloc.iosHealthRepository
                    .requestPermission();
              },
              child: Text("걷기")),
          OutlinedButton(
              onPressed: () async {
                final readTypes = [QuantityType.height];
                final writeTypes = [QuantityType.height];
                _iosHealthManagerBloc.iosHealthRepository.addAccessAuthority(
                    readTypes: readTypes, writeTypes: writeTypes);
                await _iosHealthManagerBloc.iosHealthRepository
                    .requestPermission();
              },
              child: Text("높이")),
          OutlinedButton(
              onPressed: () async {
                final readTypes = [QuantityType.distanceWalkingRunning];
                final writeTypes = [QuantityType.distanceWalkingRunning];
                _iosHealthManagerBloc.iosHealthRepository.addAccessAuthority(
                    readTypes: readTypes, writeTypes: writeTypes);
                await _iosHealthManagerBloc.iosHealthRepository
                    .requestPermission();
              },
              child: Text("달리기")),
          // BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
          //   if (state is WalletEmpty) {
          //     return Text("지갑이 연결되지 않았습니다.");
          //   } else if (state is WalletConnected || state is WalletUpdated) {
          //     return Column(
          //       children: [
          //         Text("지갑 주소 : ${_walletBloc.web3Repository.wallet.address}"),
          //         Text(
          //             "지갑 잔고 : ${ethereumBalanceToString(_walletBloc.web3Repository.wallet.ethereumBalance)}"),
          //         Text(
          //             "토큰 잔고 : ${tokenBalanceToString(_walletBloc.web3Repository.wallet.tokenBalance)}"),
          //         QuestListCard(),
          //         ReceiveRewardButton()
          //       ],
          //     );
          //   } else if (state is WalletDisconnected) {
          //     return Text("지갑 연결이 끊어졌습니다.");
          //   } else if (state is WalletError) {
          //     return Text("에러 발생 : ${_walletBloc.state.props[0]}");
          //   }
          //   return CircularProgressIndicator();
          // }),
        ],
      ))),
    );
  }
}
