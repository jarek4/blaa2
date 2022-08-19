import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/domain/repository/demo_words_repository_i.dart';

class DemoWordsRepo implements DemoWordsRepositoryI<Word> {
// class DemoWordsRepo extends WordsRepoI<Word> {

  List<Word> items = [];

  // tests check to see if it returns an empty array

  @override
  List<Word> getDemoWords() {
    try {
      // ?
      return items;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> update(Word item) async {
    final int _id = item.id;
    if (items.isNotEmpty) {
      List<Word> _newState = items
          .take(items.length)
          .map((Word i) => i.id == _id ? item : i)
          .toList();
      items = _newState;
    }
  }

  @override
  Future<void> delete(int itemId) async {
    if (items.isNotEmpty) {
      List<Word> _newState = List.of(items..removeWhere((e) => e.id == itemId));
      items = _newState;
    }
  }
}
