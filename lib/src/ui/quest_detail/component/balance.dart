import 'package:flutter/material.dart';
import 'package:lycle/src/constants/ui.dart';

import '../../../constants/assets.dart';

class QuestDetailBalance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        Container(
          padding: const EdgeInsets.all(kHalfPadding / 2),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(kDefaultRadius)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                    spreadRadius: 0)
              ],
              color: Color(0xffffffff)),
          width: 80,
          child: const Center(
              child: Text(
            "400",
            style: TextStyle(
                color: Color(0xff7e7e7e),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
          )),
        ),
        Positioned(
            right: 60,
            child: Image.asset(
              questTokenPng,
              height: 44,
              width: 44,
            ))
      ],
    );
  }
}
