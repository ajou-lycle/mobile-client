import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../../bloc/valid_form/valid_form_bloc.dart';
import '../../../constants/assets.dart';
import '../../../constants/ui.dart';

import '../../widgets/snack_bar/snack_bar.dart';

import '../constant.dart';
import 'form/form.dart';
import 'submit.dart';
import 'option_text_buttons.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => LoginBodyState();
}

class LoginBodyState extends State<LoginBody> {
  late SnackBarBloc _snackBarBloc;
  late ValidFormBloc _validFormBloc;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _snackBarBloc = BlocProvider.of<SnackBarBloc>(context);
    _validFormBloc = BlocProvider.of<ValidFormBloc>(context);
    _validFormBloc.subscribeValidation(numOfValidation: 2);
  }

  @override
  void dispose() {
    _validFormBloc.unSubscribeValidation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    LoginPageConstant.bannerImageSize ??= size.height * 0.425 -
        (LoginPageConstant.textFormFieldHeight + kDefaultPadding * 2);
    double topPadding = size.height * 0.075;

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
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding * 2),
                      child: Image.asset(
                        loginBannerPng,
                        height: LoginPageConstant.bannerImageSize,
                        width: LoginPageConstant.bannerImageSize,
                      )),
                  LoginForm(
                    formKey: _formKey,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  LoginSubmitButton(
                    formKey: _formKey,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  const OptionTextButtons(),
                ],
              ),
            )));
  }
}
