import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/game_types.dart';
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
          
          bool isFaded = false;
          if (gameState.mode == GameMode.infiniteShift && gameState.status == GameStatus.playing) {
             // Check if this cell is the oldest move for the current player (who is about to move)
             // But actually, we need to fade the move that will be removed NEXT for the PLYAER WHOSE TURN IT IS?
             // No, rules say: "When a player places their 3rd move... That player's 1st move becomes FADED"
             // So if X has 3 moves, and it's X's turn, X's oldest move is faded.
             // If O has 3 moves, and it's O's turn, O's oldest move is faded.
             
             // Wait, standard rules:
             // "When that player is about to place their 4th move... Remove their oldest move"
             // "Player again has 3 moves... The oldest of these 3 becomes FADED"
             
             // So, simply: If a player has 3 moves, their oldest move is faded.
             // Irrespective of whose turn it is? 
             // "When a player places their 3rd move ... That player's 1st move becomes FADED"
             
             if (gameState.xMoves.length == 3 && gameState.xMoves.first == index) {
               isFaded = true;
             }
             if (gameState.oMoves.length == 3 && gameState.oMoves.first == index) {
               isFaded = true;
             }
          }

          return GameCell(
            player: board[index],
            isWinningCell: isWinningCell,
            isFaded: isFaded,
            onTap: () => ref.read(gameControllerProvider.notifier).makeMove(index),
          );
        },
      ),
    );
  }
}
