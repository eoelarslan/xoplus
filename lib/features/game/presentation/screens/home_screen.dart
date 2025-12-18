import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xoplus/core/widgets/primary_button.dart';
import '../../../../core/router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("XOPlus")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              label: "Play vs Player",
              onPressed: () => context.push(AppRouter.game, extra: {'vsAi': false}),
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "Play vs AI",
              onPressed: () => context.push(AppRouter.game, extra: {'vsAi': true}),
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
}
