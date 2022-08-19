import 'package:blaa/data/model/user_m/user_m.dart';

// query the current user from the backend
// user repository interface, domain's contract
abstract class UserRepoI<T> {
  Future<T?> getUser(String email);

  Future<T?> get user;

  // returns created user id
  Future<int?> createUser(T newUser);

  // returns removed user id
  Future<int?> removeUser(int id);

  Future<User?> getUserWithEmailAndPassword(String email, String password);
  // for login
  Future<int?> loginUserWithEmailPassword(String email, String password);
}
