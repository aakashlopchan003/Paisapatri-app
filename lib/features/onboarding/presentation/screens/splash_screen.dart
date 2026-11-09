import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// First screen: the app name on mint for two seconds, then [next] replaces it.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.next});

  /// The screen to open when the splash is over.
  final Widget next;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    // Replace, not push: the back button must not return to the splash.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => widget.next),
    );
  }

  @override
  void dispose() {
    // Stop the timer if the screen is closed early.
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.mint,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PaisaPatri',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: AppColors.brandWordmark,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your money, on your phone.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
