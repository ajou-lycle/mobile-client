import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../../../bloc/valid_form/valid_form_bloc.dart';
import '../../../../bloc/valid_form/valid_form_state.dart';
import '../../../../constants/ui.dart';
import '../../../animations/animated_navigator.dart';
import '../../info/info.dart';

class SignUpAccountNameAndPasswordSubmitButton extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const SignUpAccountNameAndPasswordSubmitButton(
      {Key? key, required this.formKey})
      : super(key: key);

  @override
  State<SignUpAccountNameAndPasswordSubmitButton> createState() =>
      SignUpAccountNameAndPasswordSubmitButtonState();
}

class SignUpAccountNameAndPasswordSubmitButtonState
    extends State<SignUpAccountNameAndPasswordSubmitButton> {
  late ValidFormBloc _validFormBloc;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();

    _validFormBloc = BlocProvider.of<ValidFormBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ValidFormBloc, ValidFormState>(
        bloc: _validFormBloc,
        listener: (context, state) {
          if (state is ValidFormPass) {
            setState(() => _isValid = true);
          }
          if (state is ValidFormUnPass) {
            setState(() => _isValid = false);
          }
        },
        child: SizedBox(height: kPrimaryButtonDefaultHeight, child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kDefaultRadius),
                      side: BorderSide(
                          color: _isValid ? kPrimaryButtonDoneBackgroundColor : kPrimaryButtonDisableForegroundColor,
                          width: kDefaultButtonBorder))),
              backgroundColor: _isValid
                  ? MaterialStateProperty.all(kPrimaryButtonDoneBackgroundColor)
                  : MaterialStateProperty.all(kPrimaryButtonDisableBackgroundColor),
              foregroundColor: _isValid
                  ? MaterialStateProperty.all(kPrimaryButtonDoneForegroundColor)
                  : MaterialStateProperty.all(kPrimaryButtonDisableForegroundColor),
              elevation: MaterialStateProperty.all(kPrimaryButtonElevation)),
          onPressed: () {
            if (_isValid) {
              Navigator.of(context)
                  .push(AnimatedNavigator.defaultNavigator(MultiBlocProvider(
                      providers: [
                    BlocProvider<SnackBarBloc>(
                      create: (context) => SnackBarBloc(),
                    ),
                    BlocProvider<ValidFormBloc>.value(value: _validFormBloc)
                  ],
                      child: SignUpInfoPage(
                        formKey: widget.formKey,
                      ))));
            }
          },
          child: const Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Text('다음',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: kDefaultFontSize))),
        )));
  }
}
