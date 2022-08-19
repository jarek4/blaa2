import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/domain/repository/demo_words_repository_i.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// A Mock DemoWordsRepositoryI class
class MockDemoWordsRepositoryI<Word> extends Mock
    implements DemoWordsRepositoryI<Word> {}

void main() {
  EquatableConfig.stringify = true;
  late MockDemoWordsRepositoryI<Word> dwR;
  tearDown(() {});
  group('DemoWordsRepositoryI<Word> should', () {
    setUp(() {
      dwR = MockDemoWordsRepositoryI();
    });
    test('return List<Word> when getDemoWords()', () {
      // arrange
      when(() => dwR.getDemoWords()).thenReturn(<Word>[]);
      // act
      const List _empty = <Word>[];
      // assert
      expect(_empty, dwR.getDemoWords());
      verify(() => dwR.getDemoWords()).called(1);
    });
  });
}
