import 'dart:async';
abstract class WordsRepoI<T> {
  Future<T> create(T item);
  Future<List<T>> getAll(String userEmail);
  Future<List<T>> search(String query, int userId);
  Future<void> delete(int itemId);
  Future<int> deleteAll(String userEmail);
  Future<T> triggerIsFavorite(int itemId);
  Future<void> update(T item);
  Future<void> rowUpdate(int id, String property, dynamic value);
  Stream<String> get change;
  void dispose();
}