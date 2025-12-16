import 'package:shared_preferences/shared_preferences.dart';
import '../domain/stats_entity.dart';
import '../domain/stats_repository.dart';

class StatsRepositoryImpl implements StatsRepository {
  final SharedPreferences _prefs;

  static const _keyPlayerWins = 'stats_player_wins';
  static const _keyAiWins = 'stats_ai_wins';
  static const _keyDraws = 'stats_draws';

  StatsRepositoryImpl(this._prefs);

  @override
  Future<StatsEntity> loadStats() async {
    return StatsEntity(
      playerWins: _prefs.getInt(_keyPlayerWins) ?? 0,
      aiWins: _prefs.getInt(_keyAiWins) ?? 0,
      draws: _prefs.getInt(_keyDraws) ?? 0,
    );
  }

  @override
  Future<void> incrementPlayerWins() async {
    final current = _prefs.getInt(_keyPlayerWins) ?? 0;
    await _prefs.setInt(_keyPlayerWins, current + 1);
  }

  @override
  Future<void> incrementAiWins() async {
    final current = _prefs.getInt(_keyAiWins) ?? 0;
    await _prefs.setInt(_keyAiWins, current + 1);
  }

  @override
  Future<void> incrementDraws() async {
    final current = _prefs.getInt(_keyDraws) ?? 0;
    await _prefs.setInt(_keyDraws, current + 1);
  }

  @override
  Future<void> resetStats() async {
    await _prefs.remove(_keyPlayerWins);
    await _prefs.remove(_keyAiWins);
    await _prefs.remove(_keyDraws);
  }
}
