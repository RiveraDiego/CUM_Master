class AcademicCycle {
  AcademicCycle({
    required this.id,
    required this.studentId,
    required String name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  }) : name = name.trim() {
    if (id.trim().isEmpty || studentId.trim().isEmpty || this.name.isEmpty) {
      throw ArgumentError('Cycle fields are required.');
    }
  }
  final String id;
  final String studentId;
  final String name;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
}
