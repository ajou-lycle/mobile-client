import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/ui.dart';
import '../../utils/context_extension.dart';

bool isDialogShowing = false;

showDialogByOS(
    {required BuildContext context,
    required List<Widget> actions,
    Widget? title,
    Widget? content}) {
  isDialogShowing = true;
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

showLoadingDialog(BuildContext context, Widget child) {
  isDialogShowing = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async {
            isDialogShowing = false;
            return true;
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                child
              ],
            ),
          ));
    },
  );
}

showTimeoutDialog(BuildContext context, Widget child, Duration duration,
    bool Function(Route<dynamic>) predicate, void Function() timeoutHandler) {
  isDialogShowing = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async {
            isDialogShowing = false;
            return true;
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                child
              ],
            ),
          ));
    },
  );
  Future.delayed(duration, () {
    if (isDialogShowing) {
      isDialogShowing = false;

      if (context.isDeprecated()) {
        return;
      }

      timeoutHandler();
    }
  });
}
