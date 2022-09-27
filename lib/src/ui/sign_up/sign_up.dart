import 'package:flutter/material.dart';
import 'package:lycle/src/ui/animations/animated_navigator.dart';
import 'package:lycle/src/ui/login/login.dart';
import '../widgets/appbar/base_appbar.dart';

import 'components/body.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
          title: "회원가입",
          needBackButton: true,
          backButtonOnPressed: () => Navigator.of(context).pop(
                AnimatedNavigator.defaultNavigator(const LoginPage()),
              )),
      body: SignUpBody(),
    );
  }
}
