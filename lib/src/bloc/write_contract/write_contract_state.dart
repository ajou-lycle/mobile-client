import 'package:equatable/equatable.dart';

abstract class WriteContractState extends Equatable {}

class WriteContractEmpty extends WriteContractState {
  @override
  List<Object?> get props => [];
}

class TransactionSend extends WriteContractState {
  final int index;

  TransactionSend({required this.index});

  @override
  String toString() => 'TransactionSend {index : $index}';

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}

class TransactionSucceed extends WriteContractState {
  final int index;

  TransactionSucceed({required this.index});

  @override
  String toString() => 'TransactionSucceed {index : $index}';

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}

class TransactionFailed extends WriteContractState {
  final int index;

  TransactionFailed({required this.index});

  @override
  String toString() => 'TransactionFailed {index : $index}';

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}

class WriteContractError extends WriteContractState {
  final String error;

  WriteContractError({required this.error});

  @override
  String toString() => 'WriteContractError {error : $error}';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}