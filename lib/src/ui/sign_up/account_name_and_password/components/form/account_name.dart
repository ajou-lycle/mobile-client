import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../../../../bloc/valid_form/valid_form_bloc.dart';
import '../../../../../bloc/valid_form/valid_form_event.dart';
import '../../../../../bloc/valid_form/valid_form_state.dart';

import '../../../../../constants/regular_expression.dart';
import '../../../../../constants/ui.dart';
import '../../../../../data/enum/auth_valid.dart';
import '../../../../widgets/valid_form_builder_text_field/rounded_valid_form_builder_text_field.dart';

class SignUpAccountNameForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const SignUpAccountNameForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  @override
  State<SignUpAccountNameForm> createState() => SignUpAccountNameFormState();
}

class SignUpAccountNameFormState extends State<SignUpAccountNameForm> {
  late ValidFormBloc _validFormBloc;
  late SnackBarBloc _snackBarBloc;
  final String _accountNameField = 'accountName';
  bool _isValid = false;
  bool _isDone = false;
  String? _helperText;
  String? validString;

  bool isValidAccountNameField() {
    if (widget.formKey.currentState == null) {
      return false;
    }

    if (widget.formKey.currentState?.fields[_accountNameField] == null) {
      return false;
    }

    if (widget.formKey.currentState?.fields[_accountNameField]?.value == null) {
      widget.formKey.currentState!.fields[_accountNameField]!.invalidate("아이디 입력은 필수입니다.");
      return false;
    }

    if (!widget.formKey.currentState!.fields[_accountNameField]!.isValid) {
      return false;
    }

    return true;
  }

  Future<void> accountNameExists() async {
    _snackBarBloc.showLoadingSnackBar("아이디 중복 인증 중 입니다.");

    await _validFormBloc.validRepository.accountNameExists(
        widget.formKey.currentState?.fields[_accountNameField]?.value,
        AuthValidEnum.accountName.index);

    if (_validFormBloc
        .validRepository.valid.isPassList[AuthValidEnum.accountName.index]) {
      validString =
          widget.formKey.currentState?.fields[_accountNameField]?.value;
      _validFormBloc
          .add(FormInputValidate(index: AuthValidEnum.accountName.index));
      _snackBarBloc.showSuccessSnackBar("이용 가능한 아이디입니다.");
      setState(() {
        _helperText = "이용 가능한 아이디입니다.";
        _isDone = true;
      });
    } else {
      _snackBarBloc.showErrorSnackBar("중복되는 아이디입니다.");
      widget.formKey.currentState?.fields[_accountNameField]
          ?.invalidate("중복되는 아이디입니다.");
      setState(() {
        _helperText = null;
        _isDone = false;
      });
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
              .isPassList[AuthValidEnum.accountName.index]) {
            if (validString !=
                widget.formKey.currentState?.fields[_accountNameField]?.value) {
              _validFormBloc.add(
                  FormInputUnValidate(index: AuthValidEnum.accountName.index));
              setState(() {
                _isDone = false;
                if (_helperText != null) {
                  setState(() => _helperText = null);
                }
              });
            }
          }
          if (_isValid !=
              _validFormBloc.validRepository.valid
                  .isPassList[AuthValidEnum.accountNameInput.index]) {
            setState(() {
              _isValid = _validFormBloc.validRepository.valid
                  .isPassList[AuthValidEnum.accountNameInput.index];
              if (_isDone) {
                _isDone = !_isDone;
              }
            });
          }
        },
        child: RoundedValidFormBuilderTextField(
          formKey: widget.formKey,
          index: AuthValidEnum.accountNameInput.index,
          name: _accountNameField,
          title: '아이디 *',
          hintText: '아아디를 입력해주세요.',
          helperText: _helperText,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.match(accountNameMatch,
                errorText: '영어나 숫자 포함 3자 이상 20자 이내'),
            FormBuilderValidators.required(errorText: '아이디 입력은 필수입니다.')
          ]),
          borderRadius: kDefaultRadius,
          outerSuffix: OutlinedButton(
              onPressed: () async {
                if (!isValidAccountNameField()) {
                  return;
                }
                await accountNameExists();
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kDefaultRadius),
                        side: BorderSide(
                            color: _isDone
                                ? kSecondButtonDoneBorderColor
                                : kSecondButtonValidBorderColor,
                            width: kDefaultButtonBorder)),
                  ),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      vertical: kDefaultPadding * 1.4,
                      horizontal: kDefaultPadding * 1.5)),
                  elevation: MaterialStateProperty.all(kSecondButtonElevation),
                  backgroundColor: MaterialStateProperty.all(_isDone
                      ? kSecondButtonDoneBackgroundColor
                      : kSecondButtonValidBackgroundColor),
                  foregroundColor: MaterialStateProperty.all(_isDone
                      ? kSecondButtonDoneForegroundColor
                      : kSecondButtonValidForegroundColor)),
              child: Text("중복인증")),
        ));
  }
}
