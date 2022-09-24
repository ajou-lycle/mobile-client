import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../api/quest_api.dart';
import '../model/quest.dart';

import 'db_helper.dart';

class QuestRepository {
  final QuestApi _questApi = QuestApi();
  final _tableName = 'Quest';
  final _columns = jsonDecode(dotenv.env['QUEST_TABLE']!);

  List<List<Quest>> _availableQuests = List<List<Quest>>.empty(growable: true);

  DBHelper dbHelper = DBHelper();

  QuestRepository._internal();

  factory QuestRepository() => QuestRepository._internal();

  List<List<Quest>> get availableQuests => _availableQuests;

  Future<void> init() async {
    await dbHelper.init(_tableName, _columns);
    await patchAvailableQuests();
  }

  Future<void> patchAvailableQuests() async =>
      _availableQuests = await _questApi.getAvailableQuest();

  Future<void> insertQuest(Quest quest) async {
    await deleteQuest(quest);
    await dbHelper.insert(_tableName, quest.toDBData());
  }

  Future<void> updateQuest(Quest quest) async =>
      await dbHelper.update(_tableName, quest.toDBData(),
          where: "category = ? AND achieve_date IS NULL",
          whereArgs: [quest.category]);


  Future<void> deleteQuest(Quest quest) async {
    if (quest.achieveDate == null) {
      await dbHelper.delete(_tableName,
          where: "category = ? AND achieve_date IS NULL",
          whereArgs: [quest.category]);

    } else {
      // TODO : 에러 처리
      await dbHelper.delete(_tableName,
          where: "category = ? AND achieve_date = ?",
          whereArgs: [quest.category, quest.achieveDate?.millisecondsSinceEpoch]);
    }
  }

  Future<List<Quest>?> getAll() async {
    final List<Map<String, dynamic>>? data = await dbHelper.select(_tableName);

    // TODO: 에러 처리
    if (data == null || data.isEmpty) {
      return null;
    }

    List<Quest> result = List<Quest>.empty(growable: true);

    for (Map<String, dynamic> tuple in data) {
      result.add(Quest.fromDB(tuple));
    }

    return result;
  }

  Future<List<Quest>> getAllCurrentQuest() async {
    final List<Map<String, dynamic>>? data =
        await dbHelper.select(_tableName, where: "achieve_date IS NULL");

    print(data);
    // TODO: 에러 처리
    // if (data == null || data.isEmpty) {
    //   return null;
    // }

    List<Quest> result = List<Quest>.empty(growable: true);

    for (Map<String, dynamic> tuple in data!) {
      result.add(Quest.fromDB(tuple));
    }

    return result;
  }

  Future<Quest> getCurrentQuest(String category) async {
    final List<Map<String, dynamic>>? data = await dbHelper.select(_tableName,
        where: "category = ? AND achieve_date IS NULL", whereArgs: [category]);

    return Quest.fromDB(data![0]);
  }

  Future<List<Quest>> getAllFinishQuest() async {
    final List<Map<String, dynamic>>? data =
        await dbHelper.select(_tableName, where: 'achieve_date IS NOT NULL');

    // TODO: 에러 처리
    // if (data == null || data.isEmpty) {
    //   return null;
    // }

    List<Quest> result = List<Quest>.empty(growable: true);

    for (Map<String, dynamic> tuple in data!) {
      print(tuple);
      result.add(Quest.fromDB(tuple));
    }

    return result;
  }

  Future<Quest?> getFinishQuest(String category, int level) async {
    final List<Map<String, dynamic>>? data = await dbHelper.select(_tableName,
        where: 'category = ? AND level = ? AND achieve_date IS NOT NULL',
        whereArgs: [category, level]);

    // TODO: 에러 처리
    if (data == null || data.isEmpty) {
      return null;
    }

    return Quest.fromDB(data[0]);
  }
}
