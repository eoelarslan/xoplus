import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/game_types.dart';
import '../game_provider.dart';
import '../widgets/board_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/glass_container.dart';

class GameScreen extends ConsumerStatefulWidget {
  final bool vsAi;

  const GameScreen({
    super.key,
    required this.vsAi,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize game on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameControllerProvider.notifier).startGame(vsAi: widget.vsAi);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final status = gameState.status;
    final currentPlayer = gameState.currentPlayer;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vsAi ? "You vs AI" : "Player vs Player"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Turn Indicator
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      status == GameStatus.playing
                          ? "${currentPlayer == Player.x ? 'X' : 'O'}'s Turn"
                          : "Game Over",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Board
              const GameBoard(),
              
              const Spacer(),

              // Status / Restart
              if (status != GameStatus.playing)
                Column(
                  children: [
                    Text(
                      status == GameStatus.win
                          ? "Winner: ${gameState.winner == Player.x ? 'X' : 'O'}!"
                          : "It's a Draw!",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

              PrimaryButton(
                label: status == GameStatus.playing ? "Restart" : "Play Again",
                icon: Icons.refresh,
                onPressed: () {
                  ref.read(gameControllerProvider.notifier).resetGame();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
