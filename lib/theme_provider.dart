import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  String _currentTheme = 'System';

  ThemeData get themeData => _themeData;
  String get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _currentTheme = prefs.getString('selectedTheme') ?? 'System';
    _updateTheme();
  }

  Future<void> setTheme(String theme) async {
    _currentTheme = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', theme);
    _updateTheme();
    notifyListeners();
  }

  void _updateTheme() {
    switch (_currentTheme) {
      case 'Dark':
        _themeData = ThemeData.dark();
        break;
      case 'Light':
        _themeData = ThemeData.light();
        break;
      case 'Blue':
        _themeData = ThemeData(primarySwatch: Colors.blue);
        break;
      case 'Green':
        _themeData = ThemeData(primarySwatch: Colors.green);
        break;
      default:
        var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
        _themeData = brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light();
    }
  }
}
