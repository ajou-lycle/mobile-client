import 'package:health_kit_reporter/model/type/quantity_type.dart';

enum QuestDataType {
  walking('walking', QuantityType.stepCount),
  running('running', QuantityType.distanceWalkingRunning),
  noSuchQuest('noSuchQuest', null);

  final String category;
  final QuantityType? type;

  const QuestDataType(this.category, this.type);

  factory QuestDataType.getByCategory(String category) =>
      QuestDataType.values.firstWhere((value) => value.category == category,
          orElse: () => QuestDataType.noSuchQuest);
}
