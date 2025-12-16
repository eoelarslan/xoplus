import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/settings_entity.dart';
import '../domain/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  static const _keyThemeMode = 'theme_mode';
  static const _keySoundEnabled = 'sound_enabled';
  static const _keyHapticsEnabled = 'haptics_enabled';

  SettingsRepositoryImpl(this._prefs);

  @override
  Future<SettingsEntity> loadSettings() async {
    final themeIndex = _prefs.getInt(_keyThemeMode) ?? ThemeMode.system.index;
    final soundEnabled = _prefs.getBool(_keySoundEnabled) ?? true;
    final hapticsEnabled = _prefs.getBool(_keyHapticsEnabled) ?? true;

    return SettingsEntity(
      themeMode: ThemeMode.values[themeIndex],
      isSoundEnabled: soundEnabled,
      isHapticsEnabled: hapticsEnabled,
    );
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_keyThemeMode, mode.index);
  }

  @override
  Future<void> saveSoundEnabled(bool enabled) async {
    await _prefs.setBool(_keySoundEnabled, enabled);
  }

  @override
  Future<void> saveHapticsEnabled(bool enabled) async {
    await _prefs.setBool(_keyHapticsEnabled, enabled);
  }
}
