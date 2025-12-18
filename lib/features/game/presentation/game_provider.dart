import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xoplus/features/stats/presentation/stats_provider.dart';
import 'package:xoplus/features/settings/presentation/settings_provider.dart';
import '../domain/game_types.dart';
import '../domain/game_logic.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) {
  return GameController(ref);
});

class GameController extends StateNotifier<GameState> {
  final Ref ref;
  bool isVsAi = false;
  bool isAiThinking = false;

  GameController(this.ref) : super(GameState.initial());

  void startGame({required bool vsAi}) {
    isVsAi = vsAi;
    state = GameState.initial();
    isAiThinking = false;
  }

  Future<void> makeMove(int index) async {
    // Basic validation
    if (state.board[index] != null ||
        state.status != GameStatus.playing ||
        isAiThinking) {
      return;
    }

    // 1. Player Move
    _performMove(index);

    // 2. Check Game Over
    if (_checkGameOver()) return;

    // 3. AI Turn
    if (isVsAi && state.currentPlayer == Player.o && state.status == GameStatus.playing) {
      isAiThinking = true;
      try {
        await Future.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;

        final bestMove = GameLogic.getBestMove(
          List<Player?>.from(state.board),
          Player.o,
        );
        _performMove(bestMove);
        _checkGameOver();
      } finally {
        isAiThinking = false;
      }
    }
  }

  void _performMove(int index) {
    if (state.board[index] != null) return;

    final newBoard = List<Player?>.from(state.board);
    newBoard[index] = state.currentPlayer;

    // Haptics
    final settings = ref.read(settingsControllerProvider);
    if (settings.isHapticsEnabled) {
      HapticFeedback.lightImpact();
    }

    state = state.copyWith(
      board: newBoard,
      currentPlayer: state.currentPlayer == Player.x ? Player.o : Player.x,
    );
  }

  bool _checkGameOver() {
    final previousPlayer = state.currentPlayer == Player.x ? Player.o : Player.x;
    
    // Check Win
    final winningLine = GameLogic.checkWin(state.board, previousPlayer);
    if (winningLine != null) {
      state = state.copyWith(
        status: GameStatus.win,
        winner: previousPlayer,
        winningLine: winningLine,
      );
      _handleGameEnd(winner: previousPlayer);
      return true;
    }

    // Check Draw
    if (GameLogic.isBoardFull(state.board)) {
      state = state.copyWith(status: GameStatus.draw);
      _handleGameEnd(winner: null);
      return true;
    }

    return false;
  }

  void _handleGameEnd({Player? winner}) {
    final statsNotifier = ref.read(statsControllerProvider.notifier);
    final settings = ref.read(settingsControllerProvider);

    // Haptics on end
    if (settings.isHapticsEnabled) {
      if (winner != null) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    }

    // Record Stats (sadece vsAI)
    if (!isVsAi) return;
    
    if (winner == Player.x) {
      statsNotifier.recordPlayerWin();
    } else if (winner == Player.o) {
      statsNotifier.recordAiWin();
    } else {
      statsNotifier.recordDraw();
    }

  }

  void resetGame() {
    startGame(vsAi: isVsAi);
  }
}
