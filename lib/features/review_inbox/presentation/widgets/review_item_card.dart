import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// One item waiting in the review inbox: what it is, why it needs a look,
/// and two actions. The actions are empty until the real flow is built.
class ReviewItemCard extends StatelessWidget {
  const ReviewItemCard({
    super.key,
    required this.title,
    required this.amount,
    required this.reason,
  });

  final String title;

  /// Positive means money in. Negative means money out.
  final double amount;

  /// Short plain-words explanation of why the app was not sure.
  final String reason;

  @override
  Widget build(BuildContext context) {
    final isIncome = amount > 0;
    return Card(
      color: AppColors.surface,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  // Sign shown as well as colour, so it reads without colour.
                  '${isIncome ? '+' : '-'} Rs. ${amount.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isIncome ? AppColors.income : AppColors.expense,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // The icon means "needs review" even without the amber colour.
                const Icon(Icons.info_outline,
                    size: 16, color: AppColors.review),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    reason,
                    style: const TextStyle(color: AppColors.review),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Wrap, not Row: on a narrow phone the second button drops to a
            // new line instead of being cut off.
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brandPrimary,
                    foregroundColor: AppColors.surface,
                  ),
                  child: const Text('Pick category'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.brandPrimary,
                    side: const BorderSide(color: AppColors.brandPrimary),
                  ),
                  child: const Text('Skip'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
