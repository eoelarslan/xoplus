import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xoplus/home_page.dart';
import 'game_screen.dart';
import 'widgets.dart';

enum PlayMode { pvp, pve }

class GameModePage extends StatefulWidget {
  final GameMode gameMode;

  const GameModePage(this.gameMode, {super.key});

  @override
  GameModePageState createState() => GameModePageState();
}

class GameModePageState extends State<GameModePage> {
  bool _isSoundOn = true;
  bool _isVibrationOn = true;

  late SharedPreferences _prefs; // SharedPreferences nesnesi

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initPrefs().then((_) => _loadSettings());
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isSoundOn = _prefs.getBool('isSoundOn') ?? true;
      _isVibrationOn = _prefs.getBool('isVibrationOn') ?? true;
    });
  }

  void _playFeedback() {
    if (_isSoundOn) {
      SystemSound.play(SystemSoundType.click);
    }
    if (_isVibrationOn) {
      HapticFeedback.lightImpact();
    }
  }

  void _navigateToGame(BuildContext context, {PlayMode playMode = PlayMode.pvp}) {
    _playFeedback();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          gameMode: widget.gameMode,
          playMode: playMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.gameMode == GameMode.regular ? 'Regular' : 'Special'} Game'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameModeButton(
                title: 'Player vs Player',
                icon: Icons.people,
                onPressed: () => _navigateToGame(
                  context,
                  playMode: PlayMode.pvp,
                ),
              ),
              const SizedBox(height: 16),
              GameModeButton(
                title: 'Player vs Computer',
                icon: Icons.computer,
                onPressed: () => _navigateToGame(
                  context,
                  playMode: PlayMode.pve,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}