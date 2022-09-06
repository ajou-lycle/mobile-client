import 'package:flutter/material.dart';

class AchieveBar extends StatelessWidget {
  final double value;

  AchieveBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: LinearProgressIndicator(value: value)),
        Text("${value * 100 ~/ 1}%")
      ],
    );
  }
}
