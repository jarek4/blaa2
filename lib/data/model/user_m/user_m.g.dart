// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_m.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      created: json['created'] as String?,
      email: json['email'] as String? ?? 'demo@user',
      id: json['id'] as int?,
      imageAsString: json['imageAsString'] as String?,
      imageUrl: json['imageUrl'] as String?,
      langToLearn: json['langToLearn'] as String? ?? 'Polish',
      name: json['name'] as String? ?? 'Demo',
      nativeLang: json['nativeLang'] as String? ?? 'English',
      password: json['password'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'created': instance.created,
      'email': instance.email,
      'id': instance.id,
      'imageAsString': instance.imageAsString,
      'imageUrl': instance.imageUrl,
      'langToLearn': instance.langToLearn,
      'name': instance.name,
      'nativeLang': instance.nativeLang,
      'password': instance.password,
      'token': instance.token,
    };
