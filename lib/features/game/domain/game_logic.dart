import 'game_types.dart';
import 'dart:math';

class GameLogic {
  static const List<List<int>> winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Cols
    [0, 4, 8], [2, 4, 6]             // Diagonals
  ];

  /// Returns the winning pattern indices if there is a winner, or null.
  static List<int>? checkWin(List<Player?> board, Player player) {
    for (var pattern in winPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        return pattern;
      }
    }
    return null;
  }

  static bool isBoardFull(List<Player?> board) {
    return !board.contains(null);
  }

  /// AI Logic: Minimax
  /// Returns the best move index.
  static int getBestMove(List<Player?> board, Player aiPlayer) {
    // 1. If board is empty, pick center or random corner for variety
    if (board.where((e) => e != null).isEmpty) {
      return 4; // Center
    }
    
    // 2. Run Minimax
    int bestScore = -1000;
    int move = -1;
    
    for (int i = 0; i < 9; i++) {
     if (board[i] == null) {
        board[i] = aiPlayer;
        int score = _minimax(board, 0, false, aiPlayer);
        board[i] = null;
        if (score > bestScore) {
          bestScore = score;
          move = i;
        }
      }
    }
    
    // Fallback if something fails (shouldn't happen)
    if (move == -1) {
       for (int i = 0; i < 9; i++) {
         if (board[i] == null) return i;
       }
    }

    return move;
  }

  static int _minimax(List<Player?> board, int depth, bool isMaximizing, Player aiPlayer) {
    final opponent = aiPlayer == Player.x ? Player.o : Player.x;
    
    // Check terminal states
    if (checkWin(board, aiPlayer) != null) return 10 - depth;
    if (checkWin(board, opponent) != null) return depth - 10;
    if (isBoardFull(board)) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == null) {
          board[i] = aiPlayer;
          int score = _minimax(board, depth + 1, false, aiPlayer);
          board[i] = null;
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == null) {
          board[i] = opponent;
          int score = _minimax(board, depth + 1, true, aiPlayer);
          board[i] = null;
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }
}
