import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/login_screen.dart';
import 'features/content/feed_screen.dart';
import 'features/bookings/calendar_screen.dart';
import 'features/messages/messages_screen.dart';
import 'features/profile/profile_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: WaterTrainingApp()));
}

class WaterTrainingApp extends ConsumerWidget {
  const WaterTrainingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = _buildRouter(ref);
    return MaterialApp.router(
      title: 'Water Training',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }

  GoRouter _buildRouter(WidgetRef ref) {
    final auth = ref.read(authProvider);
    return GoRouter(
      initialLocation: '/feed',
      redirect: (context, state) {
        final isLoggedIn = auth.isLoggedIn;
        final loggingIn = state.matchedLocation == '/login';
        if (!isLoggedIn && !loggingIn) return '/login';
        if (isLoggedIn && loggingIn) return '/feed';
        return null;
      },
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/feed', builder: (_, __) => const FeedScreen()),
        GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
        GoRoute(path: '/messages', builder: (_, __) => const MessagesScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    );
  }
}
