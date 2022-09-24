import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lycle/src/bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_state.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_bloc.dart';
import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_event.dart';
import '../../../constants/ui.dart';
import '../../widgets/text_form_field_with_scroll.dart/rounded_text_form_field_with_scroll_form_block.dart';
import '../constant.dart';

class LoginForm extends StatefulWidget {
  final bool isKeyboardVisible;

  const LoginForm({Key? key, required this.isKeyboardVisible})
      : super(key: key);

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  late ScrollFormWithKeyboardBloc _scrollFormWithKeyboardBloc;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollFormWithKeyboardBloc =
        BlocProvider.of<ScrollFormWithKeyboardBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RoundedTextFormFieldWithScrollFormBlock(
                name: 'userId',
                borderRadius: kDefaultRadius,
                formKey: _formKey,
                validator:
                    FormBuilderValidators.required(errorText: '아이디를 입력해주세요.'),
                errorTextFontSize:
                    LoginPageConstant.textFormFieldErrorTextHeight,
                fillColor: Colors.grey[100],
                hintText: '아이디를 입력해주세요',
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              RoundedTextFormFieldWithScrollFormBlock(
                name: 'password',
                borderRadius: kDefaultRadius,
                formKey: _formKey,
                validator:
                    FormBuilderValidators.required(errorText: '비밀번호를 입력해주세요.'),
                errorTextFontSize:
                    LoginPageConstant.textFormFieldErrorTextHeight,
                fillColor: Colors.grey[100],
                hintText: '비밀번호를 입력해주세요',
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              SizedBox(
                  height: LoginPageConstant.submitButtonHeight,
                  child: ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () async {
                      if (_formKey.currentState == null) {
                        return;
                      }

                      _formKey.currentState?.validate();

                      double scrollHeight = 0;

                      _formKey.currentState?.fields.forEach((key, value) {
                        if (!value.isValid) {
                          scrollHeight +=
                              LoginPageConstant.textFormFieldErrorTextHeight;
                        }
                      });

                      if (_scrollFormWithKeyboardBloc.state
                          is ScrollFormWithKeyboardVisible) {
                        scrollHeight += LoginPageConstant.textFormFieldHeight +
                            LoginPageConstant.optionTextButtonsHeight;
                      }

                      if (scrollHeight != 0) {
                        _scrollFormWithKeyboardBloc
                            .add(ErrorTextVisible(scrollHeight: scrollHeight));
                      }
                    },
                  )),
              const SizedBox(
                height: kDefaultPadding,
              ),
            ],
          ),
        ));
  }
}
