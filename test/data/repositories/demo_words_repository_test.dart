import 'package:blaa/data/repositories/demo_words_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  EquatableConfig.stringify = true;
  late DemoWordsRepo _dwR;
  tearDown(() {});
  group('DemoWordsRepository should', () {
    setUp(() {
      _dwR = DemoWordsRepo();
      // const List _empty = [];
    });
    test('return empty array', () {
      // arrange
      // act
      List _resp = _dwR.getDemoWords();
      // assert
      expect(_resp, []);
    });
  });
}
