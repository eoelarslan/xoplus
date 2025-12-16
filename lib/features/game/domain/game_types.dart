enum Player { x, o }

enum GameStatus { playing, draw, win }

class GameState {
  final List<Player?> board;
  final Player currentPlayer;
  final GameStatus status;
  final Player? winner;
  final List<int>? winningLine;

  const GameState({
    required this.board,
    required this.currentPlayer,
    this.status = GameStatus.playing,
    this.winner,
    this.winningLine,
  });

  factory GameState.initial() {
    return const GameState(
      board: [null, null, null, null, null, null, null, null, null],
      currentPlayer: Player.x,
      status: GameStatus.playing,
    );
  }

  GameState copyWith({
    List<Player?>? board,
    Player? currentPlayer,
    GameStatus? status,
    Player? winner,
    List<int>? winningLine,
  }) {
    return GameState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      status: status ?? this.status,
      winner: winner ?? this.winner,
      winningLine: winningLine ?? this.winningLine,
    );
  }
}
