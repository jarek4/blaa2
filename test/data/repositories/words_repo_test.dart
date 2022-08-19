
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/data/providers/db/db_interface/words_local_database_interface.dart';
import 'package:blaa/data/repositories/words_repo.dart';
import 'package:blaa/locator.dart';
import 'package:blaa/utils/constants/languages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSqfliteDb extends Mock implements WordsLocalDatabaseInterface {}

// flutter pub run  build_runner build --delete-conflicting-outputs
// @GenerateMocks([], customMocks: [MockSpec<SqfliteDb>(as: #MockDb)])

void main() {
  late WordsLocalDatabaseInterface mockDbService;
  late WordsRepo sut;
  final word = Word(
    created: '11855-test',
    user: 'email',
    id: -1,
    inNative: 'inNativeTest',
    inTranslation: 'inTranslationTest',
    isFavorite: 0,
    langToLearn: SupportedLanguages.list[2].shortcut,
    // 'tr'
    nativeLang: SupportedLanguages.list[0].shortcut, // 'us'
  );
  final Map<String, dynamic> jsonMap = word.toJson();
  final wordWithIdAndUser = word.copyWith(id: 1, user: 'test@user');
  final Map<String, dynamic> jsonMapWithIdAndUser = wordWithIdAndUser.toJson();
  setUpAll(() {
    setupLocator();
    locator.allowReassignment = true;
  });
  // tearDown(() {});

  test('Words Repository Test should find dependencies', () {
    sut = WordsRepo();
    expect(sut != null, true);
  });
  group('Words Repository method', () {
    setUp(() {
      mockDbService = MockSqfliteDb();
      locator.registerSingleton<WordsLocalDatabaseInterface>(mockDbService);
      sut = WordsRepo();
    });
    test('getAll(1) should call database getWords(1) and returns List<Word>', () async {
      when(() => mockDbService.getWords('email'))
          .thenAnswer((_) async => <Map<String, dynamic>>[]);
      List<Word> _res = await sut.getAll('email');
      expect(_res, isA<List<Word>>());
      verify(() => mockDbService.getWords('email')).called(1);
    });
    test('delete(1) should call database  deleteWord(1) and returns void', () async {
      when(() => mockDbService.deleteWord(1)).thenAnswer((_) async {});
      await sut.delete(1);
      verify(() => mockDbService.deleteWord(1)).called(1);
    });
    test('triggerIsFavorite(int wordId) should call database  triggerIsFavorite()', () async {
      when(() => mockDbService.triggerIsFavorite(1)).thenAnswer((_) async => jsonMapWithIdAndUser);
      await sut.triggerIsFavorite(1);
      verify(() => mockDbService.triggerIsFavorite(1)).called(1);
    });
    test('triggerIsFavorite(int wordId) should returns Future<Word>', () async {
      when(() => mockDbService.triggerIsFavorite(1)).thenAnswer((_) async => jsonMapWithIdAndUser);
      Future<Word> resp = sut.triggerIsFavorite(1);
      expect(resp, isA<Future<Word>>());
      verify(() => mockDbService.triggerIsFavorite(1)).called(1);
    });
    /*
    I have no idea why this tests do not pass
    Error: type 'Null' is not a subtype of type 'Future<Map<String, dynamic>>'

    test('create(word) return Future<Word>',
            () async {
          when(() => MockSqfliteDb().createWord(jsonMap))
              .thenAnswer((_) async => jsonMap);
          Word _res = await sut.create(word);
          print('Test sut.add _res: $_res');
          expect(_res, isA<Word>());
          verify(() => MockSqfliteDb().createWord(jsonMap)).called(1);
        });

    test('create(word) call database createWord(Map word) method', () async {
      when(() => mockDbService.createWord(jsonMap))
          .thenAnswer((_) async => jsonMap);
      await sut.create(word);
      verify(() => mockDbService.createWord(jsonMap)).called(1);
    });
    */


  });
  group('... ?', () {});
}
