import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Builds the one light theme for the whole app.
/// Kept in its own class so screens do not each invent a ThemeData.
class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.brandPrimary,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.cream,
    );
  }
}
