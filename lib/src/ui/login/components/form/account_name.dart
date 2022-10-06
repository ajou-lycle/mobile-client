import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../constants/ui.dart';
import '../../../../data/enum/auth_valid.dart';
import '../../../widgets/valid_form_builder_text_field/rounded_valid_form_builder_text_field.dart';

class LoginAccountNameForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const LoginAccountNameForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  @override
  State<LoginAccountNameForm> createState() => LoginAccountNameFormState();
}

class LoginAccountNameFormState extends State<LoginAccountNameForm> {
  final String _accountField = 'accountName';

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      RoundedValidFormBuilderTextField(
        formKey: widget.formKey,
        index: AuthValidEnum.accountName.index - 1,
        name: _accountField,
        hintText: '아이디를 입력해주세요.',
        borderRadius: kDefaultRadius,
        validator: FormBuilderValidators.compose(
            [FormBuilderValidators.required(errorText: '아이디 입력은 필수입니다.')]),
      ),
      const SizedBox(
        height: kDefaultPadding,
      ),
    ]);
  }
}
