abstract class DemoWordsRepositoryI<T> {
  List<T> getDemoWords();
  Future<void> update(T item);
  Future<void> delete(int itemId);
  // T getSingle();

}