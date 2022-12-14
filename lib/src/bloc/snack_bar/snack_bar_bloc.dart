import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/ui.dart';
import 'snack_bar_event.dart';
import 'snack_bar_state.dart';

class SnackBarBloc extends Bloc<SnackBarEvent, SnackBarState> {
  SnackBarBloc() : super(SnackBarEmpty()) {
    on<ShowSnackBar>(_mapShowSnackBarToState);
    on<HideSnackBar>(_mapHideSnackBarToState);
  }

  SnackBarState get initialState => SnackBarEmpty();

  void showLoadingSnackBar(String text, {void Function()? closedCallback}) {
    add(ShowSnackBar(children: <Widget>[
      const CircularProgressIndicator(),
      const SizedBox(
        width: kDefaultPadding,
      ),
      Text(text)
    ], closedCallback: closedCallback));
  }

  void showSuccessSnackBar(String text, {void Function()? closedCallback}) {
    add(ShowSnackBar(children: <Widget>[
      const Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
      ),
      const SizedBox(
        width: kDefaultPadding,
      ),
      Text(text)
    ], closedCallback: closedCallback));
  }

  void showErrorSnackBar(String text, {void Function()? closedCallback}) {
    add(ShowSnackBar(children: <Widget>[
      const Icon(
        Icons.close_rounded,
        color: Colors.red,
      ),
      const SizedBox(
        width: kDefaultPadding,
      ),
      Text(text)
    ], closedCallback: closedCallback));
  }

  Future<void> _mapShowSnackBarToState(
      ShowSnackBar event, Emitter<SnackBarState> emit) async {
    try {
      emit(SnackBarUpdated(children: event.children));
      emit(SnackBarShow(
          children: event.children, closedCallback: event.closedCallback));
    } catch (e) {
      emit(SnackBarError(error: "show snack bar error"));
    }
  }

  Future<void> _mapHideSnackBarToState(
      HideSnackBar event, Emitter<SnackBarState> emit) async {
    try {
      emit(SnackBarEmpty());
    } catch (e) {
      emit(SnackBarError(error: "show snack bar error"));
    }
  }
}
