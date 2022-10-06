import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../constants/ui.dart';
import '../../../../data/enum/auth_valid.dart';
import '../../../widgets/valid_form_builder_text_field/rounded_valid_form_builder_text_field.dart';

class LoginPasswordForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const LoginPasswordForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  @override
  State<LoginPasswordForm> createState() => LoginPasswordFormState();
}

class LoginPasswordFormState extends State<LoginPasswordForm> {
  final String _passwordField = 'password';
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      RoundedValidFormBuilderTextField(
        formKey: widget.formKey,
        index: AuthValidEnum.password.index - 1,
        name: _passwordField,
        hintText: '비밀번호를 입력해주세요.',
        obscureText: !_passwordVisible,
        borderRadius: kDefaultRadius,
        validator: FormBuilderValidators.compose(
            [FormBuilderValidators.required(errorText: '비밀번호 입력은 필수입니다.')]),
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
