import 'package:equatable/equatable.dart';
import 'package:web3dart/credentials.dart';

import '../../data/enum/contract_function.dart';

abstract class ReadContractEvent extends Equatable {}

class RequestReadContract extends ReadContractEvent {
  final ContractFunctionEnum contractFunctionEnum;
  final EthereumAddress? address;

  RequestReadContract({required this.contractFunctionEnum, this.address});

  @override
  String toString() => 'RequestReadContract { address : $address }';

  @override
  List<Object?> get props => [address];
}

class ErrorReadContract extends ReadContractEvent {
  final String error;

  ErrorReadContract({required this.error});

  @override
  String toString() => 'ErrorReadContract { error : $error }';

  @override
  List<Object?> get props => [error];
}
