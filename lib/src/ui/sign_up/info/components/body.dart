import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../../../constants/ui.dart';

import '../../../widgets/snack_bar/snack_bar.dart';

import 'submit.dart';
import 'form/form.dart';

class SignUpInfoBody extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const SignUpInfoBody({Key? key, required this.formKey}) : super(key: key);

  @override
  State<SignUpInfoBody> createState() => SignUpInfoBodyState();
}

class SignUpInfoBodyState extends State<SignUpInfoBody> {
  late SnackBarBloc _snackBarBloc;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    _snackBarBloc = BlocProvider.of<SnackBarBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double topPadding = size.height * 0.05;

    return SnackBarBuilder(
        snackBarBloc: _snackBarBloc,
        child: Container(
            height: size.height,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(
                  top: topPadding,
                  left: kDefaultPadding,
                  right: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SignUpInfoForm(
                    formKey: _formKey,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  SignUpInfoSubmitButton(
                    formKeyList: [widget.formKey, _formKey],
                  ),
                ],
              ),
            )));
  }
}
