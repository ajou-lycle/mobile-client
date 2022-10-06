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

class SignUpWalletAddressForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const SignUpWalletAddressForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  @override
  State<SignUpWalletAddressForm> createState() => SignUpWalletAddressFormState();
}

class SignUpWalletAddressFormState extends State<SignUpWalletAddressForm> {
  late ValidFormBloc _validFormBloc;
  late SnackBarBloc _snackBarBloc;
  final String _walletAddressField = 'walletAddress';
  bool _isValid = false;
  bool _isDone = false;
  String? _helperText;
  String? validString;

  bool isValidWalletAddressField() {
    if (widget.formKey.currentState == null) {
      return false;
    }

    if (widget.formKey.currentState?.fields[_walletAddressField] == null) {
      return false;
    }

    if (widget.formKey.currentState?.fields[_walletAddressField]?.value ==
        null) {
      widget.formKey.currentState!.fields[_walletAddressField]!.invalidate("지갑 주소 입력은 필수입니다.");
      return false;
    }

    if (!widget.formKey.currentState!.fields[_walletAddressField]!.isValid) {
      return false;
    }

    return true;
  }

  Future<void> walletAddressExists() async {
    _snackBarBloc.showLoadingSnackBar("지갑 주소 중복 인증 중 입니다.");

    await _validFormBloc.validRepository.walletAddressExists(
        widget.formKey.currentState?.fields[_walletAddressField]?.value,
        AuthValidEnum.walletAddress.index);

    if (_validFormBloc
        .validRepository.valid.isPassList[AuthValidEnum.walletAddress.index]) {
      validString =
          widget.formKey.currentState?.fields[_walletAddressField]?.value;
      _validFormBloc
          .add(FormInputValidate(index: AuthValidEnum.walletAddress.index));
      _snackBarBloc.showSuccessSnackBar("이용 가능한 지갑 주소입니다.");
      setState(() {
        _helperText = "이용 가능한 지갑 주소입니다.";
        _isDone = true;
      });
    } else {
      _snackBarBloc.showErrorSnackBar("중복되는 지갑 주소입니다.");
      widget.formKey.currentState?.fields[_walletAddressField]
          ?.invalidate("중복되는 지갑 주소입니다.");
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
              .isPassList[AuthValidEnum.walletAddress.index]) {
            if (validString !=
                widget
                    .formKey.currentState?.fields[_walletAddressField]?.value) {
              _validFormBloc.add(FormInputUnValidate(
                  index: AuthValidEnum.walletAddress.index));
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
                  .isPassList[AuthValidEnum.walletAddressInput.index]) {
            setState(() {
              _isValid = _validFormBloc.validRepository.valid
                  .isPassList[AuthValidEnum.walletAddressInput.index];
              if (_isDone) {
                _isDone = !_isDone;
              }
            });
          }
        },
        child: RoundedValidFormBuilderTextField(
          formKey: widget.formKey,
          index: AuthValidEnum.walletAddressInput.index,
          name: _walletAddressField,
          title: '지갑 주소 *',
          hintText: '지갑 주소를 입력해주세요.',
          helperText: _helperText,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.match(walletAddressMatch,
                errorText: '올바른 지갑 주소가 아닙니다.'),
            FormBuilderValidators.required(errorText: '지갑 주소 입력은 필수입니다.')
          ]),
          borderRadius: kDefaultRadius,
          outerSuffix: OutlinedButton(
              onPressed: () async {
                if (!isValidWalletAddressField()) {
                  return;
                }

                await walletAddressExists();
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
              child: const Text("중복인증")),
        ));
  }
}
