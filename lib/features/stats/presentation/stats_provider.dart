import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/presentation/settings_provider.dart';
import '../domain/stats_entity.dart';
import '../domain/stats_repository.dart';
import '../data/stats_repository_impl.dart';

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StatsRepositoryImpl(prefs);
});

final statsControllerProvider =
    StateNotifierProvider<StatsController, StatsEntity>((ref) {
  final repository = ref.watch(statsRepositoryProvider);
  return StatsController(repository);
});

class StatsController extends StateNotifier<StatsEntity> {
  final StatsRepository _repository;

  StatsController(this._repository) : super(const StatsEntity()) {
    _loadStats();
  }

  Future<void> _loadStats() async {
    state = await _repository.loadStats();
  }

  Future<void> recordPlayerWin() async {
    await _repository.incrementPlayerWins();
    await _loadStats();
  }

  Future<void> recordAiWin() async {
    await _repository.incrementAiWins();
    await _loadStats();
  }

  Future<void> recordDraw() async {
    await _repository.incrementDraws();
    await _loadStats();
  }

  Future<void> resetStats() async {
    await _repository.resetStats();
    await _loadStats();
  }
}
