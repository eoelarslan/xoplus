import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xoplus/settings_screen.dart';
import 'game_mode_page.dart';
import 'widgets.dart';

enum GameMode { regular, special }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isSoundOn = true;
  bool _isVibrationOn = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoundOn = prefs.getBool('isSoundOn') ?? true;
      _isVibrationOn = prefs.getBool('isVibrationOn') ?? true;
    });
  }

  void _playFeedback() {
    if (_isSoundOn) {
      SystemSound.play(SystemSoundType.click);
    }
    if (_isVibrationOn) {
      HapticFeedback.mediumImpact();
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    _playFeedback();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('XOPlus'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MainMenuButton(
                  title: 'Regular Game',
                  icon: Icons.gamepad,
                  onPressed: () => _navigateToPage(
                    context,
                    const GameModePage(GameMode.regular),
                  ),
                ),
                const SizedBox(height: 16),
                MainMenuButton(
                  title: 'Special Game',
                  icon: Icons.stars,
                  onPressed: () => _navigateToPage(
                    context,
                    const GameModePage(GameMode.special),
                  ),
                ),
                const SizedBox(height: 16),
                MainMenuButton(
                  title: 'Settings',
                  icon: Icons.settings,
                  onPressed: () => _navigateToPage(
                    context,
                    const SettingsScreen(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}