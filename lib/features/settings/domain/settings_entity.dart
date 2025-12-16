import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsEntity extends Equatable {
  final ThemeMode themeMode;
  final bool isSoundEnabled;
  final bool isHapticsEnabled;

  const SettingsEntity({
    required this.themeMode,
    required this.isSoundEnabled,
    required this.isHapticsEnabled,
  });

  SettingsEntity copyWith({
    ThemeMode? themeMode,
    bool? isSoundEnabled,
    bool? isHapticsEnabled,
  }) {
    return SettingsEntity(
      themeMode: themeMode ?? this.themeMode,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isHapticsEnabled: isHapticsEnabled ?? this.isHapticsEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, isSoundEnabled, isHapticsEnabled];
}
