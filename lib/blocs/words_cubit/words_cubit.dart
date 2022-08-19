import 'dart:async';

import 'package:blaa/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:blaa/data/model/user_m/user_m.dart';
import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/domain/repository/words_repo_i.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'words_state.dart';

class WordsCubit extends Cubit<WordsState> {
  WordsCubit(this.repository, this._ab) : super(const WordsState()) {
    _authBlocSub = _ab.stream.listen((state) {
      onCurrentUserChanged(state.user);
    });
    _repositorySub = repository.change.listen((event) {
      fetchWords();
    });
  }

  final WordsRepoI<Word> repository;
  final AuthenticationBloc _ab;
  late StreamSubscription<AuthenticationState> _authBlocSub;
  late StreamSubscription<String> _repositorySub;

  @override
  Future<void> close() async {
    repository.dispose();
    _authBlocSub.cancel();
    _repositorySub.cancel();
    return super.close();
  }

// default: email: 'demo@user', id:-1, nativeLang: 'English', langToLearn: 'Polish'
  void onCurrentUserChanged(User? user) {
    print('WordsCubit-onCurrentUserChanged -- user.email: ${user?.email}||user.id: ${user?.id}');
    User currentUser = user ?? const User(id: -1);
    emit(state.copyWith(currentUser: currentUser));
    fetchWords();
  }

  Future<void> fetchWords() async {
    emit(state.copyWith(status: WordsStateStatus.loading));
    print('WordCubit fetchWords() || email: ${state.currentUser.email} ||  id: ${state.currentUser.id}');
    if (state.currentUser.email == 'demo@user') {}
    if (state.currentUser.email == 'demo@user') {
      emit(
        state.copyWith(
          status: WordsStateStatus.failure,
          errorText: 'Error - no access to words list! Try to login again',
          words: [],
        ),
      );
    } else {
      print('WordCubit fetchWords() currentUser.email != demo@user -- else block');
      try {
        List<Word> newState = await repository.getAll(state.currentUser.email);
        emit(state.copyWith(status: WordsStateStatus.success, words: newState));
      } on Exception {
        emit(state.copyWith(status: WordsStateStatus.failure, errorText: 'Error - no access to words list!'));
      }
    }
  }

  Future<void> addNewWord(Word item) async {
    final List<Word> currentState = state.words;
    emit(state.copyWith(status: WordsStateStatus.loading));
    Word newWord = item.copyWith(
      user: state.currentUser.email,
      nativeLang: state.currentUser.nativeLang,
      langToLearn: state.currentUser.langToLearn,
    );
    try {
      // Words Repository will store the word into local database
      Word response = await repository.create(newWord);
      print('WordsCubit addNewWord id: ${response.id} ');
      final List<Word> newState = [response, ...currentState];
      emit(state.copyWith(status: WordsStateStatus.success, words: newState));
    } on Exception {
      print('Added word Exception ');
      emit(state.copyWith(status: WordsStateStatus.failure, errorText: 'Error - word is not added!'));
    }
  }

  void delete(int id) {
    final List<Word> currentState = state.words;
    emit(state.copyWith(status: WordsStateStatus.loading));
    try {
      List<Word> newState = List.of(currentState..removeWhere((e) => e.id == id));
      emit(state.copyWith(status: WordsStateStatus.success, words: newState));
    } on Exception {
      emit(state.copyWith(status: WordsStateStatus.failure, errorText: 'Error - word is not deleted!'));
    }
  }

  Future<int> deleteAll() async {
    emit(state.copyWith(status: WordsStateStatus.loading));
    try {
      print('deleteAll: all words deleted. user: ${state.currentUser.email}');
      final int deletedWordsNumber = await repository.deleteAll(state.currentUser.email);
      print('deleteAll: deletedWordsNumber: $deletedWordsNumber');
      emit(state.copyWith(status: WordsStateStatus.success, words: []));
      return deletedWordsNumber;
    } on Exception {
      emit(state.copyWith(status: WordsStateStatus.failure, errorText: 'Error - words are not deleted!'));
    }
    return 0;
  }

  Future<void> triggerFavorite(int id) async {
    print('WC - triggerFavorite');
    final List<Word> currentState = state.words;
    // final int _itemId = item.id;
    // if word is favored isFavorite = 1, if it is not isFavorite = 0
    try {
      final Word response = await repository.triggerIsFavorite(id);
      List<Word> newState = currentState.take(currentState.length).map((Word i) => i.id == id ? response : i).toList();
      emit(state.copyWith(status: WordsStateStatus.success, words: newState));
    } on Exception {
      emit(state.copyWith(status: WordsStateStatus.failure, errorText: 'Error - favorite words list was NOT updated!'));
    }
  }

  void update(int id, String propertyName, dynamic value) async {
    // final List<Word> _currentState = state.words;
    emit(state.copyWith(status: WordsStateStatus.loading));
    try {
      await repository.rowUpdate(id, propertyName, value);
      List<Word> newState = await repository.getAll(state.currentUser.email);
      emit(state.copyWith(status: WordsStateStatus.success, words: newState));
    } on Exception {
      emit(state.copyWith(status: WordsStateStatus.failure, errorText: 'Error - word is not deleted!'));
    }
  }

  // FILTERING:
  void orderItemsListByCreated(bool isFromOldest) {
    // by default database returns items ordered from the most recent
    final List<Word> st = state.words;
    emit(state.copyWith(status: WordsStateStatus.loading));
    if (isFromOldest) {
      st.sort((a, b) => a.created!.compareTo(b.created!));
    } else {
      st.sort((a, b) => b.created!.compareTo(a.created!));
    }
    emit(state.copyWith(status: WordsStateStatus.success, words: st));
  }

  void toggleShowOnlyFavored(bool isOnlyFavored) {
    emit(state.copyWith(isShowOnlyFavored: isOnlyFavored));
  }
}
