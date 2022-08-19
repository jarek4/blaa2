import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/data/providers/db/sqlflite_db/sqflite_db.dart';
import 'package:blaa/domain/repository/user_repo_i.dart';
import 'package:meta/meta.dart';

// implementation
// query the current user from the backend
class UserRepo implements UserRepoI<User> {
  static final UserRepo _inst = UserRepo._();

  static User? _user;

  final _db = SqfliteDb.instance;

  UserRepo._();

  factory UserRepo() {
    return _inst;
  }

  // for Singleton class tests reason
  @visibleForTesting
  Future<void> userForTest(User? val) => Future(() => _user = val);

  @override
  Future<User?> get user => Future(() => _user);

  @override
  Future<User?> getUser(String email) async {
    User? _res;
    try {
      Map<String, dynamic>? _userFromDb = await _db.getUserFromDbByEmail(email);
      if (_userFromDb != null) {
        _res = User.fromJson(_userFromDb);
      }
      return _user = _res;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<User?> getUserWithEmailAndPassword(
      String email, String password) async {
    User? _res;
    // check in DB if there is a user with given credentials
    try {
      Map<String, dynamic>? _userFromDb = await _db.getUserFromDbByEmail(email);
      if (_userFromDb != null) {
        _res = User.fromJson(_userFromDb);
      }
      return _user = _res;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<int?> createUser(User newUser) async {
    int? _createdUseId;
    String _timeStamp = DateTime.now().toIso8601String();
    User _userNoId = newUser.copyWith(id: null, created: _timeStamp);
    Map<String, dynamic> _json = _userNoId.toJson();
    try {
      Map<String, dynamic>? _userFromDb = await _db.createUser(_json);
      if (_userFromDb != null) {
        _user = User.fromJson(_userFromDb);
        _createdUseId = _user?.id;
      }
      return _createdUseId;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<int?> removeUser(int id) {
    // TODO: implement removeUser
    throw UnimplementedError();
    // returns removed user id or null if error
  }

  // handle logIn
  // when login bloc is submitted - calls authRepo login()
  @override
  Future<int?> loginUserWithEmailPassword(String email, String password) async {
    int? _id;
    // check in DB if there is a user with given credentials
    // if DB has the user hasCreatedUser() returns the id or null
    try {
      _id = await _db.hasCreatedUser(email, password);
      print('User repo - login: userId: $_id');
      if (_id != null) {
        // fetch user data from Db and set static User? _user;
        await getUser(email);
      }
      return _id;
    } catch (e) {
      print('User repo - login: exception was thrown');
      throw Exception(e);
    }
  }
}
