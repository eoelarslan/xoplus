import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xoplus/core/widgets/primary_button.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/game_types.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GameMode _selectedMode = GameMode.classic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("XOPlus")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mode Selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildModeButton("Classic", GameMode.classic),
                  _buildModeButton("Infinite Shift", GameMode.infiniteShift),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            PrimaryButton(
              label: "Play vs Player",
              onPressed: () => context.push(AppRouter.game, extra: {'vsAi': false, 'mode': _selectedMode}),
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "Play vs AI",
              onPressed: () => context.push(AppRouter.game, extra: {'vsAi': true, 'mode': _selectedMode}),
              icon: Icons.computer,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  label: "Stats",
                  onPressed: () => context.push(AppRouter.stats),
                  icon: Icons.bar_chart,
                ),
                const SizedBox(width: 16),
                PrimaryButton(
                  label: "Settings",
                  onPressed: () => context.push(AppRouter.settings),
                  icon: Icons.settings,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, GameMode mode) {
    final isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _selectedMode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
