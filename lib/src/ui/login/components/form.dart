import 'package:flutter/material.dart';

import '../../../constants/ui.dart';
import '../../widgets/rounded_text_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: TextFormField가 키보드에 덮히는 것 방지
    return Material(
        color: Colors.transparent,
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RoundedTextFormField(
                  verticalPadding: kDefaultPadding,
                  validator: (value) {
                    if (value == null) {
                      return "문제가 발생했습니다.";
                    }

                    if (value.isEmpty) {
                      return "아이디를 입력해주세요.";
                    }
                  },
                  borderRadius: kDefaultRadius,
                  fillColor: Colors.grey[100],
                  hintText: '아이디를 입력해주세요.',
                ),
                RoundedTextFormField(
                  verticalPadding: kDefaultPadding,
                  validator: (value) {
                    if (value == null) {
                      return "문제가 발생했습니다.";
                    }

                    if (value.isEmpty) {
                      return "비밀번호를 입력해주세요.";
                    }
                  },
                  borderRadius: kDefaultRadius,
                  fillColor: Colors.grey[100],
                  hintText: '비밀번호를 입력해주세요.',
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                  child: OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState != null) {
                        if (_formKey.currentState!.validate()) {
                          // TODO: login api 연동
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                        }
                      }
                    },
                    child: Text('로그인'),
                  ),
                )
              ],
            )));
  }
}
