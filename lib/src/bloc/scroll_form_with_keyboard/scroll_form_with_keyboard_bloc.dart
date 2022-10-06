import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'scroll_form_with_keyboard_event.dart';
import 'scroll_form_with_keyboard_state.dart';

class ScrollFormWithKeyboardBloc
    extends Bloc<ScrollFormWithKeyboardEvent, ScrollFormWithKeyboardState> {
  final List<Map<String, dynamic>> pageInfoList = List<Map<String, dynamic>>.empty(growable: true);

  double scrollHeight = 0;
  bool isKeyboardVisible = false;
  bool isOnAnimation = false;

  late StreamSubscription<bool> keyboardSubscription;

  ScrollFormWithKeyboardBloc() : super(ScrollFormWithKeyboardEmpty()) {
    on<KeyboardVisible>(_mapKeyboardVisibleToState);
    on<KeyboardUnVisible>(_mapKeyboardUnVisibleToState);
  }

  ScrollFormWithKeyboardState get initialState => ScrollFormWithKeyboardEmpty();

  void init(BuildContext context, double scrollHeight) {
    Map<String, dynamic> data = {
      'context': context,
      'scrollHeight': scrollHeight
    };
    pageInfoList.add(data);

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible = visible;
    });
  }

  @override
  Future<void> close() async {
    keyboardSubscription.cancel();
    return super.close();
  }

  Future<void> _mapKeyboardVisibleToState(
      KeyboardVisible event, Emitter<ScrollFormWithKeyboardState> emit) async {
    try {
      if (state is ScrollFormWithKeyboardVisible) {
        emit(ScrollFormWithKeyboardUpdated());
      }

      emit(ScrollFormWithKeyboardVisible());
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
}
