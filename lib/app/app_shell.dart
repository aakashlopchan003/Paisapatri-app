import 'package:flutter/material.dart';

import '../features/dashboard/presentation/screens/home_screen.dart';
import '../features/review_inbox/presentation/screens/review_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/transactions/data/sample_transaction_repository.dart';
import '../features/transactions/presentation/screens/transactions_screen.dart';
import 'theme/app_colors.dart';

/// The frame around the four tabs. It remembers which tab is open.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  /// 0 Home, 1 Transactions, 2 Review, 3 Settings.
  /// Kept in State so a rebuild does not jump back to Home.
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    TransactionsScreen(repository: SampleTransactionRepository()),
    ReviewScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.mint,
          // Selected tab uses the brand green. The others use the caption colour.
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 12,
              color: selected ? AppColors.brandPrimary : AppColors.textSecondary,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected ? AppColors.brandPrimary : AppColors.textSecondary,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Transactions',
            ),
            NavigationDestination(
              icon: Icon(Icons.inbox_outlined),
              selectedIcon: Icon(Icons.inbox),
              label: 'Review',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
