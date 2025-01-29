import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xoplus/game_mode_page.dart';
import 'package:xoplus/settings_screen.dart';
import 'game_model.dart';
import 'player.dart';
import 'home_page.dart';

class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  final PlayMode playMode;

  const GameScreen({
    super.key, 
    required this.gameMode,
    required this.playMode,
  });

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late final GameModel _gameModel;
  final List<AnimationController> _controllers = [];
  bool _isSoundOn = true;
  bool _isVibrationOn = true;

  static const double _cellMargin = 8.0;
  static const double _fontSize = 48.0;

  @override
  void initState() {
    super.initState();
    _gameModel = GameModel();
    _loadSettings();
    
    // Create an animation controller for each cell
    for (int i = 0; i < 9; i++) {
      _controllers.add(AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ));
    }
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

  void _playWinFeedback() {
    if (_isSoundOn) {
      SystemSound.play(SystemSoundType.alert);
    }
    if (_isVibrationOn) {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildCell(int index) {
    bool isWinningCell = _gameModel.winningCombo?.contains(index) ?? false;
    final player = _gameModel.board[index];

    return GestureDetector(
      onTap: () {
        if (player == Player.none && !_gameModel.gameOver) {
          _playFeedback(); // Hamle yapıldığında feedback ver
          setState(() {
            _gameModel.makeMove(index);
            _controllers[index].forward(from: 0.0);
            
            // Oyun bittiğinde kazanma feedback'i ver
            if (_gameModel.gameOver && _gameModel.winningCombo != null) {
              _playWinFeedback();
            }
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(_cellMargin),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
          color: isWinningCell ? Colors.green[300] : Colors.blue[100],
        ),
        child: Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controllers[index],
              curve: Curves.elasticOut,
            ),
            child: Text(
              player == Player.none ? '' : player.toString().split('.').last,
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.bold,
                color: player == Player.X ? Colors.blue[900] : Colors.red[900],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreColumn('Player X', _gameModel.xWins, Colors.blue[300]!),
          _buildScoreColumn('Draws', _gameModel.draws, Colors.white70),
          _buildScoreColumn('Player O', _gameModel.oWins, Colors.red[300]!),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(String label, int score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String statusText = _gameModel.gameOver
        ? (_gameModel.winningCombo != null
            ? "Winner: ${_gameModel.currentPlayer}"
            : "Draw!")
        : "Current Turn: ${_gameModel.currentPlayer}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("XOPlus"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _playFeedback();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _playFeedback();
              setState(() {
                _gameModel.reset();
                for (var controller in _controllers) {
                  controller.reset();
                }
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'resetScores') {
                _playFeedback();
                setState(() {
                  _gameModel.resetScores();
                });
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'resetScores',
                child: Text('Reset Scores'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildScoreBoard(),
          const SizedBox(height: 20),
          Text(
            statusText,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 9,
              itemBuilder: (context, index) => _buildCell(index),
            ),
          ),
        ],
      ),
    );
  }
}