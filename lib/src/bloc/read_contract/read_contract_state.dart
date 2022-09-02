import 'package:equatable/equatable.dart';

abstract class ReadContractState extends Equatable {}

class ReadContractEmpty extends ReadContractState {
  @override
  List<Object?> get props => [];
}

class ReadContractLoading extends ReadContractState {
  @override
  String toString() => 'ReadContractLoading';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReadContractLoaded extends ReadContractState {
  final Map data;

  ReadContractLoaded({required this.data});

  @override
  String toString() => 'ReadContractLoaded { data : $data }';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReadContractError extends ReadContractState {
  final String error;

  ReadContractError({required this.error});

  @override
  String toString() => 'ReadContractError { error : $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
