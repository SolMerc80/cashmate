import 'package:drift/drift.dart';
import 'categories.dart';

class CategoryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  DateTimeColumn get createdAt => dateTime()();
}