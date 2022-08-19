import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blaa/data/model/word_m/word_m.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  EquatableConfig.stringify = true;
  const Word word1 = Word(inNative: 'english', inTranslation: 'turkish', id: 1);
  // tearDown(() {});
  group('Word default instance', () {
    setUp(() {});
    test('should have an id value of type null', () {
      // arrange
      // act
      // assert
      expect(word1.id, isA<void>());
    });
    test('should have an inNative value of type String', () {
      expect(word1.inNative, isA<String>());
    });
  });
  group('Word fromJson should', () {
    // setUp(() {});
    test('return a valid model', () {
      // arrange
      final Map<String, dynamic> _jsonMap = json.decode(fixture('word.json'));
      // act
      final res = Word.fromJson(_jsonMap);
      // assert
      expect(res, isA<Word>());
    });
    test('return a default points value = 0 ', () {
      // arrange
      final Map<String, dynamic> _jsonMap = json.decode(fixture('word.json'));
      // act
      final res = Word.fromJson(_jsonMap);
      // assert
      expect(res.points, isNot(null));
      expect(res.points, equals(0));
    });
  });
}
