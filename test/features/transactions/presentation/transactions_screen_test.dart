import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paisa_patri/features/transactions/data/sample_transaction_repository.dart';
import 'package:paisa_patri/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:paisa_patri/shared/widgets/transaction_tile.dart';

void main() {
  testWidgets('shows the eight sample transactions', (tester) async {
    // Tall window so every row is built, including the ones below the fold.
    await tester.binding.setSurfaceSize(const Size(400, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: TransactionsScreen(repository: SampleTransactionRepository()),
      ),
    );

    expect(find.byType(TransactionTile), findsNWidgets(8));
    expect(find.text('Noodle house'), findsOneWidget);
    expect(find.text('Food & Dining'), findsOneWidget);
    expect(find.text('- Rs. 350.00'), findsOneWidget);
    expect(find.text('Office pay'), findsOneWidget);
    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('+ Rs. 42000.00'), findsOneWidget);
    expect(find.text('Festival bonus'), findsOneWidget);
    expect(find.text('Bonus'), findsOneWidget);
  });
}
