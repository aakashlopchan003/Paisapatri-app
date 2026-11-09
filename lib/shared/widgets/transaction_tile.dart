import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// One row in a transaction list.
/// Shared so Home and the later Transactions screen can use the same row.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.title,
    required this.category,
    required this.amount,
  });

  final String title;
  final String category;

  /// Positive means money in. Negative means money out.
  final double amount;

  @override
  Widget build(BuildContext context) {
    final isIncome = amount > 0;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(category),
      trailing: Text(
        // The sign is shown as well as the colour, so the row is readable
        // without relying on colour alone.
        '${isIncome ? '+' : '-'} Rs. ${amount.abs().toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isIncome ? AppColors.income : AppColors.expense,
        ),
      ),
    );
  }
}
