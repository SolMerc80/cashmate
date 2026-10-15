import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/transactions.dart';
import 'tables/categories.dart';
import 'tables/category_fields.dart';
import 'tables/category_entries.dart';
import 'tables/category_entry_values.dart';
import 'transaction_dao.dart';
import 'category_dao.dart';

part 'app_database.g.dart';

QueryExecutor _openConnection() {
  return driftDatabase(name: 'cashmate_db');
}

@DriftDatabase(
  tables: [
    Transactions,
    Categories,
    CategoryFields,
    CategoryEntries,
    CategoryEntryValues,
  ],
  daos: [
    TransactionDao,
    CategoryDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // ← bumped from 1 to 2

  // ── Queries ──────────────────────────────────────────────────────────────

  /// Returns a live stream of every transaction, newest first.
  Stream<List<Transaction>> watchAllTransactions() {
    return (select(transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Returns a live stream of every category, ordered by name.
  Stream<List<Category>> watchAllCategories() => select(categories).watch();

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // Called on fresh installs — creates ALL tables
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Called when existing users update the app
        if (from < 2) {
          // Only create the NEW tables added in version 2
          await m.createTable(categories);
          await m.createTable(categoryFields);
          await m.createTable(categoryEntries);
          await m.createTable(categoryEntryValues);
        }
        // Future: if (from < 3) { ... }
      },
    );
  }
}
