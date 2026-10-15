// lib/core/database/transaction_dao.dart
import 'package:drift/drift.dart';
import 'app_database.dart';
import 'tables/transactions.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Future<int> insertTransaction({
    required String title,
    required double amount,
    required DateTime date,
    required String category,
    bool isExpense = true,
  }) =>
      into(db.transactions).insert(TransactionsCompanion(
        title: Value(title),
        amount: Value(amount),
        date: Value(date),
        category: Value(category),
        isExpense: Value(isExpense),
      ));

  Stream<List<Transaction>> watchAllTransactions() =>
      select(db.transactions).watch();

  // Example of a filtered stream (e.g., only expenses)
  Stream<List<Transaction>> watchExpenses() => (select(db.transactions)
        ..where((t) => t.isExpense.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.date)]))
      .watch();
}
