/*
import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/ui/screens/exercise_correct_answer_screen/quiz/option.dart';
import 'package:blaa/ui/screens/exercise_correct_answer_screen/quiz/question.dart';
import 'package:flutter/material.dart';

class Quiz {
  Quiz({required this.user,
    required this.words,
    required this.currentUserWordsIds,
    required this.notPlayedIds,
    required this.options,
    required this.question,
    this.wordPoints = 5,
    this.gamePoints = 0,
    required this.successId,
    required this.optionsIds,
    this.attempts = 0,
    this.didUserGuess = false,
    this.isClueShown = false});

  final User user;
  final List<Word> words;
  late List<int> currentUserWordsIds = words.map((e) => e.id).toList();
  late List<int> notPlayedIds = currentUserWordsIds;
  late List<Option> options = _makeOptions(words);
  final Question question;
  final int wordPoints;
  final int gamePoints;
  final int successId;
  final List<int> optionsIds;
  final int attempts;
  final bool didUserGuess;
  final bool isClueShown;


  List<Option> _makeOptions(List<Word> words) {
    List<Option> options = words.map((e) => Option(text: e.inTranslation, wordId: e.id)).toList();
    return options;
  }

  @override
  String toString() {
    return 'Quiz:\n currentUserWordsIds: $currentUserWordsIds,\n options: $options,\n successId: $successId,\n optionsIds: $optionsIds,\n attempts: $attempts, \n didUserGuess: $didUserGuess';
  }

  @override
  operator ==(other) =>
      other is Quiz &&
          other.user == user &&
          other.words == words &&
          other.currentUserWordsIds == currentUserWordsIds &&
          other.notPlayedIds == notPlayedIds &&
          other.options == options &&
          other.question == question &&
          other.successId == successId &&
          other.optionsIds == optionsIds &&
          other.wordPoints == wordPoints &&
          other.gamePoints == gamePoints &&
          other.attempts == attempts &&
          other.didUserGuess == didUserGuess &&
          other.isClueShown == isClueShown;

  @override
  int get hashCode =>
      hashValues(
        user,
        hashList(words),
        hashList(currentUserWordsIds),
        hashList(notPlayedIds),
        hashList(options),
        question,
        wordPoints,
        gamePoints,
        successId,
        optionsIds,
        attempts,
        didUserGuess,
        isClueShown,
      );
}*/
