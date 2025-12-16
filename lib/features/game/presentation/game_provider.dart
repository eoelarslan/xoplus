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
      // Small delay for realism
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      
      final bestMove = GameLogic.getBestMove(state.board, Player.o);
      _performMove(bestMove);
      _checkGameOver();
      isAiThinking = false;
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

    // Record Stats
    if (winner == Player.x) {
      statsNotifier.recordPlayerWin();
    } else if (winner == Player.o) {
      // In PvP 'O' is also a player, but for stats simplicity let's assume P1 is always tracked
      // If VsAI, O is AI. if PvP, it's just a "loss" for P1 stats perspective or we can separate PvP stats.
      // Requirement said "Play vs Player" and "Play vs AI".
      // Stats requirement: "wins, losses, draws for the local user".
      // Usually in PvP on same device, stats might be confusing. 
      // Let's count PvP wins for X as Player Wins? Or just disable stats for PvP?
      // For now, if VsAI: Winner O = Loss. 
      // If PvP: Let's just track X wins as "Wins". O wins as "Losses" is weird.
      // Let's only track stats for VsAI mode to be clean, or count X as "Player 1".
      if (isVsAi) {
        statsNotifier.recordAiWin();
      }
    } else {
      if (isVsAi) {
        statsNotifier.recordDraw();
      }
    }
  }

  void resetGame() {
    startGame(vsAi: isVsAi);
  }
}
