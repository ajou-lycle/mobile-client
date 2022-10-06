import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../../bloc/valid_form/valid_form_bloc.dart';
import '../../../../../constants/ui.dart';
import 'nickname.dart';
import 'wallet_address.dart';
import 'email.dart';

class SignUpInfoForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const SignUpInfoForm({Key? key, required this.formKey}) : super(key: key);

  @override
  State<SignUpInfoForm> createState() => SignUpInfoFormState();
}

class SignUpInfoFormState extends State<SignUpInfoForm> {
  late ValidFormBloc _validFormBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _validFormBloc = BlocProvider.of<ValidFormBloc>(context);
    _validFormBloc.subscribeValidation(numOfValidation: 7);
  }

  @override
  void dispose() {
    _validFormBloc.unSubscribeValidation(numOfValidation: 7);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: widget.formKey,
        child: Column(
          children: [
            SignUpNicknameForm(formKey: widget.formKey),
            const SizedBox(
              height: kDefaultPadding,
            ),
            SignUpWalletAddressForm(formKey: widget.formKey),
            const SizedBox(
              height: kDefaultPadding,
            ),
            SignUpEmailForm(formKey: widget.formKey),
            const SizedBox(
              height: kDefaultPadding,
            ),
          ],
        ));
  }
}
