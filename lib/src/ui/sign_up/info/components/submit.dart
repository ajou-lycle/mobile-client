import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lycle/src/data/api/certification/auth_api.dart';

import '../../../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../../../bloc/valid_form/valid_form_bloc.dart';
import '../../../../bloc/valid_form/valid_form_state.dart';
import '../../../../constants/ui.dart';
import '../../../../data/repository/certification/auth_repository.dart';
import '../../../widgets/dialog.dart';

class SignUpInfoSubmitButton extends StatefulWidget {
  final List<GlobalKey<FormBuilderState>> formKeyList;

  const SignUpInfoSubmitButton({Key? key, required this.formKeyList})
      : super(key: key);

  @override
  State<SignUpInfoSubmitButton> createState() => SignUpInfoSubmitButtonState();
}

class SignUpInfoSubmitButtonState extends State<SignUpInfoSubmitButton> {
  late ValidFormBloc _validFormBloc;
  late SnackBarBloc _snackBarBloc;
  bool _isValid = false;

  void showSignUpDialog() => showDialogByOS(
          context: context,
          title: const Text("회원가입 완료"),
          content: const Text("로그인 하시겠습니까?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "취소",
                )),
            TextButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text(
                  "로그인하러 가기",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ]);

  Future<void> signUp() async {
    Map<String, dynamic> data = {};

    _snackBarBloc.showLoadingSnackBar("회원가입 중 입니다.");

    for (GlobalKey<FormBuilderState> formKey in widget.formKeyList) {
      for (var key in formKey.currentState!.fields.keys) {
        data['$key'] = formKey.currentState!.fields[key]!.value;
      }
    }

    AuthRepository authRepository = AuthRepository(authApi: AuthApi());
    final response = await authRepository.signUp(data);

    if (response['result'] == null) {
      _snackBarBloc.showErrorSnackBar("회원가입에 실패하였습니다.");
      return;
    }

    if (response['result']) {
      _snackBarBloc.showSuccessSnackBar("회원가입에 성공했습니다.");
      showSignUpDialog();

      return;
    } else {
      _snackBarBloc.showErrorSnackBar("회원가입에 실패하였습니다.");
      return;
    }
  }

  @override
  void initState() {
    super.initState();

    _validFormBloc = BlocProvider.of<ValidFormBloc>(context);
    _snackBarBloc = BlocProvider.of<SnackBarBloc>(context);
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
        child: SizedBox(
            height: kPrimaryButtonDefaultHeight,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kDefaultRadius),
                          side: BorderSide(
                              color: _isValid
                                  ? kPrimaryButtonDoneBackgroundColor
                                  : kPrimaryButtonDisableForegroundColor,
                              width: kDefaultButtonBorder))),
                  backgroundColor: _isValid
                      ? MaterialStateProperty.all(
                          kPrimaryButtonDoneBackgroundColor)
                      : MaterialStateProperty.all(
                          kPrimaryButtonDisableBackgroundColor),
                  foregroundColor: _isValid
                      ? MaterialStateProperty.all(
                          kPrimaryButtonDoneForegroundColor)
                      : MaterialStateProperty.all(
                          kPrimaryButtonDisableForegroundColor),
                  elevation:
                      MaterialStateProperty.all(kPrimaryButtonElevation)),
              onPressed: () async {
                if (_validFormBloc.validRepository.valid.validate()) {
                  await signUp();
                }
              },
              child: const Padding(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Text('회원가입',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: kDefaultFontSize))),
            )));
  }
}
