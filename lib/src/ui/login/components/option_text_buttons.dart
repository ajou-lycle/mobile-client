import 'package:flutter/material.dart';

import 'package:lycle/src/constants/ui.dart';
import 'package:lycle/src/ui/home/home.dart';
import 'package:lycle/src/ui/sign_up/sign_up.dart';
import 'package:lycle/src/ui/widgets/row_widget_list_with_divider.dart';

import '../../animations/animated_navigator.dart';
import '../constant.dart';

class OptionTextButtons extends StatelessWidget {
  final fontSize = kSmallFontSize;

  const OptionTextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> optionTextButtons = <Widget>[
      TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).push(AnimatedNavigator.defaultNavigator(
              const SignUpPage(),
            ));
          },
          child: const Text(
            "회원가입",
            style: TextStyle(fontSize: kSmallFontSize),
          )),
      TextButton(
          onPressed: () => Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomePage())),
          child: const Text("ID 또는 비밀번호 찾기",
              style: TextStyle(fontSize: kSmallFontSize))),
    ];

    return SizedBox(
        height: LoginPageConstant.optionTextButtonsHeight,
        child: RowWidgetListWithDivider(
            widgetList: optionTextButtons,
            verticalDivider: VerticalDivider(
              indent: fontSize * 1.25,
              endIndent: fontSize * 1.25,
              thickness: 2,
              color: Colors.grey,
            )));
  }
}
