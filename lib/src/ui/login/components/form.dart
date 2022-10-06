import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lycle/src/data/enum/http_status.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_bloc.dart';

import '../../../constants/ui.dart';
import '../../../data/api/certification/auth_api.dart';
import '../../../data/api/certification/valid_api.dart';
import '../../../data/repository/user_repository.dart';
import '../../widgets/text_form_field_with_scroll/rounded_text_form_field_with_scroll_form_block.dart';
import '../constant.dart';

class LoginForm extends StatefulWidget {
  final bool isKeyboardVisible;

  const LoginForm({Key? key, required this.isKeyboardVisible})
      : super(key: key);

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  late ScrollFormWithKeyboardBloc _scrollFormWithKeyboardBloc;

  final _formKey = GlobalKey<FormBuilderState>();

  final String _accountNameField = 'accountName';
  final String _passwordField = 'password';
  final List<Map<String, String>> _fields =
      List<Map<String, String>>.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollFormWithKeyboardBloc =
        BlocProvider.of<ScrollFormWithKeyboardBloc>(context);
    _fields.addAll([
      {
        "name": _accountNameField,
        "errorText": '아이디를 입력해주세요',
        "hintText": '아이디를 입력해주세요'
      },
      {
        "name": _passwordField,
        "errorText": '비밀번호를 입력해주세요',
        "hintText": '비밀번호를 입력해주세요'
      }
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: FormBuilder(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            ..._fields.map((field) {
              return Column(children: [
                RoundedTextFormFieldWithScrollFormBlock(
                  name: field['name']!,
                  borderRadius: kDefaultRadius,
                  formKey: _formKey,
                  validator: FormBuilderValidators.required(
                      errorText: field['errorText']),
                  errorTextFontSize:
                      LoginPageConstant.textFormFieldErrorTextHeight,
                  fillColor: Colors.grey[100],
                  hintText: field['hintText'],
                ),
                const SizedBox(
                  height: kDefaultPadding + kHalfPadding,
                ),
              ]);
            }).toList(),
            SizedBox(
                height: LoginPageConstant.submitButtonHeight,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kDefaultRadius))),
                      backgroundColor: _formKey.currentState == null
                          ? MaterialStateProperty.all(Colors.grey)
                          : _formKey.currentState!.isValid
                              ? MaterialStateProperty.all(Colors.green)
                              : MaterialStateProperty.all(Colors.grey),
                      elevation:
                          MaterialStateProperty.all<double>(kDefaultPadding)),
                  onPressed: () async {
                    bool? isValid = _formKey.currentState?.validate();

                    if (isValid == null || !isValid) {
                      return;
                    }
                    UserRepository userRepository = UserRepository(
                        authApi: AuthApi(), validApi: ValidApi());

                    final response = await userRepository.login(
                      accountName: _formKey
                          .currentState?.fields[_accountNameField]?.value,
                      password:
                          _formKey.currentState?.fields[_passwordField]?.value,
                    );
                  },
                  child: const Text('로그인'),
                )),
          ]),
        ));
  }
}
