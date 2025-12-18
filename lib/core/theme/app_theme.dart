import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF6C63FF); // Brand (buton vs)
  static const _xColor = Color(0xFF03DAC6);       // X
  static const _oColor = Color(0xFFFF6B6B);       // O (coral/pink)

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5FA),
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      onPrimary: Colors.white,

      secondary: _xColor,     // X rengi
      tertiary: _oColor,      // O rengi

      surface: Colors.white,
      onSurface: Colors.black,
      outline: Colors.black12,
    ),
    textTheme: GoogleFonts.outfitTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1E1E2C),
    colorScheme: const ColorScheme.dark(
      primary: _primaryColor,
      onPrimary: Colors.white,

      secondary: _xColor,    // X rengi
      tertiary: _oColor,     // O rengi

      surface: Color(0xFF2D2D44),
      onSurface: Colors.white,
      outline: Colors.white24,
    ),
    textTheme: GoogleFonts.outfitTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
