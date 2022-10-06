import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../bloc/valid_form/valid_form_bloc.dart';
import 'components/body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ValidFormBloc()),
          BlocProvider(create: (context) => SnackBarBloc())
        ],
        child:
            const Scaffold(resizeToAvoidBottomInset: false, body: LoginBody()));
  }
}
