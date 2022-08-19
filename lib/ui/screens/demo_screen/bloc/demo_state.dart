part of 'demo_cubit.dart';

enum DemoStateStatus { loading, success, failure }
class DemoState extends Equatable {
  const DemoState._({
    this.words = const <Word>[],
    this.status = DemoStateStatus.loading,
    this.errorText,
  });

  final List<Word> words;
  final DemoStateStatus status;
  final String? errorText;

  const DemoState.loading() : this._();

  const DemoState.success(List<Word> i)
      : this._(status: DemoStateStatus.success, words: i);

  const DemoState.failure(String? message)
      : this._(status: DemoStateStatus.failure, errorText: message);

  @override
  List<Object?> get props => [errorText, words, status];
}
