import '../domain/entities/transaction.dart';
import '../domain/repositories/transaction_repository.dart';

/// Made-up transactions so the list screen can be built before real capture
/// exists. Names and amounts are invented. Replaced by the database later.
class SampleTransactionRepository implements TransactionRepository {
  const SampleTransactionRepository();

  @override
  List<Transaction> loadAll() => [
        Transaction(
          title: 'Noodle house',
          category: 'Food & Dining',
          amount: -350,
          date: DateTime(2026, 11, 8),
        ),
        Transaction(
          title: 'Office pay',
          category: 'Salary',
          amount: 42000,
          date: DateTime(2026, 11, 1),
        ),
        Transaction(
          title: 'Corner grocery',
          category: 'Groceries',
          amount: -1250.5,
          date: DateTime(2026, 11, 7),
        ),
        Transaction(
          title: 'City bus pass',
          category: 'Transport',
          amount: -600,
          date: DateTime(2026, 11, 6),
        ),
        Transaction(
          title: 'Mobile data pack',
          category: 'Mobile & Internet',
          amount: -499,
          date: DateTime(2026, 11, 5),
        ),
        Transaction(
          title: 'Festival bonus',
          category: 'Bonus',
          amount: 15000,
          date: DateTime(2026, 11, 3),
        ),
        Transaction(
          title: 'Monthly deposit',
          category: 'Savings & Investment',
          amount: -5000,
          date: DateTime(2026, 11, 2),
        ),
        Transaction(
          title: 'Unknown shop',
          category: 'Uncategorised',
          amount: -275,
          date: DateTime(2026, 11, 4),
        ),
      ];
}
