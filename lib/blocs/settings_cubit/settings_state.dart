part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({required this.localeCode});

  final String localeCode;

  SettingsState copyWith({
    String? localeCode,
  }) {
    return SettingsState(localeCode: localeCode ?? this.localeCode);
  }

  @override
  List<Object> get props => [localeCode];
}
