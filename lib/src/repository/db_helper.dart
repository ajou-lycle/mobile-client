import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  final String _dbName = 'lycle.db';
  Database? _db;

  bool _isInitialized = false;

  get isInitialized => _isInitialized;

  DBHelper._internal();

  factory DBHelper() => DBHelper._internal();

  Future<void> init(List<String> statements) async {
    if (!isInitialized) {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, _dbName);

      _db = await openDatabase(path, version: 4,
          onCreate: (Database db, int version) async {
        for (String statement in statements) {
          await db
              .execute(statement..trim().replaceAll(RegExp(r'[\s]{2,}'), ' '));
        }
      });
      _isInitialized = true;
    }
  }

  Future<bool?> execute(String statement) async {
    if (!isInitialized) {
      try {
        await _db?.execute(statement);
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }

    return null;
  }

  Future<int?> insert(String table, Map<String, dynamic> data) async {
    int? result;

    if (_isInitialized) {
      try {
        result = await _db!
            .insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
      } catch (e) {
        print(e);
      }
    }

    return result;
  }

  Future<int?> rawInsert(String insertSql) async {
    int? result;

    if (_isInitialized) {
      try {
        result = await _db!.rawInsert(insertSql);
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
        result = await _db!.query(table, where: where, whereArgs: whereArgs);
      } catch (e) {
        print(e);
      }
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> rawSelect(String selectSql) async {
    late List<Map<String, dynamic>> result;

    if (_isInitialized) {
      try {
        result = await _db!.rawQuery(selectSql);
      } catch (e) {
        // TODO: 에러 처리
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
            await _db!.update(table, data, where: where, whereArgs: whereArgs);
      } catch (e) {
        print(e);
      }
    }

    return result;
  }

  Future<int?> rawUpdate(String updateSql) async {
    int? result;

    if (_isInitialized) {
      try {
        result = await _db!.rawUpdate(updateSql);
      } catch (e) {
        print(e);
      }
    }

    print(result);
    return result;
  }

  Future<int?> delete(String table, Map<String, dynamic> data,
      {String? where, List? whereArgs}) async {
    int? result;

    if (_isInitialized) {
      try {
        result = await _db!.delete(table, where: where, whereArgs: whereArgs);
      } catch (e) {
        print(e);
      }
    }

    return result;
  }

  Future<int?> rawDelete(String deleteSql) async {
    int? result;

    if (_isInitialized) {
      try {
        result = await _db!.rawDelete(deleteSql);
      } catch (e) {
        print(e);
      }
    }

    print(result);
    return result;
  }
}
