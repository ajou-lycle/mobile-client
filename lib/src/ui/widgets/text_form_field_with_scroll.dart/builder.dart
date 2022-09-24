import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_bloc.dart';
import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_event.dart';
import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_state.dart';

class BuilderTextFormFieldWithScrollFormBlock extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final double defaultScrollHeight;

  BuilderTextFormFieldWithScrollFormBlock({
    Key? key,
    required this.child,
    required this.scrollController,
    required this.defaultScrollHeight,
  }) : super(key: key);

  @override
  State<BuilderTextFormFieldWithScrollFormBlock> createState() =>
      BuilderTextFormFieldWithScrollFormBlockState();
}

class BuilderTextFormFieldWithScrollFormBlockState
    extends State<BuilderTextFormFieldWithScrollFormBlock> {
  late ScrollFormWithKeyboardBloc _scrollFormWithKeyboardBloc;

  bool isOnAnimation = false;

  void _scroll(double height) {
    isOnAnimation = true;
    widget.scrollController
        .animateTo(height,
            duration: const Duration(milliseconds: 500), curve: Curves.ease)
        .whenComplete(() => isOnAnimation = false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollFormWithKeyboardBloc =
        BlocProvider.of<ScrollFormWithKeyboardBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
        child: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      _scrollFormWithKeyboardBloc.isKeyboardVisible = isKeyboardVisible;

      if (isKeyboardVisible && !isOnAnimation) {
        double scrollHeight = widget.defaultScrollHeight +
            _scrollFormWithKeyboardBloc.errorTextHeight;

        _scrollFormWithKeyboardBloc
            .add(KeyboardVisible(scrollHeight: scrollHeight));
      }

      if (!isKeyboardVisible) {
        if (_scrollFormWithKeyboardBloc.errorTextHeight == 0) {
          _scrollFormWithKeyboardBloc.add(KeyboardUnVisible());
        } else {
          _scrollFormWithKeyboardBloc.add(ErrorTextVisible(
              scrollHeight: _scrollFormWithKeyboardBloc.errorTextHeight));
        }
      }
      return BlocListener<ScrollFormWithKeyboardBloc,
              ScrollFormWithKeyboardState>(
          bloc: _scrollFormWithKeyboardBloc,
          listenWhen: (previous, current) {
            if (isKeyboardVisible && !isOnAnimation) {
              if (previous is ScrollFormWithKeyboardUnVisible &&
                  current is ScrollFormWithKeyboardVisible) {
                _scroll(current.scrollHeight);
              }

              if (previous is ScrollFormWithKeyboardErrorTextExist &&
                  current is ScrollFormWithKeyboardVisible) {
                _scroll(current.scrollHeight);
              }

              if (previous is ScrollFormWithKeyboardUpdated &&
                  current is ScrollFormWithKeyboardVisible) {
                _scroll(current.scrollHeight);
              }
            }

            return true;
          },
          listener: (context, state) {
            if (state is ScrollFormWithKeyboardUnVisible) {
              _scrollFormWithKeyboardBloc.errorTextHeight = 0;
            }
            if (state is ScrollFormWithKeyboardErrorTextExist) {
              _scrollFormWithKeyboardBloc.errorTextHeight = state.scrollHeight;
              return;
            }
          },
          child: widget.child);
    }));
  }
}
