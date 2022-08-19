part of 'words_cubit.dart';

enum WordsStateStatus { loading, success, failure}

class WordsState extends Equatable {
  const WordsState({
    this.words = const <Word>[],
    this.isShowOnlyFavored = false,
    this.status = WordsStateStatus.loading,
    this.errorText,
    this.currentUser = const User(id: -1),
    // this.currentUser,
  });

  final List<Word> words;
  final bool isShowOnlyFavored;
  final WordsStateStatus status;
  final String? errorText;
  final User currentUser;

  WordsState copyWith({
    List<Word>? words,
    bool? isShowOnlyFavored,
    WordsStateStatus? status,
    String? errorText,
    User? currentUser,
  }) {
    return WordsState(
      words: words ?? this.words,
      isShowOnlyFavored: isShowOnlyFavored ?? this.isShowOnlyFavored,
      status: status ?? this.status,
      errorText: errorText ?? this.errorText,
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  List<Object?> get props => [currentUser, errorText, words, isShowOnlyFavored, status];
}

/*
class WordsState extends Equatable {
  const WordsState._({
    this.words = const <Word>[],
    this.status = WordsStateStatus.loading,
    this.errorText,
    this.currentUser = const User(),
  });

  final List<Word> words;
  final WordsStateStatus status;
  final String? errorText;
  final User currentUser;

  const WordsState.loading() : this._();

  const WordsState.success(List<Word> i)
      : this._(status: WordsStateStatus.success, words: i);

  const WordsState.failure(String? message)
      : this._(status: WordsStateStatus.failure, errorText: message);

  @override
  List<Object?> get props => [currentUser, errorText, words, status];
}
 */
