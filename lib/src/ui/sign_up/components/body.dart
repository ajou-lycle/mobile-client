import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_bloc.dart';
import '../../../constants/ui.dart';

import '../../widgets/text_form_field_with_scroll/builder.dart';
import '../constant.dart';
import 'form.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({Key? key}) : super(key: key);

  @override
  State<SignUpBody> createState() => SignUpBodyState();
}

class SignUpBodyState extends State<SignUpBody> {
  late ScrollFormWithKeyboardBloc _scrollFormWithKeyboardBloc;
  late ScrollController _scrollController;
  final double scrollHeight = SignUpPageConstant.textFormFieldHeight * 2+
      SignUpPageConstant.textFormFieldErrorTextHeight *
          3 +
      SignUpPageConstant.submitButtonHeight + kDefaultPadding;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollFormWithKeyboardBloc =
        BlocProvider.of<ScrollFormWithKeyboardBloc>(context);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double topPadding = size.height * 0.05;

    return BuilderTextFormFieldWithScrollFormBlock(
        scrollController: _scrollController,
        scrollHeight: scrollHeight,
        child: Container(
            height: size.height,
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.only(
                    top: topPadding,
                    left: kDefaultPadding,
                    right: kDefaultPadding),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SignUpForm(
                          isKeyboardVisible:
                              _scrollFormWithKeyboardBloc.isKeyboardVisible),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 0),
                        height: _scrollFormWithKeyboardBloc.isKeyboardVisible
                            ? scrollHeight
                            : 0,
                      )
                    ],
                  ),
                ))));
  }
}
