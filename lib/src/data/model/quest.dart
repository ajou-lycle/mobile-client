import 'dart:convert';

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
  int needTimes;
  int achievement;
  List<QuantityType> types = List<QuantityType>.empty(growable: true);

  // QuantityType? type;

  Quest(
      {required this.category,
      required this.level,
      required this.needToken,
      required this.rewardToken,
      required this.startDate,
      required this.finishDate,
      required this.goal,
      required this.needTimes,
      required this.achievement}) {
    types = QuestDataType.getByCategory(category).type;
  }

  Quest.clone(Quest quest)
      : category = quest.category,
        level = quest.level,
        needToken = quest.needToken,
        rewardToken = quest.rewardToken,
        startDate = quest.startDate,
        finishDate = quest.finishDate,
        goal = quest.goal,
        needTimes = quest.needTimes,
        achievement = quest.achievement {
    types = QuestDataType.getByCategory(category).type;
  }

  Quest.fromJson(Map<String, dynamic> json)
      : category = json['category'],
        level = json['level'],
        needToken = json['needToken'],
        rewardToken = json['rewardToken'],
        startDate = DateTime.parse(json['startDate']),
        finishDate = DateTime.parse(json['finishDate']),
        achieveDate = json['achieve_date'] == null
            ? null
            : DateTime.parse(json['achieveDate']),
        goal = json['goal'],
        needTimes = json['needTimes'],
        achievement = json['achievement'] {
    types = QuestDataType.getByCategory(category).type;
  }

  Quest.fromDB(Map<String, dynamic> tuple)
      : category = tuple['category'],
        level = tuple['level'],
        needToken = tuple['need_token'],
        rewardToken = tuple['reward_token'],
        startDate = DateTime.fromMillisecondsSinceEpoch(tuple['start_date']),
        finishDate = DateTime.fromMillisecondsSinceEpoch(tuple['finish_date']),
        achieveDate = tuple['achieve_date'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(tuple['achieve_date']),
        goal = tuple['goal'],
        needTimes = tuple['need_times'],
        achievement = tuple['achievement'] {
    types = QuestDataType.getByCategory(category).type;
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'level': level,
        'needToken': needToken,
        'rewardToken': rewardToken,
        'startDate': startDate.toIso8601String(),
        'finishDate': finishDate.toIso8601String(),
        'achieveDate': achieveDate?.toIso8601String(),
        'goal': goal,
        'needTimes': needTimes,
        'achievement': achievement
      };

  Map<String, dynamic> toDBData() => {
        'category': category,
        'level': level,
        'need_token': needToken,
        'reward_token': rewardToken,
        'start_date': startDate.millisecondsSinceEpoch,
        'finish_date': finishDate.millisecondsSinceEpoch,
        'achieve_date': achieveDate?.millisecondsSinceEpoch,
        'goal': goal,
        'need_times': needTimes,
        'achievement': achievement
      };

  @override
  String toString() {
    return '''
    $category, 
    $level,
    $needToken,
    $rewardToken,
    $startDate,
    $finishDate,
    $achieveDate,
    $goal,
    $needTimes,
    $achievement
    '''
        .trim();
  }
}
