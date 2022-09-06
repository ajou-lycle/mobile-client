import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:lycle/src/data/enum/quest_data_type.dart';

class Quest {
  String category;
  int level;
  int needToken;
  int rewardToken;
  DateTime startDate;
  DateTime finishDate;
  DateTime? achieveDate;
  int goal;
  int times;
  int achievement;
  late QuantityType? type;

  Quest(
      {required this.category,
      required this.level,
      required this.needToken,
      required this.rewardToken,
      required this.startDate,
      required this.finishDate,
      required this.goal,
      required this.times,
      required this.achievement}) {
    type = QuestDataType.getByCategory(category).type;
  }

  Quest.clone(Quest quest)
      : this(
            category: quest.category,
            level: quest.level,
            needToken: quest.needToken,
            rewardToken: quest.rewardToken,
            startDate: quest.startDate,
            finishDate: quest.finishDate,
            goal: quest.goal,
            times: quest.times,
            achievement: quest.achievement);

  Quest.fromJson(Map<String, dynamic> json)
      : category = json['category'],
        level = json['level'],
        needToken = json['needToken'],
        rewardToken = json['rewardToken'],
        startDate = DateTime.parse(json['startDate']),
        finishDate = DateTime.parse(json['finishDate']),
        achieveDate = DateTime.parse(json['achieveDate']),
        goal = json['goal'],
        times = json['times'],
        achievement = json['achievement'];

  Map<String, dynamic> toJson() => {
        'category': category,
        'level': level,
        'needToken': needToken,
        'rewardToken': rewardToken,
        'startDate': startDate,
        'finishDate': finishDate,
        'achieveDate': achieveDate,
        'goal': goal,
        'times': times,
        'achievement': achievement
      };

  @override
  String toString() {
    return '''
    "$category", 
    $level,
    $needToken,
    $rewardToken,
    $startDate,
    $finishDate,
    $achieveDate,
    $goal,
    $times,
    $achievement
    ''';
  }
}
