part of 'edit_word_cubit.dart';

enum EditWordStateStatus { success, failure, initial, empty }

class EditWordState extends Equatable {
  const EditWordState._(
      {this.item = const Word(id: -1, inTranslation: '', inNative: ''),
      this.msg,
      this.status = EditWordStateStatus.empty});

  final Word item;
  final String? msg;
  final EditWordStateStatus status;

  const EditWordState.empty() : this._();

  const EditWordState.initial(Word w)
      : this._(item: w, status: EditWordStateStatus.success);

  const EditWordState.success(Word w)
      : this._(item: w, status: EditWordStateStatus.success);

  const EditWordState.error(String? msg)
      : this._(msg: msg, status: EditWordStateStatus.failure);

  @override
  List<Object?> get props => [item, msg, status];
}
