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

class SignUpNicknameForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const SignUpNicknameForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  @override
  State<SignUpNicknameForm> createState() => SignUpNicknameFormState();
}

class SignUpNicknameFormState extends State<SignUpNicknameForm> {
  late ValidFormBloc _validFormBloc;
  late SnackBarBloc _snackBarBloc;
  final String _nicknameField = 'nickname';
  bool _isValid = false;
  bool _isDone = false;
  String? _helperText;
  String? validString;

  bool isValidNicknameField() {
    if (widget.formKey.currentState == null) {
      return false;
    }

    if (widget.formKey.currentState?.fields[_nicknameField] == null) {
      return false;
    }

    if (widget.formKey.currentState?.fields[_nicknameField]?.value == null) {
      widget.formKey.currentState!.fields[_nicknameField]!.invalidate("닉네임 입력은 필수입니다.");
      return false;
    }

    if (!widget.formKey.currentState!.fields[_nicknameField]!.isValid) {
      return false;
    }

    return true;
  }

  Future<void> nicknameExists() async {
    _snackBarBloc.showLoadingSnackBar("닉네임 중복 인증 중 입니다.");

    await _validFormBloc.validRepository.nicknameExists(
        widget.formKey.currentState?.fields[_nicknameField]?.value,
        AuthValidEnum.nickname.index);

    if (_validFormBloc
        .validRepository.valid.isPassList[AuthValidEnum.nickname.index]) {
      validString = widget.formKey.currentState?.fields[_nicknameField]?.value;
      _validFormBloc
          .add(FormInputValidate(index: AuthValidEnum.nickname.index));
      _snackBarBloc.showSuccessSnackBar("이용 가능한 닉네임입니다.");
      setState(() {
        _helperText = "이용 가능한 닉네임입니다.";
        _isDone = true;
      });
    } else {
      _snackBarBloc.showErrorSnackBar("중복되는 닉네임입니다.");
      widget.formKey.currentState?.fields[_nicknameField]
          ?.invalidate("중복되는 닉네임입니다.");
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
          if (_validFormBloc
              .validRepository.valid.isPassList[AuthValidEnum.nickname.index]) {
            if (validString !=
                widget.formKey.currentState?.fields[_nicknameField]?.value) {
              _validFormBloc.add(
                  FormInputUnValidate(index: AuthValidEnum.nickname.index));
              setState(() {
                _isDone = false;
                if (_helperText != null) {
                  _helperText = null;
                }
              });
            }
          }
          if (_isValid !=
              _validFormBloc.validRepository.valid
                  .isPassList[AuthValidEnum.nicknameInput.index]) {
            setState(() {
              _isValid = _validFormBloc.validRepository.valid
                  .isPassList[AuthValidEnum.nicknameInput.index];
              if (_isDone) {
                _isDone = !_isDone;
              }
            });
          }
        },
        child: RoundedValidFormBuilderTextField(
          formKey: widget.formKey,
          index: AuthValidEnum.nicknameInput.index,
          name: _nicknameField,
          title: '닉네임 *',
          hintText: '닉네임을 입력해주세요.',
          helperText: _helperText,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.match(nicknameMatch,
                errorText: '영어나 숫자, 한글 포함 3자 이상 10자 이내'),
            FormBuilderValidators.required(errorText: '닉네임 입력은 필수입니다.')
          ]),
          borderRadius: kDefaultRadius,
          outerSuffix: OutlinedButton(
              onPressed: () async {
                if (!isValidNicknameField()) {
                  return;
                }

                await nicknameExists();
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
