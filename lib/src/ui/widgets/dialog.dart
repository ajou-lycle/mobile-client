import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showDialogByOS(
    {required BuildContext context,
    required List<Widget> actions,
    Widget? title,
    Widget? content}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: title,
            content: content,
            actions: actions,
          );
        } else {
          return AlertDialog(title: title, content: content, actions: actions);
        }
      });
}
