import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

import 'package:lycle/src/app.dart';
import 'package:lycle/src/bloc/current_quest/current_quest_bloc.dart';
import 'package:lycle/src/bloc/quest/quest_bloc.dart';
import 'package:lycle/src/bloc/wallet/wallet_bloc.dart';
import 'package:lycle/src/bloc/write_contract/write_contract_bloc.dart';
import 'package:lycle/src/repository/quest/quest_repository.dart';
import 'package:lycle/src/repository/web3/web3_api_client.dart';
import 'package:lycle/src/repository/web3/web3_repository.dart';
import 'package:lycle/src/utils/health_kit_helper.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  final Web3Repository web3repository =
      Web3Repository(web3apiClient: Web3ApiClient());
  final readTypes = [QuantityType.stepCount];
  final writeTypes = [QuantityType.stepCount];

  runApp(MultiBlocProvider(providers: [
    BlocProvider<WriteContractBloc>(
        create: (BuildContext context) =>
            WriteContractBloc(web3Repository: web3repository)),
    BlocProvider<WalletBloc>(
        create: (BuildContext context) =>
            WalletBloc(web3Repository: web3repository)),
    BlocProvider<CurrentQuestBloc>(
        create: (BuildContext context) => CurrentQuestBloc(
            healthHelper: QuantityHealthHelper(
                readTypes: readTypes, writeTypes: writeTypes),
            questRepository: QuestRepository())),
    BlocProvider<QuestBloc>(
        create: (BuildContext context) =>
            QuestBloc(questRepository: QuestRepository())),
  ], child: MyApp()));
}
