import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/transactions.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'budget_db');
  }

  // Reactive Stream Query for UI updates
  Stream<List<Transaction>> watchAllTransactions() {
    return (select(transactions)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();
  }

  // Insert Transaction
  Future<int> addTransaction(TransactionsCompanion entry) {
    return into(transactions).insert(entry);
  }
}