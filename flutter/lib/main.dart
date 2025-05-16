import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'shared/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: TrackTalkApp()));
}

class TrackTalkApp extends StatelessWidget {
  const TrackTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
