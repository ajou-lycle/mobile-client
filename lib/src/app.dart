import 'package:flutter/material.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:form_builder_validators/localization/l10n.dart';

import 'constants/ui.dart';
import 'routes/routes.dart';

import 'ui/loading/loading.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: routes,
      theme: ThemeData(
        fontFamily: kDefaultFontFamily,
      ),
      onGenerateRoute: onGenerateRoute,
    ));
  }
}
