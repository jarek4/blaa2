abstract class UserLocalDatabaseInterface<T> {
  Future<T?> createUser(T newUser);
  Future<void> deleteUser(int userId);
  Future<T?> getUserFromDbByEmail(String userEmail);
  Future<int?> hasCreatedUser(String userEmail, String userPassword);
}