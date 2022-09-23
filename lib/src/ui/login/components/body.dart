import 'package:flutter/material.dart';
import 'package:lycle/src/constants/ui.dart';
import 'package:lycle/src/ui/login/components/form.dart';
import 'package:lycle/src/ui/login/components/option_text_buttons.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.05,
                left: kDefaultPadding,
                right: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.asset(
                      'assets/images/login_banner.jpeg',
                      height: size.width * 0.75,
                      width: size.width * 0.75,
                    )),
                LoginForm(),
                OptionTextButtons()
              ],
            )));
  }
}
