import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../../bloc/valid_form/valid_form_bloc.dart';
import '../../../constants/ui.dart';
import '../../animations/animated_navigator.dart';
import '../../home/home.dart';
import '../../sign_up/account_name_and_password/account_name_and_password.dart';
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
            Navigator.of(context).push(AnimatedNavigator.defaultNavigator(
                MultiBlocProvider(providers: [
              BlocProvider(create: (context) => ValidFormBloc()),
              BlocProvider(create: (context) => SnackBarBloc())
            ], child: const SignUpAccountNameAndPasswordPage())));
          },
          child: const Text(
            "회원가입",
            style:
                TextStyle(color: kDisableColor, fontSize: kSmallFontSize + 1),
          )),
      TextButton(
          onPressed: () => Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomePage())),
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
