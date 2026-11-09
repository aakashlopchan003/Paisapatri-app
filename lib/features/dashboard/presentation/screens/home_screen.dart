import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/transaction_tile.dart';
import '../widgets/summary_card.dart';

/// The first screen: a summary and three sample transactions.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaisaPatri'),
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SummaryCard(),
          SizedBox(height: 16),
          Text(
            'Recent transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          TransactionTile(
            title: 'Cinema ticket',
            category: 'Entertainment & Leisure',
            amount: -490,
          ),
          TransactionTile(
            title: 'Supermarket',
            category: 'Groceries',
            amount: -1091.90,
          ),
          TransactionTile(
            title: 'Monthly pay',
            category: 'Salary',
            amount: 45000,
          ),
        ],
      ),
    );
  }
}
