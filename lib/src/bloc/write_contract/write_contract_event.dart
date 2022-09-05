import 'package:equatable/equatable.dart';
import 'package:web3dart/credentials.dart';

import '../../data/enum/contract_function.dart';
import '../steps/steps_bloc.dart';

abstract class WriteContractEvent extends Equatable {}

class SendTransaction extends WriteContractEvent {
  final QuestStepsBloc? questStepsBloc;
  final ContractFunctionEnum contractFunctionEnum;
  final EthereumAddress? from;
  final EthereumAddress? to;
  final BigInt? amount;

  SendTransaction(
      {required this.contractFunctionEnum,
      this.questStepsBloc,
      this.from,
      this.to,
      this.amount});

  @override
  String toString() =>
      'SendTransaction {contractFunctionEnum: ${contractFunctionEnum.name}, questStepsBloc: $questStepsBloc from: $from, to: $to, amount: $amount}';

  @override
  List<Object?> get props => [contractFunctionEnum, from, to, amount];
}

class SuccessTransaction extends WriteContractEvent {
  final ContractFunctionEnum contractFunctionEnum;
  final int index;
  final QuestStepsBloc? questStepsBloc;

  SuccessTransaction(
      {required this.contractFunctionEnum,
      required this.index,
      this.questStepsBloc});

  @override
  String toString() =>
      'SuccessTransaction { index : $index, questStepsBloc: $questStepsBloc }';

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
