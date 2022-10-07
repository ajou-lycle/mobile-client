import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../../bloc/valid_form/valid_form_bloc.dart';
import '../../../bloc/wallet/wallet_bloc.dart';
import '../../../bloc/wallet/wallet_error.dart';
import '../../../bloc/wallet/wallet_event.dart';
import '../../../bloc/wallet/wallet_state.dart';
import '../../../constants/ui.dart';
import '../../../data/api/certification/auth_api.dart';
import '../../../data/api/certification/valid_api.dart';
import '../../../data/repository/user_repository.dart';
import '../../home/home.dart';
import '../../widgets/dialog.dart';
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
  late WalletBloc _walletBloc;
  bool isError = false;

  void showRequestWalletConnectDialog() {
    showDialogByOS(
        context: context,
        title: Text("블록체인 지갑 연결이 필요해요!"),
        content: Text("Lycle은 블록체인 지갑이 연결되어야만 사용할 수 있답니다."),
        actions: [
          TextButton(
              onPressed: () {
                isDialogShowing = false;
                Navigator.of(context).pop();
              },
              child: Text("취소")),
          TextButton(
              onPressed: () async {
                _walletBloc.add(ConnectWallet(walletAddress: null));
                isDialogShowing = false;
                Navigator.of(context).pop();
              },
              child: Text(
                "연결하기",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ]);
  }

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
    _walletBloc = BlocProvider.of<WalletBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
        bloc: _walletBloc,
        listener: (context, state) {
          if (state is WalletError) {
            isError = true;
            if (state.error == WalletErrorEnum.notConnected.errorMessage) {
              _snackBarBloc.showErrorSnackBar("지갑 연결에 실패했습니다.");
            } else {
              _snackBarBloc.showErrorSnackBar("알 수 없는 오류가 발생했습니다.");
            }
            if (isDialogShowing) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          } else if (state is WalletConnected) {
            isError = false;
            _snackBarBloc.showSuccessSnackBar("지갑 연결에 성공했습니다.");
          } else if (state is WalletLoading) {
            isError = false;
            showLoadingDialog(
                context,
                const Text(
                  "지갑 연결을 시도 중입니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Duration(seconds: 10),
                (Route<dynamic> route) => route.isFirst, () {
              if (!isError) {
                showLoadingDialog(
                    context,
                    const Text(
                      "블록체인 지갑 어플리케이션이\n설치되어 있는지 확인해주세요!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Duration(seconds: 15),
                    (Route<dynamic> route) => route.isFirst,
                    () => _snackBarBloc.showErrorSnackBar("지갑 연결에 실패했습니다.",
                        closedCallback: () => _walletBloc.add(EmptyWallet())));
              }
            });
          } else {
            isError = false;
          }
        },
        child: SizedBox(
            height: LoginPageConstant.submitButtonHeight,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kDefaultRadius))),
                  backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                  elevation: MaterialStateProperty.all<double>(
                      kPrimaryButtonElevation)),
              onPressed: () async {
                if (_validFormBloc.validRepository.valid.validate()) {
                  showRequestWalletConnectDialog();
                  // await login();
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
            )));
  }
}
