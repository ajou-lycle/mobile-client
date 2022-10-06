import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../animations/animated_navigator.dart';
import '../../login/login.dart';
import '../../widgets/appbar/base_appbar.dart';
import 'components/body.dart';

class SignUpInfoPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;

  const SignUpInfoPage({Key? key, required this.formKey}) : super(key: key);

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
      body: SignUpInfoBody(
        formKey: formKey,
      ),
    );
  }
}
