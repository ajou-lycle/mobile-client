import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_bloc.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_state.dart';

class BuilderTextFormFieldWithScrollFormBlock extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final double scrollHeight;

  const BuilderTextFormFieldWithScrollFormBlock({
    Key? key,
    required this.child,
    required this.scrollController,
    required this.scrollHeight,
  }) : super(key: key);

  @override
  State<BuilderTextFormFieldWithScrollFormBlock> createState() =>
      BuilderTextFormFieldWithScrollFormBlockState();
}

class BuilderTextFormFieldWithScrollFormBlockState
    extends State<BuilderTextFormFieldWithScrollFormBlock> {
  late ScrollFormWithKeyboardBloc _scrollFormWithKeyboardBloc;

  void _scroll(double height) {
    _scrollFormWithKeyboardBloc.isOnAnimation = true;
    widget.scrollController
        .animateTo(height,
            duration: const Duration(milliseconds: 500), curve: Curves.ease)
        .whenComplete(() => _scrollFormWithKeyboardBloc.isOnAnimation = false);
  }

  @override
  void initState() {
    super.initState();
    _scrollFormWithKeyboardBloc =
        BlocProvider.of<ScrollFormWithKeyboardBloc>(context);
    _scrollFormWithKeyboardBloc.init(context, widget.scrollHeight);
  }

  @override
  void dispose() {
    _scrollFormWithKeyboardBloc.pages.removeLast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
        child: BlocListener<ScrollFormWithKeyboardBloc,
                ScrollFormWithKeyboardState>(
            listener: (blocContext, state) {
              bool isCurrentPage =
                  context == _scrollFormWithKeyboardBloc.pages.last
                      ? true
                      : false;

              if (!isCurrentPage) {
                return;
              }

              if (state is ScrollFormWithKeyboardVisible &&
                  !_scrollFormWithKeyboardBloc.isOnAnimation) {
                _scroll(state.scrollHeight);
              }
            },
            child: widget.child));
  }
}
