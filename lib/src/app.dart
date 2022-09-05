import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:lycle/src/bloc/write_contract/write_contract_bloc.dart';
import 'package:lycle/src/repository/web3/web3_api_client.dart';
import 'package:lycle/src/repository/web3/web3_repository.dart';

import 'package:lycle/src/ui/home/home.dart';
import 'package:lycle/src/utils/health_kit_helper.dart';

import 'bloc/steps/steps_bloc.dart';
import 'bloc/wallet/wallet_bloc.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Web3Repository web3repository =
      Web3Repository(web3apiClient: Web3ApiClient());
  final readTypes = [QuantityType.stepCount];
  final writeTypes = [QuantityType.stepCount];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(providers: [
        BlocProvider<WriteContractBloc>(
            create: (BuildContext context) =>
                WriteContractBloc(web3Repository: web3repository)),
        BlocProvider<WalletBloc>(
          create: (BuildContext context) =>
              WalletBloc(web3Repository: web3repository),
        ),
        BlocProvider<QuestStepsBloc>(
          create: (BuildContext context) => QuestStepsBloc(
              healthHelper: QuantityHealthHelper(
                  readTypes: readTypes, writeTypes: writeTypes)),
        )
      ], child: HomePage()),
    );
  }
}
