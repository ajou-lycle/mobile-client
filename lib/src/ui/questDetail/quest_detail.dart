import 'package:flutter/material.dart';

import 'component/body.dart';

class QuestDetailPage extends StatelessWidget {
  int index;

  QuestDetailPage({required this.index});

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
