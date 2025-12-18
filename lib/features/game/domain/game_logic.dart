import 'dart:math';
import 'game_types.dart';

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
  static int getBestMove(
    List<Player?> board,
    Player aiPlayer, {
    required GameMode mode,
    required List<int> xMoves,
    required List<int> oMoves,
  }) {
    // 1. If board is empty, pick center for a strong opening
    if (board.where((e) => e != null).isEmpty) {
      return 4; // Center
    }

    if (mode == GameMode.classic) {
      return _bestMoveClassic(board, aiPlayer);
    }

    return _bestMoveInfiniteShift(board, aiPlayer, xMoves, oMoves);
  }

  static int _bestMoveClassic(List<Player?> board, Player aiPlayer) {
    int bestScore = -1000;
    int move = -1;
    for (int i = 0; i < 9; i++) {
      if (board[i] == null) {
        board[i] = aiPlayer;
        int score = _minimaxClassic(board, 0, false, aiPlayer);
        board[i] = null;
        if (score > bestScore) {
          bestScore = score;
          move = i;
        }
      }
    }

    if (move == -1) {
      for (int i = 0; i < 9; i++) {
        if (board[i] == null) return i;
      }
    }

    return move;
  }

  static int _minimaxClassic(
    List<Player?> board,
    int depth,
    bool isMaximizing,
    Player aiPlayer,
  ) {
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
          int score = _minimaxClassic(board, depth + 1, false, aiPlayer);
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
          int score = _minimaxClassic(board, depth + 1, true, aiPlayer);
          board[i] = null;
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  static int _bestMoveInfiniteShift(
    List<Player?> board,
    Player aiPlayer,
    List<int> xMoves,
    List<int> oMoves,
  ) {
    int bestScore = -1000;
    int move = -1;

    for (int i = 0; i < 9; i++) {
      final currentMoves = aiPlayer == Player.x ? xMoves : oMoves;
      final previousOpponentMoves = aiPlayer == Player.x ? oMoves : xMoves;

      final simulation = _applyMoveWithShift(
        board,
        i,
        aiPlayer,
        currentMoves,
      );

      if (simulation == null) continue;

      final score = _minimaxInfiniteShift(
        simulation.board,
        0,
        false,
        aiPlayer,
        aiPlayer == Player.x ? simulation.updatedMoves : previousOpponentMoves,
        aiPlayer == Player.x ? previousOpponentMoves : simulation.updatedMoves,
      );

      if (score > bestScore) {
        bestScore = score;
        move = i;
      }
    }

    if (move == -1) {
      for (int i = 0; i < 9; i++) {
        if (board[i] == null) return i;
      }
    }

    return move;
  }

  static int _minimaxInfiniteShift(
    List<Player?> board,
    int depth,
    bool isMaximizing,
    Player aiPlayer,
    List<int> xMoves,
    List<int> oMoves, {
    int maxDepth = 8,
  }) {
    final opponent = aiPlayer == Player.x ? Player.o : Player.x;

    if (checkWin(board, aiPlayer) != null) return 10 - depth;
    if (checkWin(board, opponent) != null) return depth - 10;
    if (depth >= maxDepth) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        final simulation = _applyMoveWithShift(
          board,
          i,
          aiPlayer,
          aiPlayer == Player.x ? xMoves : oMoves,
        );
        if (simulation == null) continue;

        final score = _minimaxInfiniteShift(
          simulation.board,
          depth + 1,
          false,
          aiPlayer,
          aiPlayer == Player.x ? simulation.updatedMoves : xMoves,
          aiPlayer == Player.x ? oMoves : simulation.updatedMoves,
          maxDepth: maxDepth,
        );
        bestScore = max(score, bestScore);
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        final simulation = _applyMoveWithShift(
          board,
          i,
          opponent,
          opponent == Player.x ? xMoves : oMoves,
        );
        if (simulation == null) continue;

        final score = _minimaxInfiniteShift(
          simulation.board,
          depth + 1,
          true,
          aiPlayer,
          opponent == Player.x ? simulation.updatedMoves : xMoves,
          opponent == Player.x ? oMoves : simulation.updatedMoves,
          maxDepth: maxDepth,
        );
        bestScore = min(score, bestScore);
      }
      return bestScore;
    }
  }

  static _ShiftResult? _applyMoveWithShift(
    List<Player?> board,
    int moveIndex,
    Player player,
    List<int> playerMoves,
  ) {
    final newBoard = List<Player?>.from(board);
    final updatedMoves = List<int>.from(playerMoves);

    if (updatedMoves.length >= 3) {
      final oldMoveIndex = updatedMoves.removeAt(0);
      newBoard[oldMoveIndex] = null;
    }

    if (newBoard[moveIndex] != null) {
      return null;
    }

    newBoard[moveIndex] = player;
    updatedMoves.add(moveIndex);

    return _ShiftResult(board: newBoard, updatedMoves: updatedMoves);
  }
}

class _ShiftResult {
  final List<Player?> board;
  final List<int> updatedMoves;

  _ShiftResult({required this.board, required this.updatedMoves});
}
