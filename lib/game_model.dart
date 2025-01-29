import 'player.dart';

class GameModel {
  final List<Player> board;
  Player currentPlayer;
  bool gameOver;
  List<int>? winningCombo;
  int xWins = 0;
  int oWins = 0;
  int draws = 0;
  static Player nextStartingPlayer = Player.X;

  GameModel()
      : board = List.filled(9, Player.none),
        currentPlayer = nextStartingPlayer,
        gameOver = false,
        winningCombo = null;

  void makeMove(int index) {
    if (board[index] == Player.none && !gameOver) {
      board[index] = currentPlayer;
      if (!checkWinner()) {
        if (board.every((cell) => cell != Player.none)) {
          gameOver = true;
          draws++;
          nextStartingPlayer = (nextStartingPlayer == Player.X) ? Player.O : Player.X;
        } else {
          currentPlayer = (currentPlayer == Player.X) ? Player.O : Player.X;
        }
      } else {
        if (currentPlayer == Player.X) {
          xWins++;
        } else {
          oWins++;
        }
        nextStartingPlayer = (nextStartingPlayer == Player.X) ? Player.O : Player.X;
      }
    }
  }

  bool checkWinner() {
    const winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6] // Diagonals
    ];

    for (final combination in winningCombinations) {
      if (board[combination[0]] != Player.none &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[0]] == board[combination[2]]) {
        gameOver = true;
        winningCombo = combination;
        return true;
      }
    }
    return false;
  }

  void reset() {
    board.fillRange(0, 9, Player.none);
    gameOver = false;
    winningCombo = null;
    currentPlayer = nextStartingPlayer;
  }

  void resetScores() {
    xWins = 0;
    oWins = 0;
    draws = 0;
    nextStartingPlayer = Player.X;
    currentPlayer = Player.X;
  }
}
