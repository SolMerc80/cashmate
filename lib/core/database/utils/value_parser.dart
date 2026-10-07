// lib/core/database/utils/value_parser.dart

class ValueParser {
  /// Convert a typed value TO string for storage
  static String serialize(String fieldType, dynamic value) {
    switch (fieldType) {
      case 'number':
        return (value as num).toString();
      case 'date':
        return (value as DateTime).toIso8601String();
      case 'boolean':
        return (value as bool) ? '1' : '0';
      case 'text':
      default:
        return value.toString();
    }
  }

  /// Parse a string FROM storage back to its typed value
  static dynamic deserialize(String fieldType, String? value) {
    if (value == null) return null;
    switch (fieldType) {
      case 'number':
        return double.tryParse(value) ?? 0.0;
      case 'date':
        return DateTime.tryParse(value);
      case 'boolean':
        return value == '1';
      case 'text':
      default:
        return value;
    }
  }
}
