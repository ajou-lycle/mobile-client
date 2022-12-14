import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

import 'package:lycle/src/bloc/current_quest/manager/manager_current_quest_bloc.dart';

import 'src/app.dart';

import 'src/bloc/quest/quest_bloc.dart';
import 'src/bloc/wallet/wallet_bloc.dart';
import 'src/bloc/write_contract/write_contract_bloc.dart';

import 'src/data/api/web3_api_client.dart';
import 'src/data/repository/quest_repository.dart';
import 'src/data/repository/web3_repository.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
    BlocProvider<ManagerCurrentQuestBloc>(
        create: (BuildContext context) =>
            ManagerCurrentQuestBloc(questRepository: QuestRepository())),
    BlocProvider<QuestBloc>(
        create: (BuildContext context) =>
            QuestBloc(questRepository: QuestRepository())),
  ], child: const MyApp()));
}
