import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xoplus/features/game/presentation/game_provider.dart';
import 'package:xoplus/features/game/domain/game_types.dart';
import 'package:xoplus/features/settings/presentation/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AI plays immediately after X fourth move in Infinite Shift', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    int resolver(
      List<Player?> board,
      Player aiPlayer, {
      required GameMode mode,
      required List<int> xMoves,
      required List<int> oMoves,
    }) {
      if (oMoves.length >= 3) {
        return oMoves.first;
      }
      for (var i = 0; i < board.length; i++) {
        if (board[i] == null) return i;
      }
      return 0;
    }

    final container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      bestMoveResolverProvider.overrideWithValue(resolver),
      aiMoveDelayProvider.overrideWithValue(const Duration.zero),
    ]);
    addTearDown(container.dispose);

    final controller = container.read(gameControllerProvider.notifier);
    controller.startGame(vsAi: true, mode: GameMode.infiniteShift);

    await controller.makeMove(0);
    await controller.makeMove(2);
    await controller.makeMove(4);

    await controller.makeMove(6);

    final state = container.read(gameControllerProvider);
    expect(state.currentPlayer, Player.x);
    expect(state.oMoves, [3, 5, 1]);
    expect(state.board[1], Player.o);
  });
}
