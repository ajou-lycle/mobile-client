import 'package:flutter/material.dart';

import 'package:lycle/src/constants/ui.dart';
import 'package:lycle/src/ui/widgets/row_widget_list_with_divider.dart';

class OptionTextButtons extends StatelessWidget {
  final fontSize = kSmallFontSize;

  List<Widget> optionTextButtons = <Widget>[
    TextButton(
        onPressed: () {},
        child: Text(
          "회원가입",
          style: TextStyle(fontSize: kSmallFontSize),
        )),
    TextButton(
        onPressed: () {},
        child:
            Text("ID 또는 비밀번호 찾기", style: TextStyle(fontSize: kSmallFontSize))),
  ];

  OptionTextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 44, child: RowWidgetListWithDivider(
        widgetList: optionTextButtons,
        verticalDivider: VerticalDivider(
          indent: fontSize * 1.25,
          endIndent: fontSize * 1.25,
          thickness: 2,
          color: Colors.grey,
        )));
  }
}
