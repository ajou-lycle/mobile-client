import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../../constants/regular_expression.dart';
import '../../../../../constants/ui.dart';
import '../../../../../data/enum/auth_valid.dart';
import '../../../../widgets/valid_form_builder_text_field/rounded_valid_form_builder_text_field.dart';

class SignUpPasswordForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const SignUpPasswordForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  @override
  State<SignUpPasswordForm> createState() => SignUpPasswordFormState();
}

class SignUpPasswordFormState extends State<SignUpPasswordForm> {
  final String _passwordField = 'password';
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      RoundedValidFormBuilderTextField(
        formKey: widget.formKey,
        index: AuthValidEnum.password.index,
        name: _passwordField,
        title: '비밀번호 *',
        hintText: '비밀번호를 입력해주세요.',
        obscureText: !_passwordVisible,
        borderRadius: kDefaultRadius,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.match(passwordMatch,
              errorText: '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내'),
          FormBuilderValidators.required(errorText: '비밀번호 입력은 필수입니다.')
        ]),
        suffixIcon: IconButton(
            onPressed: () =>
                setState(() => _passwordVisible = !_passwordVisible),
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility_off : Icons.visibility,
              color: kPrimaryColor,
            )),
      ),
      const SizedBox(
        height: kDefaultPadding,
      ),
    ]);
  }
}
