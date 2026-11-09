import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/transaction_tile.dart';
import '../../domain/repositories/transaction_repository.dart';

/// The Transactions tab: a plain list of rows from the repository.
class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key, required this.repository});

  final TransactionRepository repository;

  @override
  Widget build(BuildContext context) {
    final transactions = repository.loadAll();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text(
                'Your transactions will appear here.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final t = transactions[index];
                return TransactionTile(
                  title: t.title,
                  category: t.category,
                  amount: t.amount,
                );
              },
            ),
    );
  }
}
