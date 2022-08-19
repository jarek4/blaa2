part of 'quiz_cubit.dart';

class QuizState extends Equatable {
  const QuizState(
      {required this.currentUserWordsIds,
      required this.inGameWords,
      required this.notPlayedIds,
      required this.question,
      required this.options,
      required this.guessingWordPoints,
      required this.successId,
      required this.words,
      this.attempts = 0,
      this.didUserGuess = false,
      this.gamePoints = 0,
      this.isClueOpen = false,
      this.isClueShown = false,
      this.isLocked = false,
      this.roundPoints = 5});

  final List<Word> words;
  final List<int> currentUserWordsIds;
  final List<int> notPlayedIds;
  final List<Word> inGameWords;
  final Question question;
  final List<Option> options;
  final int guessingWordPoints;
  final int successId;
  final int attempts;
  final bool didUserGuess;
  final int gamePoints;
  final bool isClueOpen;
  final bool isClueShown;
  final bool isLocked;
  final int roundPoints;

  QuizState copyWith({
      List<Word>? words,
      List<int>? currentUserWordsIds,
      List<int>? notPlayedIds,
      List<Word>? inGameWords,
      Question? question,
      List<Option>? options,
      int? guessingWordPoints,
      int? gamePoints,
      int? successId,
      int? attempts,
      bool? didUserGuess,
      bool? isClueOpen,
      bool? isClueShown,
      bool? isLocked,
      int? roundPoints}) {
    return QuizState(
      words: words ?? this.words,
      currentUserWordsIds: currentUserWordsIds ?? this.currentUserWordsIds,
      notPlayedIds: notPlayedIds ?? this.notPlayedIds,
      inGameWords: inGameWords ?? this.inGameWords,
      question: question ?? this.question,
      options: options ?? this.options,
      guessingWordPoints: guessingWordPoints ?? this.guessingWordPoints,
      gamePoints: gamePoints ?? this.gamePoints,
      successId: successId ?? this.successId,
      attempts: attempts ?? this.attempts,
      didUserGuess: didUserGuess ?? this.didUserGuess,
      isClueOpen: isClueOpen ?? this.isClueOpen,
      isClueShown: isClueShown ?? this.isClueShown,
      isLocked: isLocked ?? this.isLocked,
      roundPoints: roundPoints ?? this.roundPoints,
    );
  }

  @override
  List<Object> get props => [
        attempts,
        didUserGuess,
        currentUserWordsIds,
        gamePoints,
        inGameWords,
        isClueOpen,
        isClueShown,
        isLocked,
        notPlayedIds,
        options,
        question,
        roundPoints,
        guessingWordPoints,
        successId,
        words,
      ];
}

/*
class QuizState extends Equatable {
  QuizState(this.user, this.words, this.wordPoints);

  final User user;
  final List<Word> words;
  late List<int> currentUserWordsIds = words.map((e) => e.id).toList();
  late List<int> notPlayedIds = currentUserWordsIds;
  // late List<int> question = [Random().nextInt(currentUserWordsIds.length)];
  late List<int> question = (notPlayedIds.toList()..shuffle()).getRange(0, 3).toList();
  final int wordPoints;
  final int gamePoints = 5;
  late int successId = question[0];
  late List<int> optionsIds = question.getRange(1, 3).toList();
  final int attempts = 0;
  final bool didUserGuess = false;
  final bool isClueShown = false;

  QuizState copyWith({
    User? user,
    List<Word>? words,
    int? wordPoints
  }) {
    return QuizState(user ?? this.user, words ?? this.words, wordPoints ?? this.wordPoints);
  }
 */
