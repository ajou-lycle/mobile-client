import 'package:equatable/equatable.dart';

abstract class Web3State extends Equatable {}

class Web3Empty extends Web3State {
  @override
  List<Object?> get props => [];
}

class Web3Loading extends Web3State {
  @override
  String toString() => 'Web3Loading';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Web3Loaded extends Web3State {
  Web3Loaded();

  @override
  String toString() => 'Web3Loaded';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Web3Error extends Web3State {
  final String error;

  Web3Error({required this.error});

  @override
  String toString() => 'Web3Error { error : $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}