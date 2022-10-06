import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api/certification/valid_api.dart';
import '../../data/repository/certification/valid_repository.dart';
import 'valid_form_event.dart';
import 'valid_form_state.dart';

class ValidFormBloc extends Bloc<ValidFormEvent, ValidFormState> {
  final ValidRepository validRepository = ValidRepository(validApi: ValidApi());

  ValidFormBloc() : super(ValidFormEmpty()) {
    on<FormInputValidate>(_mapFormInputValidateToState);
    on<FormInputUnValidate>(_mapFormInputUnValidateToState);
  }

  ValidFormState get initialState => ValidFormEmpty();

  void subscribeValidation({required int numOfValidation}) {
    for (int index = 0; index < numOfValidation; index++) {
      validRepository.valid.isPassList.add(false);
    }
  }

  void unSubscribeValidation({int? numOfValidation}) {
    if (validRepository.valid.isPassList.isEmpty) {
      return;
    }

    if (numOfValidation == null) {
      validRepository.valid.isPassList.clear();
    } else {
      for (int index = 0; index < numOfValidation; index++) {
        validRepository.valid.isPassList.removeLast();
      }
    }
  }

  void mapInputToEvent(bool isValid, int index) {
    if (isValid) {
      add(FormInputValidate(index: index));
    } else {
      add(FormInputUnValidate(index: index));
    }
  }

  Future<void> _mapFormInputValidateToState(
      FormInputValidate event, Emitter<ValidFormState> emit) async {
    try {
      emit(ValidFormUpdated());

      validRepository.valid.isPassList[event.index] = true;

      if (validRepository.valid.validate()) {
        emit(ValidFormPass());
      } else {
        emit(ValidFormUnPass());
      }
    } catch (e) {
      ValidFormError(error: "form input validate error");
    }
  }

  Future<void> _mapFormInputUnValidateToState(
      FormInputUnValidate event, Emitter<ValidFormState> emit) async {
    try {
      emit(ValidFormUpdated());

      validRepository.valid.isPassList[event.index] = false;

      emit(ValidFormUnPass());
    } catch (e) {
      ValidFormError(error: "form input un-validate error");
    }
  }
}
