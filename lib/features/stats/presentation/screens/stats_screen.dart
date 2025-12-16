import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/primary_button.dart';
import 'stats_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsControllerProvider);
    final controller = ref.read(statsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Stats")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
             Text(
              "Your Performance",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ).animate().fadeIn().slideY(begin: -0.2, end: 0),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, "Wins", stats.playerWins.toString(), Colors.green)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(context, "Losses", stats.aiWins.toString(), Colors.red)),
              ],
            ),
            const SizedBox(height: 16),
             Row(
              children: [
                Expanded(child: _buildStatCard(context, "Draws", stats.draws.toString(), Colors.orange)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(context, "Total", stats.totalGames.toString(), Colors.blue)),
              ],
            ),
            const Spacer(),
            PrimaryButton(
              label: "Reset Stats",
              icon: Icons.refresh,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Reset Stats?"),
                    content: const Text("This cannot be undone."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.resetStats();
                          Navigator.pop(context);
                        },
                        child: const Text("Reset", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ).animate().scale(delay: 200.ms),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
