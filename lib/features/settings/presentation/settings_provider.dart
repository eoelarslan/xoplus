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
    final loaded = await _repository.loadSettings();
    if (!mounted) return;
    state = loaded;
  }

  Future<void> toggleTheme(ThemeMode mode) async {
    final prev = state;
    state = state.copyWith(themeMode: mode);
    try {
      await _repository.saveThemeMode(mode);
    } catch (_) {
      state = prev;
    }
  }

  Future<void> toggleSound(bool enabled) async {
    final prev = state;
    state = state.copyWith(isSoundEnabled: enabled);
    try {
      await _repository.saveSoundEnabled(enabled);
    } catch (_) {
      state = prev;
    }
  }

  Future<void> toggleHaptics(bool enabled) async {
    final prev = state;
    state = state.copyWith(isHapticsEnabled: enabled);
    try {
      await _repository.saveHapticsEnabled(enabled);
    } catch (_) {
      state = prev;
    }
  }
}
