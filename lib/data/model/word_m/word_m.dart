import 'package:freezed_annotation/freezed_annotation.dart';


part 'word_m.freezed.dart';
part 'word_m.g.dart';

@freezed
class Word with _$Word {
  const factory Word({
    String? category,
    String? created,
    String? clue,
    required int id,
    String? imageAsString,
    required String inNative,
    required String inTranslation,
    @Default(0) int isFavorite,
    @Default('Polish') String langToLearn,
    @Default('English') String nativeLang,
    @Default(0) int points,
    String? user, // identify user by email
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) =>
      _$WordFromJson(json);
}