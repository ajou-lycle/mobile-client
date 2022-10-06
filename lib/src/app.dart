import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:form_builder_validators/localization/l10n.dart';

import 'ui/loading/loading.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const KeyboardDismissOnTap(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              FormBuilderLocalizations.delegate,
            ],
            home: LoadingPage()));
  }
}
