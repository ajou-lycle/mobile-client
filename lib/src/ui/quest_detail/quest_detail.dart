import 'package:flutter/material.dart';
import 'package:lycle/src/ui/widgets/snack_bar/transaction_snack_bar.dart';

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
