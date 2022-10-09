import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  final String _dbName = 'lycle.db';
  Database? db;

  bool _isInitialized = false;

  get isInitialized => _isInitialized;

  DBHelper._internal();

  factory DBHelper() => DBHelper._internal();

  Future<void> init(String tableName, List columns) async {
    if (!isInitialized) {
      String statement = 'CREATE TABLE IF NOT EXISTS $tableName (';

      for (Map<String, dynamic> column in columns) {
        if (column == columns.last) {
          column.forEach((key, value) {
            statement += ' $key $value)';
          });
        } else {
          column.forEach((key, value) {
            statement += ' $key $value,';
          });
        }
      }

      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, _dbName);

      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db
            .execute(statement..trim().replaceAll(RegExp(r'[\s]{2,}'), ' '));
      }, onOpen: (Database db) async {
        await db
            .execute(statement..trim().replaceAll(RegExp(r'[\s]{2,}'), ' '));
      });
      _isInitialized = true;
    }
  }

  Future<int?> insert(String table, Map<String, dynamic> data) async {
    int? result;

    if (_isInitialized) {
      try {
        result = await db!
            .insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
      } catch (e) {
        print(e);
      }
    }

    return result;
  }

  Future<List<Map<String, dynamic>>?> select(String table,
      {String? where, List? whereArgs}) async {
    List<Map<String, dynamic>>? result;

    if (_isInitialized) {
      try {
        result = await db!.query(table, where: where, whereArgs: whereArgs);
      } catch (e) {
        print(e);
      }
    }

    return result;
  }

  Future<int?> update(String table, Map<String, dynamic> data,
      {String? where, List? whereArgs}) async {
    int? result;

    if (_isInitialized) {
      try {
        result =
            await db!.update(table, data, where: where, whereArgs: whereArgs);
      } catch (e) {
        print(e);
      }
    }

    return result;
  }

  Future<int?> delete(String table, {String? where, List? whereArgs}) async {
    int? result;

    if (_isInitialized) {
      try {
        result = await db!.delete(table, where: where, whereArgs: whereArgs);
      } catch (e) {
        print(e);
      }
    }

    return result;
  }
}
