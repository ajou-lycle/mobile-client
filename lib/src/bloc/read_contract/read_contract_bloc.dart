import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/bloc/read_contract/read_contract_event.dart';
import 'package:lycle/src/bloc/read_contract/read_contract_state.dart';

import 'package:lycle/src/repository/web3/web3_repository.dart';

import '../../data/enum/contract_function.dart';

class ReadContractBloc extends Bloc<ReadContractEvent, ReadContractState> {
  final Web3Repository web3repository;

  ReadContractBloc({required this.web3repository})
      : super(ReadContractEmpty()) {
    on<RequestReadContract>(_mapRequestReadContractToState);
  }

  ReadContractState get initialState => ReadContractEmpty();

  Future<void> _mapRequestReadContractToState(
      RequestReadContract event, Emitter<ReadContractState> emit) async {
    try {
      emit(ReadContractLoading());

      final Map? data = await _isReadContractFunction(event);

      if (data != null) {
        emit(ReadContractLoaded(data: data));
      } else {
        emit(ReadContractError(
            error: "no such method error on request read contract"));
      }
    } catch (e) {
      emit(ReadContractError(error: "Request read contract error"));
    }
  }

  Future<Map<dynamic, dynamic>?> _isReadContractFunction(
      RequestReadContract event) async {
    Map<dynamic, dynamic>? result;

    switch (event.contractFunctionEnum) {
      default:
        break;
    }

    return result;
  }
}
