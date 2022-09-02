import 'package:equatable/equatable.dart';

abstract class Web3Event extends Equatable {}

class ConnectWeb3 extends Web3Event {
  ConnectWeb3();

  @override
  String toString() => 'ConnectWeb3';

  @override
  List<Object?> get props => [];
}

class ErrorWeb3 extends Web3Event {
  final String error;

  ErrorWeb3({required this.error});

  @override
  String toString() => 'ErrorWeb3 { error : $error }';

  @override
  List<Object?> get props => [error];
}
