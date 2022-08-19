import 'package:blaa/data/model/word_m/word_m.dart';
import 'package:blaa/domain/repository/words_repo_i.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_word_state.dart';

class EditWordCubit extends Cubit<EditWordState> {
  EditWordCubit(this.repository) : super(const EditWordState.empty());

  final WordsRepoI<Word> repository;

  void setItem(Word item) {
    // print('EditWordCubit - setItem id: ${item.id}');
    emit(EditWordState.initial(item));
  }

  Future<void> triggerFavorite(int id) async {
    try {
      final Word _response = await repository.triggerIsFavorite(id);
      emit(EditWordState.success(_response));
    } on Exception {
      emit(const EditWordState.error(
          'Error - favorite words list was NOT updated!'));
    }
  }

  // EditionBottomModal onPressed: () { widget.handle(itemId, _ctr.value.text);}
  Future<void> editInNative(int id, String newValue) async {
    Word _newState = state.item.copyWith(inNative: newValue);
    try {
      await repository.update(_newState);
      emit(EditWordState.success(_newState));
    } on Exception {
      emit(const EditWordState.error(
          'Error - something went wrong. Try to restart application'));
    }
  }

  Future<void> editInTranslation(int id, String newValue) async {
    Word _newState = state.item.copyWith(inTranslation: newValue);
    try {
      await repository.update(_newState);
      emit(EditWordState.success(_newState));
    } on Exception {
      emit(const EditWordState.error(
          'Error - something went wrong. Try to restart application'));
    }
  }

  Future<void> editCategory(int id, String newValue) async {
    Word _newState = state.item.copyWith(category: newValue);
    try {
      await repository.update(_newState);
      emit(EditWordState.success(_newState));
    } on Exception {
      emit(const EditWordState.error(
          'Error - something went wrong. Try to restart application'));
    }
  }

  Future<void> editClue(int id, String newValue) async {
    Word _newState = state.item.copyWith(clue: newValue);
    try {
      await repository.update(_newState);
      emit(EditWordState.success(_newState));
    } on Exception {
      emit(const EditWordState.error(
          'Error - something went wrong. Try to restart application'));
    }
  }

  Future<void> resetPoints(int id) async {
    Word _newState = state.item.copyWith(points: 0);
    try {
      await repository.update(_newState);
      emit(EditWordState.success(_newState));
    } on Exception {
      emit(const EditWordState.error(
          'Error - something went wrong. Try to restart application'));
    }
  }
}
