import 'package:equatable/equatable.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/credentials.dart';

abstract class WalletEvent extends Equatable {}

class EmptyWallet extends WalletEvent {
  @override
  String toString() => 'EmptyWallet';

  @override
  List<Object?> get props => [];
}
class ConnectWallet extends WalletEvent {
  final EthereumAddress? walletAddress;

  ConnectWallet({required this.walletAddress});

  @override
  String toString() => 'ConnectWallet';

  @override
  List<Object?> get props => [];
}

class UpdateWallet extends WalletEvent {
  UpdateWallet();

  @override
  String toString() => 'UpdateWallet';

  @override
  List<Object?> get props => [];
}

class UpdateSessionWallet extends WalletEvent {
  final SessionStatus session;

  UpdateSessionWallet({required this.session});

  @override
  String toString() =>
      'UpdateSessionWallet { address : ${session.accounts[0]} }';

  @override
  List<Object?> get props => [];
}

class DisconnectWallet extends WalletEvent {
  @override
  String toString() => 'DisconnectWallet';

  @override
  List<Object?> get props => [];
}

class ErrorWallet extends WalletEvent {
  final String? error;

  ErrorWallet({this.error});

  @override
  String toString() => 'ErrorWallet { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
