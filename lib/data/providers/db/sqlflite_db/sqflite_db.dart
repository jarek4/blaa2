// ignore_for_file: avoid_print
import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/data/providers/db/db_interface/user_local_database_interface.dart';
import 'package:blaa/data/providers/db/db_interface/words_local_database_interface.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_constants/db_constants.dart';

class SqfliteDb implements WordsLocalDatabaseInterface, UserLocalDatabaseInterface<Map<String, dynamic>> {
  static final SqfliteDb instance = SqfliteDb._init();
  static Database? _db;

  SqfliteDb._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('blaa.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    print('SqfliteDb _initDB');
    final String _dbPath = await getDatabasesPath();
    final _path = join(_dbPath, filePath);
    return await openDatabase(_path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int ver) async {
    await db.execute(DbConst.createWordsTableStatement);
    await db.execute(DbConst.createUsersTableStatement);
  }

  @override
  Future<Map<String, dynamic>?> createUser(Map<String, dynamic> newUser) async {
    // prevent creating multiple users with the same email
    final String _email = newUser["email"] ?? 'noUser';
    if (await _didUserExistsInDb(_email)) {
      throw Exception('User with this email: $_email already exists');
    }
    try {
      final Database _db = await instance.database;
      // newUser.created.toIso861String(); if there is a DateTime
      final int _id = await _db.insert(DbConst.tableUsers, newUser);
      print('SqfliteDb user with id: $_id created');
      const List<String> _allColumns = DbConst.allUsersColumns;
      final List<Map<String, dynamic>> _res = await _db.query(DbConst.tableUsers,
          columns: _allColumns, where: '${DbConst.fUId} = ?', whereArgs: [_id], limit: 1);
      return _res.first;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserFromDbByEmail(String userEmail) async {
    Map<String, dynamic>? _response;

    try {
      final Database _db = await instance.database;
      const List<String> _allColumns = DbConst.allUsersColumns;
      final List<Map<String, Object?>> _res = await _db.query(DbConst.tableUsers,
          columns: _allColumns, where: '${DbConst.fUEmail} = ?', whereArgs: [userEmail], limit: 1);
      if (_res.isNotEmpty) {
        _response = _res.first;
        print('SqfliteDb getUserFromDbByEmail: $userEmail. Response id: ${_res.first["id"]}');
      }
      return _response;
    } catch (e) {
      throw Exception(e);
    }
  }

// for login:
  @override
  Future<int?> hasCreatedUser(String userEmail, String userPassword) async {
    int? _response;
    try {
      final Database db = await instance.database;
      const List<String> _allColumns = [DbConst.fUId];
      final List<Map<String, Object?>> res = await db.query(DbConst.tableUsers,
          columns: _allColumns,
          where: '${DbConst.fUEmail} = ? AND ${DbConst.fUPassword} = ?',
          whereArgs: [userEmail, userPassword]);
      if (res.isNotEmpty) {
        _response = User.fromJson(res.first).id;
      }
      return _response;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteUser(int userId) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  // check if user with given email already exists in database
  Future<bool> _didUserExistsInDb(String email) async {
    bool _response = false;
    try {
      final Database db = await instance.database;
      const List<String> _columns = [DbConst.fUId];
      final List<Map<String, Object?>> res =
          await db.query(DbConst.tableUsers, columns: _columns, where: '${DbConst.fUEmail} = ?', whereArgs: [email]);
      if (res.isNotEmpty) {
        _response = true;
      }
      return _response;
    } catch (e) {
      throw Exception(e);
    }
  }

  // ------- words -----------

  @override
  Future<Map<String, dynamic>> createWord(Map<String, dynamic> newWord) async {
    // remove id value for database autoincrement:
    // it should be removed by WordsRepository
    if (newWord['id'] != null) {
      newWord.removeWhere((key, value) => key == 'id');
      // newWord.update('id', (value) => 0);
      // int? _removed = newWord.remove("id");
    }
    try {
      final Database _db = await instance.database;
      final int _id = await _db.insert(DbConst.tableWords, newWord, conflictAlgorithm: ConflictAlgorithm.replace);
      print('SqfliteDb createWord id: $_id ');
      final List<Map<String, dynamic>> _res = await _db.query(DbConst.tableWords,
          columns: DbConst.allWordsColumns, where: '${DbConst.fWId} = ?', whereArgs: [_id], limit: 1);
      final Map<String, dynamic> _resFirst = _res.first;
      return _resFirst;
    } catch (e) {
      print(e.toString());
      throw Exception('Data was not saved into database');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getWords(String userEmail) async {
    try {
      final Database db = await instance.database;
      const List<String> _allColumns = DbConst.allWordsColumns;
      final List<Map<String, dynamic>> _res = await db.query(
        DbConst.tableWords,
        columns: _allColumns,
        where: '${DbConst.fWUser} = ?',
        whereArgs: [userEmail],
        // DESC sorts the result downward - the newest first
        orderBy: '${DbConst.fWCreated} DESC',
      );
      return _res;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getSingle(int id) async {
    // Word.user is a String !!!!
    try {
      final Database db = await instance.database;
      const List<String> _allColumns = DbConst.allWordsColumns;
      final List<Map<String, dynamic>> _res =
          await db.query(DbConst.tableWords, columns: _allColumns, where: '${DbConst.fWId} = ?', whereArgs: [id]);
      Map<String, dynamic> _singleWord = _res.first;
      return _singleWord;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<int> deleteAllWords(String userId) async {
    // in Word model user is String type. User is identified by email
    print('DB - deleteAllWords-> userId: $userId');
    try {
      final Database db = await instance.database;
      final int deletedItems = await db.delete(DbConst.tableWords, where: '${DbConst.fWUser} = ?', whereArgs: [userId]);
      print('DB - deleteAllWords: All $deletedItems words are deleted from DB');
      return deletedItems;
    } catch (e) {
      print('Words not deleted. Error: $e');
      return 0;
    }
  }

  @override
  Future<void> deleteWord(int wordId) async {
    try {
      final Database db = await instance.database;
      await db.delete(DbConst.tableWords, where: '${DbConst.fWId} = ?', whereArgs: [wordId]);
    } catch (e) {
      print('word id: $wordId was not deleted. Error: $e');
    }
    print('word id: $wordId was deleted from DB');
  }

  @override
  Future<Map<String, dynamic>> triggerIsFavorite(int wordId) async {
    late Map<String, dynamic> _response;
    try {
      final Database db = await instance.database;
      final List<Map<String, dynamic>> _res = await db.query(DbConst.tableWords,
          columns: DbConst.allWordsColumns, where: '${DbConst.fWId} = ?', whereArgs: [wordId]);
      Map<String, dynamic> _firstItem = _res.first;
      _response = _firstItem;
      final int _wordIsFavorite = _firstItem["isFavorite"];
      // fWIsFavorite = 'isFavorite' [int]
      // reverse isFavorite field -> isFavorite == 1 ? 0 : 1
      final int _isFavoriteReversed = _wordIsFavorite == 0 ? 1 : 0;
      final Map<String, dynamic> _newItem = {"isFavorite": _isFavoriteReversed};
      // update database:
      await db.update(DbConst.tableWords, _newItem,
          where: '${DbConst.fWId} = ?', whereArgs: [wordId], conflictAlgorithm: ConflictAlgorithm.ignore);
      /*String _updateSql =
          "UPDATE ${DbConst.tableWords} SET ${DbConst.fWIsFavorite} = ? WHERE ${DbConst.fWId} = ?";
      int resp = await db.rawUpdate(_updateSql, [_isFavoriteReversed, wordId]);*/
      final List<Map<String, dynamic>> _updatedRes = await db.query(
        DbConst.tableWords,
        columns: DbConst.allWordsColumns,
        where: '${DbConst.fWId} = ?',
        whereArgs: [wordId],
        orderBy: '${DbConst.fWCreated} DESC',
      );
      print('word id: $wordId ( $_wordIsFavorite ) was triggerIsFavorite to ( $_isFavoriteReversed ) into DB');
      _response = _updatedRes.first;
      return _response;
    } catch (e) {
      print('word id: $wordId was not triggerIsFavorite. Error: $e');
      throw Exception(e);
    }
  }

  @override
  Future close() async {
    final Database _db = await instance.database;
    print('SqfliteDb db closed');
    _db.close();
  }

  @override
  Future<int> updateWord(int wordId, Map<String, dynamic> item) async {
    try {
      final Database _db = await instance.database;
      int _resp = await _db.update(DbConst.tableWords, item,
          where: '${DbConst.fWId} = ?', whereArgs: [wordId], conflictAlgorithm: ConflictAlgorithm.ignore);
      return _resp;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<int> rawUpdateWord(int wordId, String column, dynamic value) async {
    try {
      final Database db = await instance.database;
      // const String query = 'UPDATE ${DbConst.tableWords} SET name = ?, value = ? WHERE ${DbConst.fWId} = ?';
      String query = 'UPDATE ${DbConst.tableWords} SET $column = ? WHERE ${DbConst.fWId} = ?';
      int resp = await db.rawUpdate(query, [value, wordId]);
      print('SqfliteDb rawUpdateWord resp: $resp');
      return resp;
    } catch (e) {
      throw Exception(e);
    }
  }
}
