import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/bloc/current_quest/current_quest_event.dart';

import 'package:lycle/src/bloc/write_contract/write_contract_event.dart';
import 'package:lycle/src/bloc/write_contract/write_contract_state.dart';
import 'package:lycle/src/data/enum/quest_data_type.dart';
import 'package:lycle/src/repository/web3/web3_repository.dart';

import '../../data/enum/contract_function.dart';
import '../../data/model/quest.dart';

class WriteContractBloc extends Bloc<WriteContractEvent, WriteContractState> {
  final Web3Repository web3Repository;

  WriteContractBloc({required this.web3Repository})
      : super(WriteContractEmpty()) {
    on<SendTransaction>(_mapSendTransactionToState);
    on<SuccessTransaction>(_mapSuccessTransactionToState);
    on<FailTransaction>(_mapFailTransactionToState);
    on<ErrorWriteContract>(_mapErrorWriteContractToState);
  }

  WriteContractState get initialState => WriteContractEmpty();

  Future<void> _mapSendTransactionToState(
      SendTransaction event, Emitter<WriteContractState> emit) async {
    try {
      Map<int, dynamic>? result = await _isWriteContractFunction(event);

      if (result != null) {
        final Stream<Map<String, bool?>> stream =
            (result.values.first as Stream<Map<String, bool?>>);

        stream.listen((data) => data.forEach((key, value) {
              if (value != null) {
                final int index = web3Repository.transactionHashes
                    .indexWhere((element) => element == key);
                web3Repository.transactionHashes
                    .removeWhere((element) => element == key);

                if (value) {
                  // TODO: callback after send transaction is succeed.
                  add(SuccessTransaction(
                    contractFunctionEnum: event.contractFunctionEnum,
                    index: index,
                    callbackParameter: event.successCallbackParameter,
                    callback: event.successCallback,
                  ));
                } else {
                  // TODO: callback after send transaction is failed.
                  add(FailTransaction(index: index));
                }
              }
            }));

        emit((TransactionSend(index: result.keys.first)));
      } else {
        emit(WriteContractError(
            error: "no such method error on send transaction event"));
      }
    } catch (e) {
      emit(WriteContractError(error: "send transaction error"));
    }
  }

  void _mapSuccessTransactionToState(
      SuccessTransaction event, Emitter<WriteContractState> emit) async {
    try {
      if(event.callback != null && event.callbackParameter != null) {
        bool isSucceedCallback = await event.callback!(event.contractFunctionEnum, event.callbackParameter!);

        if(isSucceedCallback) {
          emit(TransactionSucceed(index: event.index));
        } else {
          emit(WriteContractError(error: "SuccessTransactionError"));
        }
      }

      emit(TransactionSucceed(index: event.index));
    } catch (e) {
      emit(WriteContractError(error: "SuccessTransactionError"));
    }
  }

  void _mapFailTransactionToState(
      FailTransaction event, Emitter<WriteContractState> emit) {
    try {
      emit(TransactionFailed(index: event.index));
    } catch (e) {
      emit(WriteContractError(error: "SuccessTransactionError"));
    }
  }

  Future<void> _mapErrorWriteContractToState(
      ErrorWriteContract event, Emitter<WriteContractState> emit) async {
    emit(WriteContractError(error: "wallet error"));
  }

  Future<Map<int, dynamic>?> _isWriteContractFunction(
      SendTransaction event) async {
    Map<int, dynamic>? result;

    switch (event.contractFunctionEnum) {
      case ContractFunctionEnum.mint:
        assert(event.to != null,
            "The parameter ethereumAddress can't be null when call contract function mint.");
        assert(event.amount != null,
            "The parameter amount can't be null when call contract function mint.");
        assert(event.amount! > BigInt.zero,
            "The parameter amount can't be negative when call contract function mint.");

        result = await web3Repository.mint(event.to!, event.amount!);

        break;
      case ContractFunctionEnum.burn:
        assert(event.to != null,
            "The parameter ethereumAddress can't be null when call contract function burn.");
        assert(event.amount != null,
            "The parameter amount can't be null when call contract function burn.");
        assert(event.amount! > BigInt.zero,
            "The parameter amount can't be negative when call contract function burn.");

        result = await web3Repository.burn(event.to!, event.amount!);

        break;
      default:
        break;
    }

    return result;
  }
}
