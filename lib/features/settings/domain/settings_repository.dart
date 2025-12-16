import 'package:flutter/material.dart';
import 'settings_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> loadSettings();
  Future<void> saveThemeMode(ThemeMode mode);
  Future<void> saveSoundEnabled(bool enabled);
  Future<void> saveHapticsEnabled(bool enabled);
}
