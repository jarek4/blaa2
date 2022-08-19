import 'package:blaa/data/providers/shared_pref/shared_pref.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(localeCode: SharedPref.getLocaleCode()));

  Future<void> setLocale(String loc) async {
    await SharedPref.setLocale(loc);
    Locale(loc);
    emit(state.copyWith(localeCode: loc));
  }

  void getLocale() {
    emit(state.copyWith(localeCode: SharedPref.getLocaleCode()));
  }
}
