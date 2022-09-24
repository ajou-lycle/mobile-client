import 'package:flutter/material.dart';

class RowWidgetListWithDivider extends StatelessWidget {
  final List<Widget> widgetList;
  final VerticalDivider verticalDivider;

  const RowWidgetListWithDivider(
      {Key? key, required this.widgetList, required this.verticalDivider})
      : super(key: key);

  List<Widget> generateWidgetList() {
    List<Widget> rowWidgetListWithDivider = List<Widget>.empty(growable: true);

    for (Widget widget in widgetList) {
      rowWidgetListWithDivider.add(widget);

      if (widgetList.last != widget) {
        rowWidgetListWithDivider.add(verticalDivider);
      }
    }

    return rowWidgetListWithDivider;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: generateWidgetList());
  }
}
