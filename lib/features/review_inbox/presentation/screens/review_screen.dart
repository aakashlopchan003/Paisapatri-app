import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../widgets/review_item_card.dart';

/// The review inbox: unclear items wait here in a list (batched review).
/// Nothing pops up after a payment. The items below are made up for now.
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ReviewItemCard(
            title: 'Unknown merchant',
            amount: -1800,
            reason: 'No category matched this payee',
          ),
          ReviewItemCard(
            title: 'Remark: "Fam..."',
            amount: -2500,
            reason: 'Remark was cut short',
          ),
          ReviewItemCard(
            title: 'Incoming transfer',
            amount: 9000,
            reason: 'Could be income or a refund',
          ),
        ],
      ),
    );
  }
}
