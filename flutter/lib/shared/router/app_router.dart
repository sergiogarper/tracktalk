import 'package:go_router/go_router.dart';
import '../../shared/models/cancion_model.dart';
import '../../features/auth/login_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/player/player_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/player',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final cancion = extra?['cancion'] as Cancion?;
        final from = extra?['from'] as String? ?? 'home';

        return PlayerScreen(
          cancion: cancion,
          from: from,
        );
      },
    ),
  ],
);
