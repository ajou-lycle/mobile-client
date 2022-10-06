import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../../../constants/ui.dart';
import '../../../../data/api/certification/auth_api.dart';
import '../../../../data/api/certification/valid_api.dart';
import '../../../../data/repository/user_repository.dart';
import '../../constant.dart';
import 'account_name.dart';
import 'password.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const LoginForm({Key? key, required this.formKey}) : super(key: key);

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: FormBuilder(
          key: widget.formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            LoginAccountNameForm(
              formKey: widget.formKey,
            ),
            LoginPasswordForm(
              formKey: widget.formKey,
            ),
          ]),
        ));
  }
}
