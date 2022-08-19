import 'package:blaa/utils/constants/assets_const.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_m.freezed.dart';
part 'user_m.g.dart';

@freezed
class User with _$User {
  const factory User({
    String? created,
    @Default('demo@user') String email,
    int? id,
    String? imageAsString,
    String? imageUrl,
    @Default('Polish') String langToLearn,
    @Default('Demo') String name,
    @Default('English') String nativeLang,
    String? password,
    String? token,

  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
