class Subject {
  Subject({
    required String id,
    required String studentId,
    required String cycleId,
    required String name,
    String? code,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : id = _required(id, 'id'),
       studentId = _required(studentId, 'studentId'),
       cycleId = _required(cycleId, 'cycleId'),
       name = _required(name, 'name'),
       code = _optional(code),
       createdAt = _utc(createdAt, 'createdAt'),
       updatedAt = _validUpdatedAt(createdAt, updatedAt);

  final String id;
  final String studentId;
  final String cycleId;
  final String name;
  final String? code;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subject copyWith({
    String? cycleId,
    String? name,
    Object? code = _unset,
    DateTime? updatedAt,
  }) {
    return Subject(
      id: id,
      studentId: studentId,
      cycleId: cycleId ?? this.cycleId,
      name: name ?? this.name,
      code: identical(code, _unset) ? this.code : code as String?,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String _required(String value, String field) {
    final normalized = value.trim();
    if (normalized.isEmpty) throw ArgumentError.value(value, field);
    return normalized;
  }

  static String? _optional(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  static DateTime _utc(DateTime value, String field) {
    if (!value.isUtc) throw ArgumentError.value(value, field, 'Must use UTC');
    return value;
  }

  static DateTime _validUpdatedAt(DateTime createdAt, DateTime value) {
    _utc(value, 'updatedAt');
    if (value.isBefore(createdAt)) {
      throw ArgumentError.value(value, 'updatedAt');
    }
    return value;
  }
}

const _unset = Object();
