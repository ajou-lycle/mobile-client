import 'package:flutter/material.dart';

import 'package:lycle/src/ui/login/components/body.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginBody());
  }
}
