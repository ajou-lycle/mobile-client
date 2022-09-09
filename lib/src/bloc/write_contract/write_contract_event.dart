import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:web3dart/credentials.dart';

import '../../data/enum/contract_function.dart';

abstract class WriteContractEvent extends Equatable {}

class SendTransaction extends WriteContractEvent {
  final ContractFunctionEnum contractFunctionEnum;
  final EthereumAddress? from;
  final EthereumAddress? to;
  final BigInt? amount;
  final List? successCallbackParameter;
  final Future<bool> Function(ContractFunctionEnum, List)? successCallback;

  SendTransaction({
    required this.contractFunctionEnum,
    this.from,
    this.to,
    this.amount,
    this.successCallbackParameter,
    this.successCallback,
  });

  @override
  String toString() => '''SendTransaction {
      contractFunctionEnum: ${contractFunctionEnum.name}, 
      from: $from, to: $to, amount: $amount,
      successCallbackParameter: $successCallbackParameter, successCallback: $successCallback
      }''';

  @override
  List<Object?> get props => [
        contractFunctionEnum,
        from,
        to,
        amount,
        successCallbackParameter,
        successCallback
      ];
}

class SuccessTransaction extends WriteContractEvent {
  final ContractFunctionEnum contractFunctionEnum;
  final int index;
  final List? callbackParameter;
  final Future<bool> Function(ContractFunctionEnum, List)? callback;

  SuccessTransaction({
    required this.contractFunctionEnum,
    required this.index,
    required this.callbackParameter,
    required this.callback,
  });

  @override
  String toString() =>
      'SuccessTransaction { contractFunctionEnum: $contractFunctionEnum, index : $index, callbackParameter: $callbackParameter, callback: $callback}';

  @override
  List<Object?> get props =>
      [contractFunctionEnum, index, callbackParameter, callback];
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
