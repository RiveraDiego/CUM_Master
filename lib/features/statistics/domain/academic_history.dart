class CycleHistoryPoint {
  const CycleHistoryPoint({
    required this.id,
    required this.name,
    required this.isCurrent,
    required this.subjectCount,
    required this.gradedSubjectCount,
    required this.average,
    required this.cumulativeCum,
  });

  final String id;
  final String name;
  final bool isCurrent;
  final int subjectCount;
  final int gradedSubjectCount;
  final double? average;
  final double? cumulativeCum;
}

class StudentAcademicHistory {
  const StudentAcademicHistory({
    required this.id,
    required this.name,
    required this.studentCard,
    required this.cycles,
  });

  final String id;
  final String? name;
  final String studentCard;
  final List<CycleHistoryPoint> cycles;

  String get displayName => name ?? studentCard;
}
