import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../../bloc/valid_form/valid_form_bloc.dart';
import '../../../constants/ui.dart';
import '../../../data/api/certification/auth_api.dart';
import '../../../data/api/certification/valid_api.dart';
import '../../../data/repository/user_repository.dart';
import '../../home/home.dart';
import '../constant.dart';

class LoginSubmitButton extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  const LoginSubmitButton({Key? key, required this.formKey}) : super(key: key);

  @override
  State<LoginSubmitButton> createState() => LoginSubmitButtonState();
}

class LoginSubmitButtonState extends State<LoginSubmitButton> {
  late ValidFormBloc _validFormBloc;
  late SnackBarBloc _snackBarBloc;

  Future<void> login() async {
    Map<String, dynamic> data = {};

    _snackBarBloc.showLoadingSnackBar("로그인 중 입니다.");

    for (var key in widget.formKey.currentState!.fields.keys) {
      data['$key'] = widget.formKey.currentState!.fields[key]!.value;
    }

    UserRepository userRepository =
        UserRepository(authApi: AuthApi(), validApi: ValidApi());

    final response = await userRepository.login(
        accountName: data['accountName'], password: data['password']);

    if (userRepository.user == null) {
      _snackBarBloc.showErrorSnackBar("로그인에 실패하였습니다.");
      return;
    } else {
      _snackBarBloc.showSuccessSnackBar("로그인에 성공했습니다.");
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      return;
    }
  }

  @override
  void initState() {
    super.initState();

    _snackBarBloc = BlocProvider.of<SnackBarBloc>(context);
    _validFormBloc = BlocProvider.of<ValidFormBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: LoginPageConstant.submitButtonHeight,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kDefaultRadius))),
              backgroundColor: MaterialStateProperty.all(kPrimaryColor),
              elevation:
                  MaterialStateProperty.all<double>(kPrimaryButtonElevation)),
          onPressed: () async {
            if (_validFormBloc.validRepository.valid.validate()) {
              await login();
            } else {
              if (widget.formKey.currentState == null) {
                return;
              }

              widget.formKey.currentState?.validate();
            }
          },
          child: const Text(
            '로그인',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: kDefaultFontSize),
          ),
        ));
  }
}
