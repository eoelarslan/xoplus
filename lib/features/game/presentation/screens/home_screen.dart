import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xoplus/core/widgets/primary_button.dart';

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
              onPressed: () => GoRouter.of(context).push('/game', extra: {'vsAi': false}),
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "Play vs AI",
              onPressed: () => GoRouter.of(context).push('/game', extra: {'vsAi': true}),
              icon: Icons.computer,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  label: "Stats",
                  onPressed: () => GoRouter.of(context).push('/stats'),
                  icon: Icons.bar_chart,
                ),
                const SizedBox(width: 16),
                PrimaryButton(
                  label: "Settings",
                  onPressed: () => GoRouter.of(context).push('/settings'),
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
