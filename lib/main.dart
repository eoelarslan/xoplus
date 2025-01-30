import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xoplus/splash_screen.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const XOPlusApp(),
    ),
  );
}

class XOPlusApp extends StatelessWidget {
  const XOPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AnimatedTheme(
      data: themeProvider.themeData,
      duration: const Duration(milliseconds: 500), // 🎨 Tema değişirken yumuşak geçiş
      curve: Curves.easeInOut, // 🔄 Animasyonun nasıl olacağını belirliyor
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'XOPlus',
        theme: themeProvider.themeData,
        home: const SplashScreen(),
      ),
    );
  }
}
