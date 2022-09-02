import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lycle/src/bloc/wallet/wallet_event.dart';
import 'package:lycle/src/bloc/wallet/wallet_state.dart';
import 'package:lycle/src/repository/web3/web3_api_client.dart';

import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/credentials.dart';

import '../../repository/web3/web3_repository.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final Web3Repository web3Repository =
      Web3Repository(web3apiClient: Web3ApiClient());

  WalletBloc() : super(WalletEmpty()) {
    subscribeConnectorEvent();
    on<ConnectWallet>(_mapConnectWalletToState);
    on<UpdateWallet>(_mapUpdateWalletToState);
    on<DisconnectWallet>(_mapDisconnectedWalletToState);
    on<ErrorWallet>(_mapErrorWalletToState);
  }

  WalletState get initialState => WalletEmpty();

  Future<void> _mapConnectWalletToState(
      ConnectWallet event, Emitter<WalletState> emit) async {
    try {
      emit(WalletLoading());

      if (web3Repository.wallet.address == null) {
        await web3Repository.init();
      } else {
        web3Repository.wallet.address = event.walletAddress;
      }

      emit(WalletConnected(wallet: web3Repository.wallet));
    } catch (e) {
      emit(WalletError(error: "connect error"));
    }
  }

  Future<void> _mapUpdateWalletToState(
      UpdateWallet event, Emitter<WalletState> emit) async {
    try {
      emit(WalletLoading());

      await web3Repository.connector.updateSession(event.session);
      web3Repository.wallet = await web3Repository.getUserWallet(
          EthereumAddress.fromHex(
              web3Repository.connector.session.accounts[0]));

      emit(WalletConnected(wallet: web3Repository.wallet));
    } catch (e) {
      emit(WalletError(error: "update error"));
    }
  }

  void _mapDisconnectedWalletToState(
      DisconnectWallet event, Emitter<WalletState> emit) {
    try {
      emit(WalletDisconnected());
    } catch (e) {
      emit(WalletError(error: "disconnected error"));
    }
  }

  Future<void> _mapErrorWalletToState(
      ErrorWallet event, Emitter<WalletState> emit) async {
    emit(WalletError(error: "wallet error"));
  }

  void subscribeConnectorEvent() {
    web3Repository.connector.on('connect', (session) {
      debugPrint("connect");
      if (session.runtimeType == SessionStatus) {
        add(ConnectWallet(
            walletAddress: EthereumAddress.fromHex(
                web3Repository.connector.session.accounts[0])));
      }
    });
    web3Repository.connector.on('session_update', (session) {
      debugPrint("session_update");
      if (session.runtimeType == SessionStatus) {
        add(UpdateWallet(session: session as SessionStatus));
      }
    });
    web3Repository.connector.on('disconnect', (session) {
      debugPrint('disconnect');

      Map<String, dynamic> data = session as Map<String, dynamic>;

      bool isSessionDisconnected = data['message'] != null &&
              (data['message'] as String).contains('disconnect')
          ? true
          : false;

      if (isSessionDisconnected) {
        add(DisconnectWallet());
      }
    });
  }
}
