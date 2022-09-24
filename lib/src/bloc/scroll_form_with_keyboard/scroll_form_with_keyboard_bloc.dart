import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'scroll_form_with_keyboard_event.dart';
import 'scroll_form_with_keyboard_state.dart';

class ScrollFormWithKeyboardBloc
    extends Bloc<ScrollFormWithKeyboardEvent, ScrollFormWithKeyboardState> {
  bool isKeyboardVisible = false;
  double errorTextHeight = 0;

  ScrollFormWithKeyboardBloc() : super(ScrollFormWithKeyboardEmpty()) {
    on<KeyboardVisible>(_mapKeyboardVisibleToState);
    on<KeyboardUnVisible>(_mapKeyboardUnVisibleToState);
    on<ErrorTextVisible>(_mapErrorTextVisibleToState);
  }

  ScrollFormWithKeyboardState get initialState => ScrollFormWithKeyboardEmpty();

  Future<void> _mapKeyboardVisibleToState(
      KeyboardVisible event, Emitter<ScrollFormWithKeyboardState> emit) async {
    try {
      double scrollHeight = event.scrollHeight;

      if (state is ScrollFormWithKeyboardVisible) {
        emit(ScrollFormWithKeyboardUpdated(scrollHeight: scrollHeight));
      }

      emit(ScrollFormWithKeyboardVisible(scrollHeight: scrollHeight));
    } catch (e) {
      emit(ScrollFormWithKeyboardError(error: "visible error"));
    }
  }

  Future<void> _mapKeyboardUnVisibleToState(KeyboardUnVisible event,
      Emitter<ScrollFormWithKeyboardState> emit) async {
    try {
      emit(ScrollFormWithKeyboardUnVisible());
    } catch (e) {
      emit(ScrollFormWithKeyboardError(error: "unVisible error"));
    }
  }

  Future<void> _mapErrorTextVisibleToState(
      ErrorTextVisible event, Emitter<ScrollFormWithKeyboardState> emit) async {
    try {
      double scrollHeight = event.scrollHeight;

      if (state is ScrollFormWithKeyboardUpdated ||
          state is ScrollFormWithKeyboardVisible) {
        emit(ScrollFormWithKeyboardUpdated(scrollHeight: scrollHeight));
        emit(ScrollFormWithKeyboardVisible(scrollHeight: scrollHeight));

        return;
      }
      if (state is ScrollFormWithKeyboardErrorTextExist) {
        emit(ScrollFormWithKeyboardUpdated(scrollHeight: scrollHeight));
      }

      emit(ScrollFormWithKeyboardErrorTextExist(scrollHeight: scrollHeight));
    } catch (e) {
      emit(ScrollFormWithKeyboardError(error: "errorText visible error"));
    }
  }
}
