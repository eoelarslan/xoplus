enum Player { x, o }

enum GameStatus { playing, draw, win }

enum GameMode { classic, infiniteShift }

class GameState {
  static const _unset = Object();

  final List<Player?> board;
  final Player currentPlayer;
  final GameStatus status;
  final Player? winner;
  final List<int>? winningLine;
  final GameMode mode;
  final List<int> xMoves;
  final List<int> oMoves;

  const GameState({
    required this.board,
    required this.currentPlayer,
    this.status = GameStatus.playing,
    this.winner,
    this.winningLine,
    this.mode = GameMode.classic,
    this.xMoves = const [],
    this.oMoves = const [],
  });

  factory GameState.initial([GameMode mode = GameMode.classic]) {
    return GameState(
      board: List.filled(9, null),
      currentPlayer: Player.x,
      status: GameStatus.playing,
      mode: mode,
    );
  }

  GameState copyWith({
    List<Player?>? board,
    Player? currentPlayer,
    GameStatus? status,
    Player? winner,
    Object? winningLine = _unset,
    GameMode? mode,
    List<int>? xMoves,
    List<int>? oMoves,
  }) {
    return GameState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      status: status ?? this.status,
      winner: winner ?? this.winner,
      winningLine: identical(winningLine, _unset)
          ? this.winningLine
          : winningLine as List<int>?,
      mode: mode ?? this.mode,
      xMoves: xMoves ?? this.xMoves,
      oMoves: oMoves ?? this.oMoves,
    );
  }
}

