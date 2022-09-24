import 'package:flutter/material.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:lycle/src/constants/ui.dart';
import 'package:lycle/src/ui/login/components/form.dart';
import 'package:lycle/src/ui/login/components/option_text_buttons.dart';

class LoginBody extends StatefulWidget {
  LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => LoginBodyState();
}

class LoginBodyState extends State<LoginBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    double textFormFieldHeight = 60;
    double submitButtonHeight = 60;
    double loginFormHeight =
        textFormFieldHeight * 2 + submitButtonHeight + kDefaultPadding * 4;
    double optionTextButtonsHeight = 44;
    double imageSizeWhenKeyboardVisible = size.height * 0.95 -
        (loginFormHeight +
            optionTextButtonsHeight +
            keyboardHeight +
            kDefaultPadding);
    double imageSizeWhenKeyboardUnVisible = size.width * 0.75;

    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.05,
                  left: kDefaultPadding,
                  right: kDefaultPadding),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        height: isKeyboardVisible
                            ? imageSizeWhenKeyboardVisible <
                                    imageSizeWhenKeyboardUnVisible
                                ? imageSizeWhenKeyboardVisible
                                : imageSizeWhenKeyboardUnVisible
                            : imageSizeWhenKeyboardUnVisible,
                        width: isKeyboardVisible
                            ? imageSizeWhenKeyboardVisible <
                                    imageSizeWhenKeyboardUnVisible
                                ? imageSizeWhenKeyboardVisible
                                : imageSizeWhenKeyboardUnVisible
                            : imageSizeWhenKeyboardUnVisible,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/login_banner.jpeg'))),
                      )),
                  const LoginForm(),
                  OptionTextButtons()
                ],
              ))));
    });
  }
}
