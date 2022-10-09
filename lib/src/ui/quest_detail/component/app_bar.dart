import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/assets.dart';
import '../../../constants/ui.dart';

class QuestDetailAppBar extends StatelessWidget {
  const QuestDetailAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 3),
            blurRadius: 20,
            spreadRadius: 0)
      ], color: Color(0xffffffff)),
      child: Row(
        children: [
          GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back,
                color: kPrimaryColor,
                size: 36,
              )),
          const Expanded(
              child: Text(" 퀘스트",
                  style: TextStyle(
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 24.0),
                  textAlign: TextAlign.left)),
        ],
      ),
    );
  }
}
