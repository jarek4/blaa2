import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/domain/repository/demo_words_repository_i.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'demo_state.dart';

class DemoCubit extends Cubit<DemoState> {
  DemoCubit(this.repository) : super(const DemoState.loading());

  final DemoWordsRepositoryI<Word> repository;

  List<Word> _getCurrentDemoState() {
    final List<Word> _currentState = state.words;
    return _currentState;
  }

  void fetchWords() {
    emit(const DemoState.loading());
    try {
      emit(DemoState.success(repository.getDemoWords()));
    } on Exception {
      emit(const DemoState.failure('Something went wrong. Please try again'));
    }
  }

  void addNewWord(Word item) {
    final List<Word> _prevState = _getCurrentDemoState();
    emit(const DemoState.loading());
    Word item2 = item.copyWith(created: DateTime.now().toIso8601String());
    try {
      final List<Word> _newState = [item2, ..._prevState];
      emit(DemoState.success(_newState));
    } on Exception {
      emit(const DemoState.failure('Error - word is not added!'));
    }
  }

  void delete(int id) {
    final List<Word> _currentState = _getCurrentDemoState();
    emit(const DemoState.loading());
    try {
      List<Word> _newState =
          List.of(_currentState..removeWhere((e) => e.id == id));
      emit(DemoState.success(_newState));
    } on Exception {
      emit(const DemoState.failure('Error - word is not deleted!'));
    }
  }

  void triggerFavorite(int id) {
    final List<Word> _currentState = _getCurrentDemoState();
    try {
      List<Word> _newState = _currentState
          .take(_currentState.length)
          .map((Word i) => i.id == id
              ? i.copyWith(isFavorite: i.isFavorite == 0 ? 1 : 0)
              : i)
          .toList();
      emit(DemoState.success(_newState));
    } on Exception {
      emit(const DemoState.failure(
          'Error - word is not added/removed to/from favorite list!'));
    }
  }

  void editInNative(int id, String newValue) {
    final List<Word> _st = state.words;
    try {
      List<Word> _newState = _st
          .take(_st.length)
          .map((Word i) => i.id == id ? i.copyWith(inNative: newValue) : i)
          .toList();
      emit(DemoState.success(_newState));
    } on Exception {
      emit(const DemoState.failure(
          'Error - something went wrong. Try to restart application'));
    }
  }

  void editInTranslation(int id, String newValue) {
    final List<Word> _st = state.words;
    try {
      List<Word> _newState = _st
          .take(_st.length)
          .map((Word i) => i.id == id ? i.copyWith(inTranslation: newValue) : i)
          .toList();
      emit(DemoState.success(_newState));
    } on Exception {
      emit(const DemoState.failure(
          'Error - something went wrong. Try to restart application'));
    }
  }

  void editCategory(int id, String newValue) {
    final List<Word> _st = state.words;
    try {
      List<Word> _newState = _st
          .take(_st.length)
          .map((Word i) => i.id == id ? i.copyWith(category: newValue) : i)
          .toList();
      emit(DemoState.success(_newState));
    } on Exception {
      emit(const DemoState.failure(
          'Error - something went wrong. Try to restart application'));
    }
  }

  void editClue(int id, String newValue) {
    final List<Word> _st = state.words;
    try {
      List<Word> _newState = _st
          .take(_st.length)
          .map((Word i) => i.id == id ? i.copyWith(clue: newValue) : i)
          .toList();
      emit(DemoState.success(_newState));
    } on Exception {
      emit(const DemoState.failure(
          'Error - something went wrong. Try to restart application'));
    }
  }

  void resetPoints(int id) {
    final List<Word> _st = state.words;
    try {
      List<Word> _newState = _st
          .take(_st.length)
          .map((Word i) => i.id == id ? i.copyWith(points: 0) : i)
          .toList();
      emit(DemoState.success(_newState));
    } on Exception {
      emit(const DemoState.failure(
          'Error - something went wrong. Try to restart application'));
    }
  }
  void orderFromOldest(bool isFromOldest) {
    // compare Word.created is a String
    // created = DateTime.now().toIso8601String();
    // '2022-04-14T17:08:53.862'
    final List<Word> _st = state.words;
    if(isFromOldest) {
      _st.sort((a, b) => a.created!.compareTo(b.created!));
    } else {
      _st.sort((a, b) => b.created!.compareTo(a.created!));
    }
    try {
      emit(DemoState.success(_st));
    } on Exception {
      emit(const DemoState.failure(
          'Error - something went wrong. Try to restart application'));
    }
  }
}
