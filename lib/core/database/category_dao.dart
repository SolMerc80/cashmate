import 'package:drift/drift.dart';
import 'app_database.dart';
import 'tables/categories.dart';
import 'tables/category_fields.dart';
import 'tables/category_entries.dart';
import 'tables/category_entry_values.dart';

part 'category_dao.g.dart';

class CategoryFull {
  final Category category;
  final CategoryField field;
  final CategoryEntry entry;
  final CategoryEntryValue entryValue;

  const CategoryFull({
    required this.category,
    required this.field,
    required this.entry,
    required this.entryValue,
  });

  factory CategoryFull.fromRow(TypedResult row, AppDatabase db) {
    return CategoryFull(
      category: row.readTable(db.categories),
      field: row.readTable(db.categoryFields),
      entry: row.readTable(db.categoryEntries),
      entryValue: row.readTable(db.categoryEntryValues),
    );
  }
}

@DriftAccessor(tables: [
  Categories,
  CategoryFields,
  CategoryEntries,
  CategoryEntryValues,
])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  // ── Category CRUD ──────────────────────────────────────────────────────
  Future<int> insertCategory(String name, String type, {String? icon}) =>
      into(db.categories).insert(CategoriesCompanion(
        name: Value(name),
        type: Value(type),
        icon: Value(icon),
      ));

  Stream<List<Category>> watchAllCategories() =>
      select(db.categories).watch();

  // ── Field CRUD ────────────────────────────────────────────────────────
  Future<int> insertField(
    int categoryId,
    String fieldName,
    String fieldType, {
    int sortOrder = 0,
  }) =>
      into(db.categoryFields).insert(CategoryFieldsCompanion(
        categoryId: Value(categoryId),
        fieldName: Value(fieldName),
        fieldType: Value(fieldType),
        sortOrder: Value(sortOrder),
      ));

  // ── Entry & Entry‑value CRUD ────────────────────────────────────────
  Future<int> insertEntry(int categoryId, DateTime createdAt) =>
      into(db.categoryEntries).insert(CategoryEntriesCompanion(
        categoryId: Value(categoryId),
        createdAt: Value(createdAt),
      ));

  Future<void> insertEntryValue({
    required int entryId,
    required int fieldId,
    required String? value,
  }) =>
      into(db.categoryEntryValues).insert(CategoryEntryValuesCompanion(
        entryId: Value(entryId),
        fieldId: Value(fieldId),
        value: Value(value),
      ));

  // ── Convenience: get a full “category with its fields & entries” ─────
  Future<List<CategoryFull>> getCategoryFull(int categoryId) async {
    final query = select(db.categories).join([
      innerJoin(db.categoryFields,
          db.categoryFields.categoryId.equalsExp(db.categories.id)),
      innerJoin(db.categoryEntries,
          db.categoryEntries.categoryId.equalsExp(db.categories.id)),
      innerJoin(
          db.categoryEntryValues,
          db.categoryEntryValues.entryId
                  .equalsExp(db.categoryEntries.id) &
              db.categoryEntryValues.fieldId.equalsExp(db.categoryFields.id)),
    ])
      ..where(db.categories.id.equals(categoryId));

    // Map the joined rows into a custom data class.
    return query.map((row) => CategoryFull.fromRow(row, db)).get();
  }
}
