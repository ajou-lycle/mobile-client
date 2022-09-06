import 'package:equatable/equatable.dart';
import 'package:web3dart/credentials.dart';

import '../../data/enum/contract_function.dart';
import '../current_quest/current_quest_bloc.dart';

abstract class WriteContractEvent extends Equatable {}

class SendTransaction extends WriteContractEvent {
  final ContractFunctionEnum contractFunctionEnum;
  final EthereumAddress? from;
  final EthereumAddress? to;
  final BigInt? amount;
  final CurrentQuestBloc? currentQuestBloc;
  final String? category;
  final int? level;

  SendTransaction(
      {required this.contractFunctionEnum,
      this.from,
      this.to,
      this.amount,
      this.currentQuestBloc,
      this.category,
      this.level});

  @override
  String toString() => '''SendTransaction {
      contractFunctionEnum: ${contractFunctionEnum.name}, 
      from: $from, to: $to, amount: $amount
      questStepsBloc: $currentQuestBloc, category: $category, level: $level
      }''';

  @override
  List<Object?> get props => [contractFunctionEnum, from, to, amount];
}

class SuccessTransaction extends WriteContractEvent {
  final ContractFunctionEnum contractFunctionEnum;
  final int index;
  final CurrentQuestBloc? questStepsBloc;
  final String? category;
  final int? level;

  SuccessTransaction(
      {required this.contractFunctionEnum,
      required this.index,
      this.questStepsBloc,
      this.category,
      this.level});

  @override
  String toString() =>
      'SuccessTransaction { index : $index, questStepsBloc: $questStepsBloc, category: $category, level: $level }';

  @override
  List<Object?> get props => [contractFunctionEnum, index, questStepsBloc];
}

class FailTransaction extends WriteContractEvent {
  final int index;

  FailTransaction({required this.index});

  @override
  String toString() => 'FailTransaction { index : $index }';

  @override
  List<Object?> get props => [index];
}

class ErrorWriteContract extends WriteContractEvent {
  final String error;

  ErrorWriteContract({required this.error});

  @override
  String toString() => 'ErrorWriteContract { error : $error }';

  @override
  List<Object?> get props => [error];
}
