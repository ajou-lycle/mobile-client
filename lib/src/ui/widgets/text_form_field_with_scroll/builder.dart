import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_bloc.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_state.dart';

class BuilderTextFormFieldWithScrollFormBlock extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final double scrollHeight;

  const BuilderTextFormFieldWithScrollFormBlock(
      {Key? key,
      required this.child,
      required this.scrollController,
      required this.scrollHeight})
      : super(key: key);

  @override
  State<BuilderTextFormFieldWithScrollFormBlock> createState() =>
      BuilderTextFormFieldWithScrollFormBlockState();
}

class BuilderTextFormFieldWithScrollFormBlockState
    extends State<BuilderTextFormFieldWithScrollFormBlock> {
  late ScrollFormWithKeyboardBloc _scrollFormWithKeyboardBloc;
  bool isInit = false;

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
  }

  @override
  void didChangeDependencies() {
    if(!isInit) {
      isInit = true;
      _scrollFormWithKeyboardBloc.init(context, widget.scrollHeight);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollFormWithKeyboardBloc.pageInfoList.removeLast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
        child: BlocListener<ScrollFormWithKeyboardBloc,
                ScrollFormWithKeyboardState>(
            listener: (blocContext, state) {
              bool isCurrentPage = context ==
                      _scrollFormWithKeyboardBloc.pageInfoList.last['context']
                  ? true
                  : false;

              if (!isCurrentPage) {
                return;
              }

              int index = _scrollFormWithKeyboardBloc.pageInfoList
                  .indexWhere((element) => element['context'] == context);
              double scrollHeight = _scrollFormWithKeyboardBloc
                  .pageInfoList[index]['scrollHeight'];

              if (state is ScrollFormWithKeyboardVisible &&
                  !_scrollFormWithKeyboardBloc.isOnAnimation) {
                _scroll(scrollHeight);
              }
            },
            child: widget.child));
  }
}
