import 'package:blaa/blocs/words_cubit/words_cubit.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/ui/screens/exercise_correct_answer_screen/quiz/option.dart';
import 'package:blaa/ui/screens/exercise_correct_answer_screen/quiz/question.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit(this.wordsCubit, this.inGameWords)
      : super(QuizState(
          words: wordsCubit.state.words,
          currentUserWordsIds: wordsCubit.state.words.map((e) => e.id).toList(),
          inGameWords: inGameWords,
          guessingWordPoints: inGameWords.isEmpty ? -1 : inGameWords[0].points,
          notPlayedIds:
              wordsCubit.state.words.map((e) => e.id).where((element) => element != inGameWords[0].id).toList(),
          question: Question(inGameWords: inGameWords.isEmpty ? [] : inGameWords),
          options: _makeOptions(inGameWords.isEmpty ? [] : inGameWords),
          successId: inGameWords.isEmpty ? -1 : inGameWords[0].id,
        )) {
    // _wordsCubitSub = wordsCubit.stream.listen((state) {
    //   onWordsCubitStateChanged(wordsCubit.state);
    // });
  }

  final WordsCubit wordsCubit;
  final List<Word> inGameWords;

  // late StreamSubscription<WordsState> _wordsCubitSub;

/*  @override
  Future<void> close() async {
    _wordsCubitSub.cancel();
    return super.close();
  }

  void onWordsCubitStateChanged(WordsState wordsCubitState) {
    List<Word> words = wordsCubitState.words;
    if (state.words != words) {
      emit(state.copyWith(words: words));
    }
  }*/

  static List<Option> _makeOptions(List<Word> inGameWords) {
    if(inGameWords.isEmpty) return <Option>[];
    List<Option> options = [];
    Word first = inGameWords[0];
    Option correct = Option(text: first.inTranslation, wordId: first.id, isCorrect: true);
    options.add(correct);
    List<Option> notCorrect = inGameWords.sublist(1).map((e) => Option(text: e.inTranslation, wordId: e.id)).toList();
    options.addAll(notCorrect);
    // options.shuffle();
    return options;
  }

  void onClueDemand() {
    // Takes 2 points only once, regardless how many times was opened/closed, if clue is null don't subtract points!
    if (state.isLocked || state.isClueShown || state.question.clue() == null) {
      _switchClueOpen();
      return;
    }
    final int difference = state.roundPoints - 2;
    emit(
        state.copyWith(isClueShown: true, roundPoints: difference > 0 ? difference : 0, isClueOpen: !state.isClueOpen));
  }

  void _switchClueOpen() {
    emit(state.copyWith(isClueOpen: state.isLocked ? false : !state.isClueOpen));
  }

  void onSelect(Option option) {
    if (state.isLocked) return;
    final bool isCorrect = option.isCorrect;
    final List<Option> updatedOptions = _markOptionAsSelected(option.wordId);
    final int currentAttempts = state.attempts + 1;
    final bool willBeLocked = currentAttempts >= 2 || isCorrect;
    final int calculatedPoints = _calculatePoints(isCorrect, willBeLocked);

    emit(state.copyWith(
      attempts: currentAttempts,
      didUserGuess: isCorrect,
      gamePoints: isCorrect ? (state.gamePoints + calculatedPoints) : state.gamePoints,
      isLocked: willBeLocked,
      isClueOpen: false,
      options: updatedOptions,
      roundPoints: calculatedPoints,
    ));

    if (isCorrect) {
      _onSuccess(option.wordId, calculatedPoints);
    }
  }

  List<Option> _markOptionAsSelected(int id) {
    return state.options.map((e) => e.wordId == id ? e.copyWith(isSelected: true) : e).toList();
  }

  int _calculatePoints(bool isCorrect, bool isToLock) {
    int currentPoints = state.roundPoints;
    //player guessed the first time
    if (isCorrect) return currentPoints;
    if (isToLock) return 0;

    // subtract 2 points (no negative points):
    currentPoints = (currentPoints - 2) > 0 ? (currentPoints - 2) : 0;

    return currentPoints;
  }

  void _onSuccess(int wordId, int scoredWordPoints) {
    // get the word by id, to find out previews words points
    final Word item = state.inGameWords.firstWhere((element) => element.id == wordId);
    final int points = item.points + scoredWordPoints;
    _incrementWordsPointsIntoStorage(wordId, points);
  }

  void _incrementWordsPointsIntoStorage(int id, int points) {
    wordsCubit.update(id, 'points', points);
  }

  void onNext() {
    // check if there are at least 3 ids in state.notPlayedIds
    List<int> notPlayedIds = state.notPlayedIds;
    if (notPlayedIds.length < 3) return;

    // fill up new state.inGameWords
    List<Word> newInGameWords = [];
    final List<int> inGameIds = notPlayedIds.getRange(0, 3).toList();
    for (int x = 0; x < inGameIds.length; x++) {
      newInGameWords.add(state.words.firstWhere((e) => e.id == inGameIds[x]));
    }
    // remove inGameIds[0] - the correct one - from state.notPlayedIds
    List<int> newNotPlayedIds = notPlayedIds.where((e) => e != newInGameWords[0].id).toList();

    emit(state.copyWith(
        attempts: 0,
        didUserGuess: false,
        inGameWords: newInGameWords,
        isClueOpen: false,
        isClueShown: false,
        isLocked: false,
        notPlayedIds: newNotPlayedIds,
        roundPoints: 5,
        question: Question(inGameWords: newInGameWords),
        options: _makeOptions(newInGameWords),
        successId: newInGameWords[0].id));
  }
}
