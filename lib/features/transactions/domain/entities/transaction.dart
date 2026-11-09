/// One transaction after parsing. The raw SMS is never stored on it.
class Transaction {
  const Transaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  });

  final String title;

  /// One of the 27 names in docs/data-schema.md, written exactly.
  final String category;

  /// Positive means money in. Negative means money out.
  final double amount;

  /// When the money moved. The list screen does not show this yet.
  final DateTime date;
}
