import 'package:blaa/data/model/language_m/language_m.dart';
/*
use a country code, for example:
Poland: pl, USA: us, Great Britain: gbr, Bulgaria: bg
 */
class SupportedLanguages {
  static const List<Language> list = [
    Language(name: 'English', shortcut: 'us'),
    Language(name: 'Polish', shortcut: 'pl'),
    Language(name: 'Turkish', shortcut: 'tr'),
  ];
  static final List<String> names = list.map((e) => e.name).toList();
  static final List<String> shortcuts = list.map((e) => e.shortcut).toList();
}
