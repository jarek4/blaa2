import 'package:equatable/equatable.dart';

class Language extends Equatable {
  const Language({required this.name, required this.shortcut});

  final String name;
  final String shortcut;

  static const int _flagOffset = 0x1F1E6;
  static const int _asciiOffset = 0x41;

  String getFlag() {
    final String _country = shortcut.toUpperCase();
    final int _firstChar = _country.codeUnitAt(0) - _asciiOffset + _flagOffset;
    final int _secondChar = _country.codeUnitAt(1) - _asciiOffset + _flagOffset;
    String _emoji =
        String.fromCharCode(_firstChar) + String.fromCharCode(_secondChar);
    return _emoji;
  }

  Language copyWith({
    String? name,
    String? shortcut,
  }) {
    return Language(
        name: name ?? this.name, shortcut: shortcut ?? this.shortcut);
  }

  @override
  List<Object> get props => [name, shortcut];
}
