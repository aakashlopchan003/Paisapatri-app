import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Placeholder until settings are built.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: const Center(
        child: Text(
          'Settings will appear here.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
