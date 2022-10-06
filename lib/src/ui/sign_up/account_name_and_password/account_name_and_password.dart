import 'package:flutter/material.dart';

import '../../animations/animated_navigator.dart';
import '../../login/login.dart';
import '../../widgets/appbar/base_appbar.dart';
import 'components/body.dart';

class SignUpAccountNameAndPasswordPage extends StatelessWidget {
  const SignUpAccountNameAndPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
          title: "회원가입",
          needBackButton: true,
          backButtonOnPressed: () => Navigator.of(context).pop(
                AnimatedNavigator.defaultNavigator(const LoginPage()),
              )),
      body: const SignUpAccountNameAndPasswordBody(),
    );
  }
}
