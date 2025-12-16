import 'stats_entity.dart';

abstract class StatsRepository {
  Future<StatsEntity> loadStats();
  Future<void> incrementPlayerWins();
  Future<void> incrementAiWins();
  Future<void> incrementDraws();
  Future<void> resetStats();
}
