import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'scroll_form_with_keyboard_event.dart';
import 'scroll_form_with_keyboard_state.dart';

class ScrollFormWithKeyboardBloc
    extends Bloc<ScrollFormWithKeyboardEvent, ScrollFormWithKeyboardState> {
  final List<BuildContext> pages = List<BuildContext>.empty(growable: true);

  double scrollHeight = 0;
  bool isKeyboardVisible = false;
  bool isOnAnimation = false;

  late StreamSubscription<bool> keyboardSubscription;

  ScrollFormWithKeyboardBloc() : super(ScrollFormWithKeyboardEmpty()) {
    on<KeyboardVisible>(_mapKeyboardVisibleToState);
    on<KeyboardUnVisible>(_mapKeyboardUnVisibleToState);
  }

  ScrollFormWithKeyboardState get initialState => ScrollFormWithKeyboardEmpty();

  void init(
    BuildContext context,
    double scrollHeight,
  ) {
    pages.add(context);
    this.scrollHeight = scrollHeight;
    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible = visible;
    });
  }

  bool? submit(GlobalKey<FormBuilderState> formKey, double errorHeight,
      double scrollHeight) {
    if (formKey.currentState == null) {
      return null;
    }

    FocusScope.of(formKey.currentContext!).unfocus();

    if (formKey.currentState!.validate()) {
      return true;
    } else {
      double height = 0;

      formKey.currentState?.fields.forEach((key, value) {
        if (!value.isValid) {
          height += errorHeight;
        }
      });

      if (state is ScrollFormWithKeyboardVisible) {
        height += scrollHeight;
      }

      return false;
    }
  }

  @override
  Future<void> close() async {
    keyboardSubscription.cancel();
    return super.close();
  }

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
}
