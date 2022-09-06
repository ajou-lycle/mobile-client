import 'dart:convert';

import 'package:lycle/src/repository/db_helper.dart';
import 'package:lycle/src/repository/quest/quest_api.dart';

import '../../data/model/quest.dart';

class QuestRepository {
  final QuestApi _questApi = QuestApi();
  final _tableName = 'Quest';
  final _statement = '''CREATE TABLE Quest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        level INTEGER NOT NULL,
        need_token INTEGER NOT NULL,
        reward_token INTEGER NOT NULL,
        start_date TIMESTAMP NOT NULL,
        finish_date TIMESTAMP NOT NULL,
        achieve_date TIMESTAMP,
        goal TEXT NOT NULL,
        achievement TEXT NOT NULL)''';
  List<List<Quest>> _availableQuests = List<List<Quest>>.empty(growable: true);

  DBHelper dbHelper = DBHelper();

  QuestRepository._internal();

  factory QuestRepository() => QuestRepository._internal();

  List<List<Quest>> get availableQuests => _availableQuests;

  Future<void> init() async {
    await dbHelper.init([_statement]);
    await patchAvailableQuests();
    print(dbHelper.isInitialized);
  }

  Future<void> patchAvailableQuests() async =>
      _availableQuests = await _questApi.getAvailableQuest();

  Future<void> insertQuest(Quest quest) async {
    // TODO : 에러 처리
    await dbHelper.rawInsert('''
    INSERT INTO $_tableName (category, level, need_token, reward_token, start_date, finish_date, achieve_date, goal, achievement)
    VALUES(${quest.toString()})
    ''');
  }

  Future<void> updateQuest(Quest quest) async {
    // TODO : 에러 처리
    await dbHelper.rawUpdate('''
    UPDATE $_tableName SET achieve_date = ${quest.achieveDate} AND achievement = ${quest.achievement}
    WHERE category = "${quest.category} AND level = ${quest.level} AND start_date = ${quest.startDate}
    ''');
  }

  Future<void> deleteQuest(Quest quest) async {
    await dbHelper.rawDelete('''
    DELETE FROM $_tableName 
    WHERE category = "${quest.category} AND level = ${quest.level} AND start_date = ${quest.startDate}
    ''');
  }

  Future<List<Quest>?> getAll() async {
    final List<Map<String, dynamic>>? data =
        await dbHelper.rawSelect("SELECT * FROM $_tableName");

    // TODO: 에러 처리
    if (data == null || data.isEmpty) {
      return null;
    }

    List<Quest> result = List<Quest>.empty(growable: true);

    for (Map<String, dynamic> tuple in data) {
      result.add(Quest.fromJson(tuple));
    }

    return result;
  }

  Future<List<Quest>> getAllCurrentQuest() async {
    final List<Map<String, dynamic>> data = await dbHelper
        .rawSelect('SELECT * FROM $_tableName WHERE finish_date IS NULL');

    // TODO: 에러 처리
    // if (data == null || data.isEmpty) {
    //   return null;
    // }

    List<Quest> result = List<Quest>.empty(growable: true);

    for (Map<String, dynamic> tuple in data) {
      result.add(Quest.fromJson(tuple));
    }

    return result;
  }

  Future<Quest> getCurrentQuest(String category) async {
    final List<Map<String, dynamic>>? data = await dbHelper.rawSelect(
        'SELECT * FROM $_tableName WHERE category = "$category" AND finish_date IS NULL');

    print(data);
    // TODO: 에러 처리

    return Quest.fromJson(data![0]);
  }

  Future<List<Quest>?> getAllFinishQuest() async {
    final List<Map<String, dynamic>>? data = await dbHelper
        .rawSelect('SELECT * FROM $_tableName WHERE finish_date IS NOT NULL');

    // TODO: 에러 처리
    if (data == null || data.isEmpty) {
      return null;
    }

    List<Quest> result = List<Quest>.empty(growable: true);

    for (Map<String, dynamic> tuple in data) {
      result.add(Quest.fromJson(tuple));
    }

    return result;
  }

  Future<Quest?> getFinishQuest(String category, int level) async {
    final List<Map<String, dynamic>>? data = await dbHelper.rawSelect(
        'SELECT * FROM $_tableName WHERE category = "$category" AND level = $level AND finish_date IS NOT NULL');

    // TODO: 에러 처리
    if (data == null || data.isEmpty) {
      return null;
    }

    return Quest.fromJson(data[0]);
  }
}
