import '../domain/entities/transaction.dart';

/// Eight made-up rows for the list screen.
/// Names and amounts are invented. No real message is copied here.
class SampleTransactions {
  static final List<Transaction> all = <Transaction>[
    Transaction(
      title: 'Festival bonus',
      category: 'Bonus',
      amount: 8000,
      date: DateTime(2026, 11, 8),
    ),
    Transaction(
      title: 'Office pay',
      category: 'Salary',
      amount: 42000,
      date: DateTime(2026, 11, 7),
    ),
    Transaction(
      title: 'Room rent',
      category: 'Rent/Housing',
      amount: -12000,
      date: DateTime(2026, 11, 6),
    ),
    Transaction(
      title: 'Power bill',
      category: 'Utilities & Bills',
      amount: -980,
      date: DateTime(2026, 11, 5),
    ),
    Transaction(
      title: 'Hill view show',
      category: 'Entertainment & Leisure',
      amount: -490,
      date: DateTime(2026, 11, 4),
    ),
    Transaction(
      title: 'City bus',
      category: 'Transport',
      amount: -30,
      date: DateTime(2026, 11, 3),
    ),
    Transaction(
      title: 'Corner mart',
      category: 'Groceries',
      amount: -1250.50,
      date: DateTime(2026, 11, 2),
    ),
    Transaction(
      title: 'Noodle house',
      category: 'Food & Dining',
      amount: -350,
      date: DateTime(2026, 11, 1),
    ),
  ];
}
