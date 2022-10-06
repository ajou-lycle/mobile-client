import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../../../../bloc/valid_form/valid_form_bloc.dart';
import '../../../../../bloc/valid_form/valid_form_event.dart';
import '../../../../../bloc/valid_form/valid_form_state.dart';

import '../../../../../constants/ui.dart';
import '../../../../../data/enum/auth_valid.dart';
import '../../../../widgets/valid_form_builder_text_field/rounded_valid_form_builder_text_field.dart';

class SignUpEmailForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const SignUpEmailForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  @override
  State<SignUpEmailForm> createState() => SignUpEmailFormState();
}

class SignUpEmailFormState extends State<SignUpEmailForm> {
  late ValidFormBloc _validFormBloc;
  late SnackBarBloc _snackBarBloc;
  final String _emailField = 'email';
  bool _isValidInput = false;
  bool _isSent = false;
  bool _isDone = false;
  String? _helperText;
  String? validString;

  bool isValidEmailField() {
    if (widget.formKey.currentState == null) {
      return false;
    }

    if (widget.formKey.currentState?.fields[_emailField] == null) {
      return false;
    }

    if (widget.formKey.currentState?.fields[_emailField]?.value == null) {
      widget.formKey.currentState!.fields[_emailField]!
          .invalidate("이메일 입력은 필수입니다.");
      return false;
    }

    if (!widget.formKey.currentState!.fields[_emailField]!.isValid) {
      return false;
    }

    return true;
  }

  Future<void> sendEmail() async {
    _snackBarBloc.showLoadingSnackBar("인증 이메일을 전송 중 입니다.");

    await _validFormBloc.validRepository.emailSend(
        widget.formKey.currentState?.fields[_emailField]?.value,
        AuthValidEnum.emailSend.index);

    if (_validFormBloc
        .validRepository.valid.isPassList[AuthValidEnum.emailSend.index]) {
      validString = widget.formKey.currentState?.fields[_emailField]?.value;
      _validFormBloc
          .add(FormInputValidate(index: AuthValidEnum.emailSend.index));
      _snackBarBloc.showSuccessSnackBar("인증 이메일을 전송했습니다.");
      setState(() => _helperText = "인증 이메일을 전송했습니다.");
    } else {
      _snackBarBloc.showErrorSnackBar("인증 이메일을 전송할 수 없습니다.");
      setState(() => _helperText = null);
      widget.formKey.currentState?.fields[_emailField]
          ?.invalidate("인증 이메일을 전송할 수 없습니다.");
    }
  }

