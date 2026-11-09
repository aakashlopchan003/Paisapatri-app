import '../entities/transaction.dart';

/// How a screen asks for transactions. The screen does not read storage itself.
abstract class TransactionRepository {
  List<Transaction> loadAll();
}
