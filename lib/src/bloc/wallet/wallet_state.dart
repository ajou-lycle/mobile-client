import 'package:equatable/equatable.dart';
import 'package:lycle/src/data/model/wallet.dart';

import 'package:walletconnect_dart/walletconnect_dart.dart';

abstract class WalletState extends Equatable {}

class WalletEmpty extends WalletState {
  @override
  List<Object?> get props => [];
}

class WalletLoading extends WalletState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WalletError extends WalletState {
  final String? error;

  WalletError({this.error});

  @override
  String toString() => 'ErrorState { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class WalletConnected extends WalletState {
  final UserWallet wallet;

  WalletConnected({required this.wallet});

  @override
  String toString() => 'ConnectedState';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WalletUpdated extends WalletState {
  final SessionStatus session;

  WalletUpdated({required this.session});

  @override
  String toString() => 'UpdatedState {address: ${session.accounts[0]} }';

  @override
  // TODO: implement props
  List<Object?> get props => [session];
}

class WalletDisconnected extends WalletState {
  @override
  String toString() => 'DisconnectedState';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
