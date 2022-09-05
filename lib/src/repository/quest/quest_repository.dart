import 'package:lycle/src/repository/db_helper.dart';

abstract class QuestRepository {
  final _statement = '''CREATE TABLE CurrentQuest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        level INTEGER,
        success_token_cnt INTEGER,
        start_date TIMESTAMP,
        achievement TEXT 
    )'''
      .trim()
      .replaceAll(RegExp(r'[\s]{2,}'), ' ');

  DBHelper dbHelper = DBHelper();

  Future<void> init() async => await dbHelper.init(_statement);
}