  Future<void> checkEmail() async {
    _snackBarBloc.showLoadingSnackBar("이메일 인증을 확인 중 입니다.");

    await _validFormBloc.validRepository.emailCheck(
        widget.formKey.currentState?.fields[_emailField]?.value,
        AuthValidEnum.emailCheck.index);

    if (_validFormBloc
        .validRepository.valid.isPassList[AuthValidEnum.emailCheck.index]) {
      validString = widget.formKey.currentState?.fields[_emailField]?.value;
      _validFormBloc
          .add(FormInputValidate(index: AuthValidEnum.emailCheck.index));
      _snackBarBloc.showSuccessSnackBar("이메일 인증이 완료되었습니다.");
      setState(() {
        _helperText = "이메일 인증이 완료되었습니다.";
        _isDone = true;
      });
    } else {
      _snackBarBloc.showErrorSnackBar("이메일 인증이 실패하였습니다.");
      setState(() {
        _helperText = null;
        _isDone = false;
      });
      widget.formKey.currentState?.fields[_emailField]
          ?.invalidate("이메일 인증이 실패하였습니다.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _validFormBloc = BlocProvider.of<ValidFormBloc>(context);
    _snackBarBloc = BlocProvider.of<SnackBarBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ValidFormBloc, ValidFormState>(
        bloc: _validFormBloc,
        listener: (context, state) {
          if (_validFormBloc.validRepository.valid
                  .isPassList[AuthValidEnum.emailSend.index] ||
              _validFormBloc.validRepository.valid
                  .isPassList[AuthValidEnum.emailCheck.index]) {
            if (validString !=
                widget.formKey.currentState?.fields[_emailField]?.value) {
              _validFormBloc.add(
                  FormInputUnValidate(index: AuthValidEnum.emailCheck.index));
              _validFormBloc.add(
                  FormInputUnValidate(index: AuthValidEnum.emailSend.index));
              setState(() {
                _isDone = false;
                if (_helperText != null) {
                  _helperText = null;
                }
              });
            }
          }
          if (_isValidInput !=
              _validFormBloc.validRepository.valid
                  .isPassList[AuthValidEnum.emailInput.index]) {
            setState(() {
              _isValidInput = _validFormBloc.validRepository.valid
                  .isPassList[AuthValidEnum.emailInput.index];
              if (_isDone) {
                _isDone = !_isDone;
              }
            });
          }

          if (_isValidInput) {
            if (_isSent !=
                _validFormBloc.validRepository.valid
                    .isPassList[AuthValidEnum.emailSend.index]) {
              setState(() {
                _isSent = _validFormBloc.validRepository.valid
                    .isPassList[AuthValidEnum.emailSend.index];
                if (_isDone) {
                  _isDone = !_isDone;
                }
              });
            }
          }
        },
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          RoundedValidFormBuilderTextField(
            formKey: widget.formKey,
            index: AuthValidEnum.emailInput.index,
            name: _emailField,
            title: '이메일 *',
            hintText: '이메일을 입력해주세요.',
            helperText: _helperText,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.email(errorText: "올바른 이메일이 아닙니다."),
              FormBuilderValidators.required(errorText: '이메일 입력은 필수입니다.')
            ]),
            borderRadius: kDefaultRadius,
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          Row(children: [
            Expanded(
                child: OutlinedButton(
                    onPressed: () async {
                      if (!isValidEmailField()) {
                        return;
                      }

                      await sendEmail();
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kDefaultRadius),
                              side: BorderSide(
                                  color: _isSent
                                      ? kSecondButtonDoneBorderColor
                                      : kSecondButtonValidBorderColor,
                                  width: kDefaultButtonBorder)),
                        ),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: kDefaultPadding * 1.4,
                                horizontal: kDefaultPadding * 1.5)),
                        elevation:
                            MaterialStateProperty.all(kSecondButtonElevation),
                        backgroundColor: MaterialStateProperty.all(_isSent
                            ? kSecondButtonDoneBackgroundColor
                            : kSecondButtonValidBackgroundColor),
                        foregroundColor: MaterialStateProperty.all(_isSent
                            ? kSecondButtonDoneForegroundColor
                            : kSecondButtonValidForegroundColor)),
                    child: const Text("인증 이메일 전송"))),
            const SizedBox(
              width: kDefaultPadding,
            ),
            Expanded(
                child: OutlinedButton(
                    onPressed: () async {
                      if (!isValidEmailField()) {
                        return;
                      }

                      if (_validFormBloc.validRepository.valid
                          .isPassList[AuthValidEnum.emailSend.index]) {
                        await checkEmail();
                      }
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kDefaultRadius),
                              side: BorderSide(
                                  color: _isDone
                                      ? kSecondButtonValidBorderColor
                                      : kSecondButtonDisableBorderColor,
                                  width: kDefaultButtonBorder)),
                        ),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: kDefaultPadding * 1.4,
                                horizontal: kDefaultPadding * 1.5)),
                        elevation:
                            MaterialStateProperty.all(kSecondButtonElevation),
                        backgroundColor: MaterialStateProperty.all(_isSent
                            ? _isDone
                                ? kSecondButtonDoneBackgroundColor
                                : kSecondButtonValidBackgroundColor
                            : kSecondButtonDisableBackgroundColor),
                        foregroundColor: MaterialStateProperty.all(_isDone
                            ? kSecondButtonDoneForegroundColor
                            : _isSent
                                ? kSecondButtonValidForegroundColor
                                : kSecondButtonDisableForegroundColor)),
                    child: const Text("이메일 인증")))
          ]),
        ]));
  }
}
