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
       _themeData = ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        );
        break;
      case 'Light':
        _themeData = ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        );
        break;
      case 'Deep Blue':
        _themeData = ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF1E3A5F), // Derin mavi tonu
          scaffoldBackgroundColor: const Color(0xFF1E3A5F),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1E3A5F)), // **Koyu mavi**
        );
        break;
      case 'Neon Pink':
        _themeData = ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFFFF007F), // Neon pembe
          scaffoldBackgroundColor: const Color(0xFFFF007F),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFFF007F)), // **Neon pembe**
        );
        break;
      default:
        var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
        _themeData = brightness == Brightness.dark
            ? ThemeData.dark().copyWith(appBarTheme: const AppBarTheme(backgroundColor: Colors.black))
            : ThemeData.light().copyWith(appBarTheme: const AppBarTheme(backgroundColor: Colors.white));
    }
  }
}
