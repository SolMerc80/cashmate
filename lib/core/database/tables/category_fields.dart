import 'package:drift/drift.dart';
import 'categories.dart';

class CategoryFields extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get fieldName => text()();
  TextColumn get fieldType => text()(); // 'text', 'number', 'date', 'boolean'
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}