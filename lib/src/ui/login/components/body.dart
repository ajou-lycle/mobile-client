import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/constants/assets.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_bloc.dart';

import '../../../constants/ui.dart';

import '../../widgets/text_form_field_with_scroll/builder.dart';
import '../constant.dart';
import 'form.dart';
import 'option_text_buttons.dart';

class LoginBody extends StatefulWidget {
  LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => LoginBodyState();
}

class LoginBodyState extends State<LoginBody> {
  late ScrollFormWithKeyboardBloc _scrollFormWithKeyboardBloc;
  late ScrollController _scrollController;
  final double scrollHeight = LoginPageConstant.textFormFieldHeight +
      LoginPageConstant.optionTextButtonsHeight +
      LoginPageConstant.textFormFieldErrorTextHeight * 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollFormWithKeyboardBloc =
        BlocProvider.of<ScrollFormWithKeyboardBloc>(context);
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    LoginPageConstant.bannerImageSize = size.height * 0.425 -
        (LoginPageConstant.textFormFieldHeight + kDefaultPadding * 2);
    double topPadding = size.height * 0.075;

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
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding * 2),
                          child: Image.asset(
                            loginBannerPng,
                            height: LoginPageConstant.bannerImageSize,
                            width: LoginPageConstant.bannerImageSize,
                          )),
                      LoginForm(
                          isKeyboardVisible:
                              _scrollFormWithKeyboardBloc.isKeyboardVisible),
                      const SizedBox(height: kDefaultPadding,),
                      const OptionTextButtons(),
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
