import 'package:equatable/equatable.dart';

class StatsEntity extends Equatable {
  final int playerWins;
  final int aiWins;
  final int draws;

  const StatsEntity({
    this.playerWins = 0,
    this.aiWins = 0,
    this.draws = 0,
  });

  StatsEntity copyWith({
    int? playerWins,
    int? aiWins,
    int? draws,
  }) {
    return StatsEntity(
      playerWins: playerWins ?? this.playerWins,
      aiWins: aiWins ?? this.aiWins,
      draws: draws ?? this.draws,
    );
  }

  int get totalGames => playerWins + aiWins + draws;

  @override
  List<Object?> get props => [playerWins, aiWins, draws];
}
