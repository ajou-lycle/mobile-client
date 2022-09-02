import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lycle/src/bloc/web3/web3_event.dart';
import 'package:lycle/src/bloc/web3/web3_state.dart';

import 'package:lycle/src/repository/web3/web3_repository.dart';

class Web3Bloc extends Bloc<Web3Event, Web3State> {
  final Web3Repository web3repository;

  Web3Bloc({required this.web3repository}) : super(Web3Empty()) {
    on<ConnectWeb3>(_mapConnectWeb3ToState);
  }

  Web3State get initialState => Web3Empty();

  Future<void> _mapConnectWeb3ToState(
      ConnectWeb3 event, Emitter<Web3State> emit) async {
    try {
      emit(Web3Loading());
      await web3repository.init();
      emit(Web3Loaded());
    } catch (e) {
      emit(Web3Error(error: ""));
    }
  }
}
