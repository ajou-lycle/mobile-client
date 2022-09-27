import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lycle/src/data/api/user/auth_api.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_bloc.dart';

import '../../../constants/ui.dart';
import '../../../data/repository/user_repository.dart';
import '../../login/constant.dart';
import '../../widgets/text_form_field_with_scroll/rounded_text_form_field_with_scroll_form_block.dart';
import '../../widgets/text_form_field_with_scroll/rounded_valid_text_form_field_with_scroll_form.dart';

class SignUpForm extends StatefulWidget {
  final bool isKeyboardVisible;

  const SignUpForm({Key? key, required this.isKeyboardVisible})
      : super(key: key);

  @override
  State<SignUpForm> createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  late ScrollFormWithKeyboardBloc _scrollFormWithKeyboardBloc;

  final _formKey = GlobalKey<FormBuilderState>();

  final String _accountNameField = 'accountName';
  final String _passwordField = 'password';
  final String _nicknameField = 'nickname';
  final String _emailField = 'email';
  final String _walletAddressField = 'walletAddress';

  final List<Map<String, dynamic>> _fields =
      List<Map<String, dynamic>>.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollFormWithKeyboardBloc =
        BlocProvider.of<ScrollFormWithKeyboardBloc>(context);

    List<String> titles = <String>[
      "아이디 *",
      "비밀번호 *",
      "닉네임 *",
      "이메일 *",
      "지갑주소 *",
    ];
    List<String> names = <String>[
      _accountNameField,
      _passwordField,
      _nicknameField,
      _emailField,
      _walletAddressField
    ];
    List<String> errorTexts = <String>[
      '아이디 입력은 필수입니다.',
      '비밀번호 입력은 필수입니다.',
      '닉네임 입력은 필수입니다.',
      '이메일 입력은 필수입니다.',
      '지갑주소 입력은 필수입니다.'
    ];
    List<String> hintTexts = <String>[
      '아이디를 입력해주세요',
      '비밀번호를 입력해주세요',
      '닉네임을 입력해주세요',
      '이메일을 입력해주세요',
      '지갑 주소를 입력해주세요'
    ];
    List<bool> needValidList = <bool>[true, false, true, true, true];
    List<String> validButtonTitles = <String>[
      '중복확인',
      '',
      '중복확인',
      '중복확인',
      '중복확인'
    ];
    for (int index = 0; index < names.length; index++) {
      _fields.add({
        "title": titles[index],
        "name": names[index],
        "errorText": errorTexts[index],
        "hintText": hintTexts[index],
        "needValid": needValidList[index],
        "validButtonTitle": validButtonTitles[index]
      });
    }
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
                field['needValid']
                    ? RoundedValidTextFormFieldWithScrollFormBlock(
                        title: field['title'],
                        name: field['name']!,
                        borderRadius: kDefaultRadius,
                        formKey: _formKey,
                        validator: FormBuilderValidators.required(
                            errorText: field['errorText']),
                        errorTextFontSize:
                            LoginPageConstant.textFormFieldErrorTextHeight,
                        fillColor: Colors.grey[100],
                        hintText: field['hintText'],
                        buttonTitle: field['validButtonTitle'],
                        buttonStyle: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(kDefaultRadius)),
                            ),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: kDefaultPadding * 1.4,
                                    horizontal: kDefaultPadding * 1.5)),
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                            foregroundColor:
                                MaterialStateProperty.all(kPrimaryTextColor)),
                      )
                    : RoundedTextFormFieldWithScrollFormBlock(
                        title: field['title'],
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
                  height: kDefaultPadding,
                ),
              ]);
            }).toList(),
            SizedBox(
                height: LoginPageConstant.submitButtonHeight,
                child: ElevatedButton(
                  child: const Text('회원가입'),
                  style: ButtonStyle(
                      backgroundColor: _formKey.currentState == null
                          ? MaterialStateProperty.all(Colors.grey)
                          : _formKey.currentState!.isValid
                              ? MaterialStateProperty.all(Colors.green)
                              : MaterialStateProperty.all(Colors.grey)),
                  onPressed: () async {
                    double scrollHeight =
                        LoginPageConstant.textFormFieldHeight +
                            LoginPageConstant.optionTextButtonsHeight;

                    bool? result = _scrollFormWithKeyboardBloc.submit(
                        _formKey,
                        LoginPageConstant.textFormFieldErrorTextHeight,
                        scrollHeight);

                    if (result == null) {
                      return;
                    }

                    if (result) {
                      UserRepository userRepository =
                          UserRepository(authApi: AuthApi());

                      final response = await userRepository.login(
                        accountName: _formKey
                            .currentState?.fields[_accountNameField]?.value,
                        password: _formKey
                            .currentState?.fields[_passwordField]?.value,
                      );
                    }
                  },
                )),
            const SizedBox(
              height: kDefaultPadding,
            ),
          ]),
        ));
  }
}
