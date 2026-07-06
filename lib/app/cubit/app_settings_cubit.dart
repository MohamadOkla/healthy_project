import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/services/local_storage_service.dart';
import 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit({LocalStorageService? storage})
      : _storage = storage ?? LocalStorageService.instance,
        super(const AppSettingsState()) {
    loadSettings();
  }

  final LocalStorageService _storage;

  void loadSettings() {
    final language = _storage.getString(StorageKeys.selectedLanguage) ?? 'ar';
    final isDarkMode = _storage.getBool(StorageKeys.isDarkMode) ?? false;
    emit(
      AppSettingsState(
        locale: Locale(language == 'en' ? 'en' : 'ar'),
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }

  Future<void> changeLanguage(String languageCode) async {
    final normalized = languageCode == 'en' ? 'en' : 'ar';
    await _storage.saveString(StorageKeys.selectedLanguage, normalized);
    emit(state.copyWith(locale: Locale(normalized)));
  }

  Future<void> toggleDarkMode(bool value) => setDarkMode(value);

  Future<void> setDarkMode(bool isDarkMode) async {
    await _storage.saveBool(StorageKeys.isDarkMode, isDarkMode);
    emit(
      state.copyWith(
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
