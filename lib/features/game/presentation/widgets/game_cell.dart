import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:xoplus/features/game/domain/game_types.dart';
import '../../../../core/widgets/glass_container.dart';

class GameCell extends StatelessWidget {
  final Player? player;
  final VoidCallback onTap;
  final bool isWinningCell;

  const GameCell({
    super.key,
    required this.player,
    required this.onTap,
    this.isWinningCell = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: EdgeInsets.zero,
        opacity: isWinningCell ? 0.4 : 0.1,
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: _buildMark(context),
        ),
      ),
    );
  }

  Widget? _buildMark(BuildContext context) {
    if (player == null) return null;

    final cs = Theme.of(context).colorScheme;
    final isX = player == Player.x;

    final color = isX ? cs.secondary : cs.tertiary;
    final icon = isX ? Icons.close : Icons.circle_outlined;

    return Icon(
      icon,
      size: 64,
      color: color,
    )
        .animate(key: ValueKey(player))
        .scale(duration: 400.ms, curve: Curves.easeOutBack)
        .fadeIn(duration: 300.ms);
  }
}
