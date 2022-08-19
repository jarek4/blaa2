// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:blaa/data/providers/storage_secured/storage_secured_interface/storage_secure_interface.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// This is a local authentication data source implementation
class StorageSecured implements StorageSecInterface {
  static StorageSecured? _instance;

  factory StorageSecured() =>
      _instance ??= StorageSecured._(const FlutterSecureStorage());

  StorageSecured._(this._storage);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'TOKEN';
  static const _emailKey = 'EMAIL';
  static const _userEmailAndToken = 'USER_EMAIL_TOKEN';

  @override
  Future<void> persistEmailAndToken(String email, String token) async {
    try{
      await _storage.write(key: _emailKey, value: email);
      print('email: $email stored inSS');
      await _storage.write(key: _tokenKey, value: token);
      print('token: $token stored inSS');
    } catch(e) {
      print('SS persist - Exception: $e');
      throw Exception(e);
    }
  }

  // test:
  Future<void> persistDataAsList(List<String> userEmailAndToken) async {
    // as a value can only put a string, so have to convert
    final String _val = json.encode(userEmailAndToken);
    await _storage.write(key: _userEmailAndToken, value: _val);
    // to read this value use (in Future<List<String>?> getEmailAndToken()):
    // final _val1 = _storage.read(key: _userEmailAndToken);
    // return _val1 == null ? null : List<String>.from(json.decode(_val1));
  }

  @override
  Future<void> deleteToken() async {
    return _storage.delete(key: _tokenKey);
  }

  @override
  Future<void> deleteEmail() async {
    return await _storage.delete(key: _emailKey);
  }

  @override
  Future<String?> getEmail() async {
    String? ee = await _storage.read(key: _emailKey);
    String ee2 = ee.toString();
    print('SS getEmail: $ee2');
    // return await _storage.read(key: _emailKey);
    return ee2;
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteAll() async {
    return await _storage.deleteAll();
  }
}
