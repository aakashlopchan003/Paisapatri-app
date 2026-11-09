import 'package:flutter/material.dart';

import '../features/onboarding/presentation/screens/splash_screen.dart';
import 'app_shell.dart';
import 'theme/app_theme.dart';

/// The root widget. It sets the theme and opens the first screen.
class PaisaPatriApp extends StatelessWidget {
  /// [home] is only for tests, so they can open a screen directly.
  /// The real app starts at the splash, then the tab shell (for now).
  const PaisaPatriApp({super.key, this.home});

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaisaPatri',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: home ?? const SplashScreen(next: AppShell()),
    );
  }
}
