import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/credentials.dart';

import '../api/quest_api.dart';
import '../model/quest.dart';

import 'db_helper.dart';

class QuestRepository {
  final QuestApi _questApi = QuestApi();
  final _tableName = 'QUEST';
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

  Future<void> insertQuest(String ethereumAddress, Quest quest) async {
    final data = quest.toDBData();
    data['wallet_address'] = ethereumAddress;
    await deleteQuest(ethereumAddress, quest);
    await dbHelper.insert(_tableName, data);
  }

  Future<void> updateQuest(
      String ethereumAddress, Quest quest) async =>
      await dbHelper.update(_tableName, quest.toDBData(),
          where: "wallet_address = ? AND category = ? AND achieve_date IS NULL",
          whereArgs: [ethereumAddress, quest.category]);

  Future<void> deleteQuest(String ethereumAddress, Quest quest) async {
    if (quest.achieveDate == null) {
      await dbHelper.delete(_tableName,
          where: "wallet_address = ? AND category = ? AND achieve_date IS NULL",
          whereArgs: [ethereumAddress, quest.category]);
    } else {
      // TODO : 에러 처리
      await dbHelper.delete(_tableName,
          where: "wallet_address = ? AND category = ? AND achieve_date = ?",
          whereArgs: [
            ethereumAddress,
            quest.category,
            quest.achieveDate?.millisecondsSinceEpoch
          ]);
    }
  }

  Future<List<Quest>?> getAll(String ethereumAddress) async {
    final List<Map<String, dynamic>>? data = await dbHelper.select(_tableName,
        where: "wallet_address = ?", whereArgs: [ethereumAddress]);

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

  Future<List<Quest>> getAllCurrentQuest(
      String ethereumAddress) async {
    final List<Map<String, dynamic>>? data = await dbHelper.select(_tableName,
        where: "wallet_address = ? AND achieve_date IS NULL",
        whereArgs: [ethereumAddress]);

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

  Future<Quest> getCurrentQuest(
      String ethereumAddress, String category) async {
    final List<Map<String, dynamic>>? data = await dbHelper.select(_tableName,
        where: "wallet_address = ? AND category = ? AND achieve_date IS NULL",
        whereArgs: [ethereumAddress, category]);

    return Quest.fromDB(data![0]);
  }

  Future<List<Quest>> getAllFinishQuest(String ethereumAddress) async {
    final List<Map<String, dynamic>>? data = await dbHelper.select(_tableName,
        where: 'wallet_address = ? AND achieve_date IS NOT NULL',
        whereArgs: [ethereumAddress]);

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

  Future<Quest?> getFinishQuest(
      String ethereumAddress, String category, int level) async {
    final List<Map<String, dynamic>>? data = await dbHelper.select(_tableName,
        where:
            'wallet_address = ? AND category = ? AND level = ? AND achieve_date IS NOT NULL',
        whereArgs: [ethereumAddress, category, level]);

    // TODO: 에러 처리
    if (data == null || data.isEmpty) {
      return null;
    }

    return Quest.fromDB(data[0]);
  }
}
