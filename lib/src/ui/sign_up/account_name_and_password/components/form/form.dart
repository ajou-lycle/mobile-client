import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../../bloc/valid_form/valid_form_bloc.dart';
import '../../../../../constants/ui.dart';
import 'password.dart';
import 'account_name.dart';

class SignUpAccountNameAndPasswordForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const SignUpAccountNameAndPasswordForm({Key? key, required this.formKey})
      : super(key: key);

  @override
  State<SignUpAccountNameAndPasswordForm> createState() =>
      SignUpAccountNameAndPasswordFormState();
}

class SignUpAccountNameAndPasswordFormState
    extends State<SignUpAccountNameAndPasswordForm> {
  late ValidFormBloc _validFormBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _validFormBloc = BlocProvider.of<ValidFormBloc>(context);
    _validFormBloc.subscribeValidation(numOfValidation: 3);
  }

  @override
  void dispose() {
    _validFormBloc.unSubscribeValidation();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: widget.formKey,
        child: Column(
          children: [
            SignUpAccountNameForm(formKey: widget.formKey),
            const SizedBox(
              height: kDefaultPadding,
            ),
            SignUpPasswordForm(formKey: widget.formKey)
          ],
        ));
  }
}
