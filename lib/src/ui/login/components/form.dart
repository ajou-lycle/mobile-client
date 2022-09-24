import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../constants/ui.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    // TODO: TextFormField가 키보드에 덮히는 것 방지
    return Material(
        color: Colors.transparent,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilderTextField(
                name: 'id',
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                  hintText: '아이디를 입력해주세요',
                ),
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              FormBuilderTextField(
                name: 'password',
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                  hintText: '비밀번호를 입력해주세요',
                ),
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () async {
                      if (_formKey.currentState == null) {
                        return;
                      }
                    },
                  )),
              const SizedBox(
                height: kDefaultPadding,
              ),
            ],
          ),
        ));
  }
}
