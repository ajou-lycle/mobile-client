import 'package:flutter/material.dart';

import 'package:form_builder_validators/localization/l10n.dart';

import 'ui/home/home.dart';
import 'ui/login/login.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          FormBuilderLocalizations.delegate,
        ],
        home: LoginPage());
  }
}
