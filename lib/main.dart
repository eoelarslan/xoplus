import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'home_page.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XOPlus',
      theme: themeProvider.themeData,
      home: const HomePage(), // İlk açılışta HomePage olacak!
    );
  }
}
