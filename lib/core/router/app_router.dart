import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/game/presentation/screens/splash_screen.dart';
import '../../features/game/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/stats/presentation/screens/stats_screen.dart';
import '../../features/game/presentation/screens/game_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: const [], // Sub-routes if needed
      ),
      GoRoute(
        path: '/game',
        builder: (context, state) {
          final vsAi = (state.extra as Map<String, dynamic>?)?['vsAi'] as bool? ?? false;
          return GameScreen(vsAi: vsAi);
        },
      ),
    ],
  );
}
