import 'package:health_kit_reporter/model/type/quantity_type.dart';

import '../../constants/assets.dart';

enum QuestDataType {
  walking('walking', [QuantityType.stepCount], [], "걷기", "회",
      questDirectionsRunSvg),
  running('running', [QuantityType.distanceWalkingRunning], [], "달리기", "km",
      questDirectionsRunSvg),
  wakeUp('wakeUp', [], [], "기상", "회", questAlarmSvg),
  listen('running', [QuantityType.distanceWalkingRunning], [], "듣기", "회",
      questHeadphonesSvg),
  noSuchQuest('noSuchQuest', [], [], null, null, "");

  final String category;
  final List<QuantityType> readTypes;
  final List<QuantityType> writeTypes;
  final String? korean;
  final String? unit;
  final String iconPath;

  const QuestDataType(this.category, this.readTypes, this.writeTypes,
      this.korean, this.unit, this.iconPath);

  factory QuestDataType.getByCategory(String category) =>
      QuestDataType.values.firstWhere((value) => value.category == category,
          orElse: () => QuestDataType.noSuchQuest);
}
