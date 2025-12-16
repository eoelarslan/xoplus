import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/settings_entity.dart';
import '../domain/settings_repository.dart';
import '../data/settings_repository_impl.dart';

// Key provider for SharedPreferences (overridden in main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// Repository Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepositoryImpl(prefs);
});

// Controller Provider
final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsEntity>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsController(repository);
});

class SettingsController extends StateNotifier<SettingsEntity> {
  final SettingsRepository _repository;

  SettingsController(this._repository)
      : super(const SettingsEntity(
          themeMode: ThemeMode.system,
          isSoundEnabled: true,
          isHapticsEnabled: true,
        )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = await _repository.loadSettings();
  }

  Future<void> toggleTheme(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _repository.saveThemeMode(mode);
  }

  Future<void> toggleSound(bool enabled) async {
    state = state.copyWith(isSoundEnabled: enabled);
    await _repository.saveSoundEnabled(enabled);
  }

  Future<void> toggleHaptics(bool enabled) async {
    state = state.copyWith(isHapticsEnabled: enabled);
    await _repository.saveHapticsEnabled(enabled);
  }
}
