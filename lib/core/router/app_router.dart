import 'package:go_router/go_router.dart';
import '../../features/game/presentation/screens/splash_screen.dart';
import '../../features/game/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/stats/presentation/screens/stats_screen.dart';
import '../../features/game/presentation/screens/game_screen.dart';

class AppRouter {
  // Route paths (tek kaynak)
  static const splash = '/';
  static const home = '/home';
  static const settings = '/settings';
  static const game = '/game';
  static const stats = '/stats';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: game,
        builder: (context, state) {
          final vsAi =
              (state.extra as Map<String, dynamic>?)?['vsAi'] as bool? ?? false;
          return GameScreen(vsAi: vsAi);
        },
      ),
      GoRoute(
        path: stats,
        builder: (context, state) => const StatsScreen(),
      ),
    ],
  );
}
