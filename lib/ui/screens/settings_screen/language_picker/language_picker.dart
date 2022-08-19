import 'package:blaa/blocs/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker(
      {Key? key, required currentLocale, required allL10nLanguages})
      : _currentLocale = currentLocale,
        _allL10nLanguages = allL10nLanguages,
        super(key: key);

  // current application language
  final String _currentLocale;

  // _allL10nLanguages = <Map<String, dynamic>>[{'locale': const Locale('en'), 'name': 'English'},]
  // all supported translations
  final List<Map> _allL10nLanguages;

  String _getFlag(String code) {
    String _tempCode = code;

    const int _flagOffset = 0x1F1E6;
    const int _asciiOffset = 0x41;

    if (code == 'en') {
      _tempCode = 'gb';
    }
    final String _country = _tempCode.toUpperCase();
    final int _firstChar = _country.codeUnitAt(0) - _asciiOffset + _flagOffset;
    final int _secondChar = _country.codeUnitAt(1) - _asciiOffset + _flagOffset;

    String _emoji =
        String.fromCharCode(_firstChar) + String.fromCharCode(_secondChar);
    return _emoji;
  }

  List<Widget> _buildLanguagesTiles(BuildContext context) {

    List<Widget> _expandedLanguagesTiles = [
      _buildLanguagePickUpTile(context: context,langCode: _currentLocale, langName: _currentLocale)
    ];
    for (var item in _allL10nLanguages) {
      final String _langCode = item['locale'].languageCode;
      final String _langName = item['name'];
      Widget _item = _buildLanguagePickUpTile(context: context,langCode: _langCode, langName: _langName);
      if (_langCode == _currentLocale) {
        // remove duplicates if all supported translations contain current application language
        _expandedLanguagesTiles.replaceRange(0, 1, [_item]);
      } else {
        _expandedLanguagesTiles.add(_item);
      }
    }
    return _expandedLanguagesTiles;
  }

  ListTile _buildLanguagePickUpTile(
      {required BuildContext context, required String langCode, required String langName}) {
    final String _langCodeFromCubit = context.read<SettingsCubit>().state.localeCode;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 40),
      selected: _langCodeFromCubit == langCode,
      selectedTileColor: Color.lerp(Colors.amber, Colors.grey, 0.3),
      title: TextButton(
          onPressed: () =>
              context.read<SettingsCubit>().setLocale(langCode),
          child: Text(langName,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.start)),
      trailing: Text(_getFlag(langCode)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: const Text(
          'Language',
          style: TextStyle(
              fontSize: 19, color: Colors.black, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        children: _buildLanguagesTiles(context));
  }
}
