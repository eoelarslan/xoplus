import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game_provider.dart';
import 'game_cell.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final board = gameState.board;
    final winningLine = gameState.winningLine;

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          final isWinningCell = winningLine?.contains(index) ?? false;
          return GameCell(
            player: board[index],
            isWinningCell: isWinningCell,
            onTap: () => ref.read(gameControllerProvider.notifier).makeMove(index),
          );
        },
      ),
    );
  }
}
