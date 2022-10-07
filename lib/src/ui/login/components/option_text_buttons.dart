import 'package:flutter/material.dart';

import '../../../constants/ui.dart';
import '../../../routes/routes_enum.dart';
import '../../widgets/row_widget_list_with_divider.dart';
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
            Navigator.of(context)
                .pushNamed(PageRoutes.signUpAccountNameAndPassword.routeName);
          },
          child: const Text(
            "회원가입",
            style:
                TextStyle(color: kDisableColor, fontSize: kSmallFontSize + 1),
          )),
      TextButton(
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed(PageRoutes.home.routeName),
          child: const Text("ID 또는 비밀번호 찾기",
              style: TextStyle(
                  color: kDisableColor, fontSize: kSmallFontSize + 1))),
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
