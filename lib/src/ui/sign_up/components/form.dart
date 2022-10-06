import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../constants/ui.dart';

import '../../../data/api/certification/auth_api.dart';
import '../../../data/api/certification/valid_api.dart';
import '../../../data/repository/user_repository.dart';
import '../../widgets/text_form_field_with_scroll/rounded_text_form_field_with_scroll_form_block.dart';
import '../../widgets/text_form_field_with_scroll/rounded_valid_text_form_field_with_scroll_form.dart';

import '../constant.dart';
import '../enum.dart';

class SignUpForm extends StatefulWidget {
  final bool isKeyboardVisible;

  const SignUpForm({Key? key, required this.isKeyboardVisible})
      : super(key: key);

  @override
  State<SignUpForm> createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  List signUpFormInfoList = SignUpFormInfo.generateInfo();

  final _formKey = GlobalKey<FormBuilderState>();


  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: FormBuilder(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            ...signUpFormInfoList.map((field) {
              return Column(children: [
                field['needValid']
                    ? RoundedValidTextFormFieldWithScrollFormBlock(
                        formKey: _formKey,
                        title: field['title'],
                        name: field['name']!,
                        validator: field['validator'],
                        onChanged: (value) {
                          setState(() {
                            field['isPassValidation'] = _formKey
                                .currentState?.fields[field['name']]
                                ?.validate();
                          });
                          return value;
                        },
                        borderRadius: kDefaultRadius,
                        errorTextFontSize:
                            SignUpPageConstant.textFormFieldErrorTextHeight,
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
                            backgroundColor: field['isPassValidation']
                                ? MaterialStateProperty.all(kPrimaryColor)
                                : MaterialStateProperty.all(kDisableColor),
                            foregroundColor:
                                MaterialStateProperty.all(kPrimaryTextColor)),
                      )
                    : RoundedTextFormFieldWithScrollFormBlock(
                        title: field['title'],
                        name: field['name']!,
                        validator: field['validator'],
                        onChanged: (value) {
                          setState(() {
                            field['isPassValidation'] = _formKey
                                .currentState?.fields[field['name']]
                                ?.validate();
                          });
                          return value;
                        },
                        borderRadius: kDefaultRadius,
                        formKey: _formKey,
                        errorTextFontSize:
                            SignUpPageConstant.textFormFieldErrorTextHeight,
                        fillColor: Colors.grey[100],
                        hintText: field['hintText'],
                      ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
              ]);
            }).toList(),
            SizedBox(
                height: SignUpPageConstant.submitButtonHeight,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: _formKey.currentState == null
                          ? MaterialStateProperty.all(Colors.grey)
                          : _formKey.currentState!.isValid
                              ? MaterialStateProperty.all(Colors.green)
                              : MaterialStateProperty.all(Colors.grey)),
                  onPressed: () async {
                    bool? isValid = _formKey.currentState?.validate();
                    if (isValid == null || !isValid) {
                      return;
                    }

                    UserRepository userRepository = UserRepository(
                        authApi: AuthApi(), validApi: ValidApi());

                    final response = await userRepository.signUp(
                        accountName: _formKey
                            .currentState
                            ?.fields[SignUpFormFieldEnum.accountName.name]
                            ?.value,
                        password: _formKey.currentState
                            ?.fields[SignUpFormFieldEnum.password.name]?.value,
                        nickname: _formKey.currentState
                            ?.fields[SignUpFormFieldEnum.nickname.name]?.value,
                        email: _formKey.currentState
                            ?.fields[SignUpFormFieldEnum.email.name]?.value,
                        walletAddress: _formKey
                            .currentState
                            ?.fields[SignUpFormFieldEnum.walletAddress.name]
                            ?.value);
                  },
                  child: const Text('회원가입'),
                )),
            const SizedBox(
              height: kDefaultPadding,
            ),
          ]),
        ));
  }
}
