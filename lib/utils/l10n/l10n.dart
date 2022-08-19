import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('tr'),
    const Locale('pl'),
  ];
  static final allWithFullName = <Map<String, dynamic>>[
    {'locale': const Locale('en'), 'name': 'English'},
    {'locale': const Locale('tr'), 'name': 'Türkçe'},
    {'locale': const Locale('pl'), 'name': 'polski'}
  ];
}
