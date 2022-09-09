import 'package:health_kit_reporter/model/type/quantity_type.dart';

enum QuestDataType {
  walking('walking', QuantityType.stepCount, "걷기", "회"),
  running('running', QuantityType.distanceWalkingRunning, "달리기","km"),
  noSuchQuest('noSuchQuest', null, null, null);

  final String category;
  final QuantityType? type;
  final String? korean;
  final String? unit;

  const QuestDataType(this.category, this.type, this.korean, this.unit);

  factory QuestDataType.getByCategory(String category) =>
      QuestDataType.values.firstWhere((value) => value.category == category,
          orElse: () => QuestDataType.noSuchQuest);
}
