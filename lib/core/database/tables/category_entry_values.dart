import 'package:drift/drift.dart';
import 'category_entries.dart';
import 'category_fields.dart';

class CategoryEntryValues extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().references(CategoryEntries, #id)();
  IntColumn get fieldId => integer().references(CategoryFields, #id)();
  TextColumn get value => text().nullable()(); // always stored as a string
}