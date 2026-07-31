class Student {
  Student({
    required String id,
    required String studentCard,
    String? university,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : id = _requiredTrimmed(id, 'id'),
       studentCard = _requiredTrimmed(studentCard, 'studentCard'),
       university = _optionalTrimmed(university),
       createdAt = _requiredUtc(createdAt, 'createdAt'),
       updatedAt = _validUpdatedAt(createdAt, updatedAt);

  final String id;
  final String studentCard;
  final String? university;
  final DateTime createdAt;
  final DateTime updatedAt;

  Student copyWith({
    String? studentCard,
    Object? university = _notProvided,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id,
      studentCard: studentCard ?? this.studentCard,
      university: identical(university, _notProvided)
          ? this.university
          : university as String?,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String _requiredTrimmed(String value, String name) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, name, 'Must not be empty');
    }
    return trimmed;
  }

  static DateTime _requiredUtc(DateTime value, String name) {
    if (!value.isUtc) {
      throw ArgumentError.value(value, name, 'Must use UTC');
    }
    return value;
  }

  static DateTime _validUpdatedAt(DateTime createdAt, DateTime updatedAt) {
    _requiredUtc(updatedAt, 'updatedAt');
    if (updatedAt.isBefore(createdAt)) {
      throw ArgumentError.value(
        updatedAt,
        'updatedAt',
        'Must not be before createdAt',
      );
    }
    return updatedAt;
  }

  static String? _optionalTrimmed(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Student &&
            id == other.id &&
            studentCard == other.studentCard &&
            university == other.university &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, studentCard, university, createdAt, updatedAt);
}

const _notProvided = Object();
