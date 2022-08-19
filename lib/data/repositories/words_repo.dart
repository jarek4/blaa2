import 'dart:async';

import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/data/providers/db/db_interface/words_local_database_interface.dart';
import 'package:blaa/domain/repository/words_repo_i.dart';
import 'package:blaa/locator.dart';

class WordsRepo implements WordsRepoI<Word> {
  // WordsRepo(this.database);

  final WordsLocalDatabaseInterface _database =
      locator<WordsLocalDatabaseInterface>();

  // final _ctr = StreamController<String>();
  // gives error: Unhandled Exception: Bad state: Stream has already been listened to.
  // WordsRepo.change (:24:5) | new WordsCubit.<anonymous closure> (17:47
// broadcast doesn't emit old events. BehaviorSubject from rxdart does. || myStream.asBroadcastStream
  final _ctr = StreamController<String>.broadcast();

  @override
  Stream<String> get change async* {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    yield '';
    yield* _ctr.stream;
  }

  @override
  Future<Word> create(Word item) async {
    // word item has fields: category, clue, inNative, and inTranslation given from Form,
    // and fields: langToLearn and nativeLang and user (email) given from Authentication Bloc
    // Word object do not have properties: created
    // WordsRepo has to set created
    // before that word.id is set from Date() in AddNewWord and it has to be removed !
    // id need to be set and auto increment by database
    Word _noIdItem = item.copyWith(
      // id: null,
      created: _makeTimeStamp(),
      clue: item.clue != '' ? item.clue : null,
      category: item.category != '' ? item.category : null,
    );
    Map<String, dynamic> _json = _noIdItem.toJson();
    // remove "id" so database will can autoincrement it!
    _json.remove("id");
    Map<String, dynamic> _res = await _database.createWord(_json);
    _ctr.add('create');
    Word _item = Word.fromJson(_res);
    return _item;
  }

  @override
  Future<void> delete(int id) async {
    // Future.delayed(const Duration(microseconds: 20),
    //     () => print('word id: $id was deleted'));
    await _database.deleteWord(id);
    _ctr.add('delete');
  }

  @override
  Future<int> deleteAll(String email) async {
    int resp = await _database.deleteAllWords(email);
    _ctr.add('deleteAll');
    return resp;
  }

  @override
  Future<void> update(Word item) async {
    final int _id = item.id;
    final Map<String, dynamic> _json = item.toJson();
    await _database.updateWord(_id, _json);
    _ctr.add('update');
  }

  @override
  Future<void> rowUpdate(int id, String property, dynamic value) async {
    print('WordsRepo rawUpdate, value: $value');
    await _database.rawUpdateWord(id, property, value);
    _ctr.add('update');
  }

  @override
  Future<List<Word>> getAll(String email) async {
    List<Word> _allWords = [];
    final List<Map<String, dynamic>> _jsonResponse =
        await _database.getWords(email);
    if (_jsonResponse.isNotEmpty) {
      _allWords =
          _jsonResponse.map((element) => Word.fromJson(element)).toList();
    }
    // _ctr.add('getAll');
    return _allWords;
  }

  @override
  Future<List<Word>> search(String query, int userId) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<Word> triggerIsFavorite(int id) async {
    Map<String, dynamic> _response = await _database.triggerIsFavorite(id);
    _ctr.add('triggerIsFavorite');
    return Word.fromJson(_response);
  }

  String _makeTimeStamp() => DateTime.now().toIso8601String();

  @override
  void dispose() => _ctr.close();
}
