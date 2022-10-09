import 'package:flutter/material.dart';

import 'component/body.dart';

class QuestDetailArguments {
  final int index;

  QuestDetailArguments({required this.index});
}

class QuestDetailPage extends StatelessWidget {
  final int index;

  const QuestDetailPage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: QuestDetailBody(
        index: index,
      )),
    );
  }
}
