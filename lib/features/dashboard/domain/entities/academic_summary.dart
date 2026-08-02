class SubjectSummary {
  const SubjectSummary({
    required this.id,
    required this.name,
    required this.assessmentCount,
    required this.average,
    required this.isWeighted,
  });

  final String id;
  final String name;
  final int assessmentCount;
  final double? average;
  final bool isWeighted;
}

class StudentAcademicSummary {
  const StudentAcademicSummary({
    required this.id,
    required this.studentCard,
    required this.university,
    required this.subjects,
  });

  final String id;
  final String studentCard;
  final String? university;
  final List<SubjectSummary> subjects;

  double? get overallAverage {
    final values = subjects.map((item) => item.average).whereType<double>();
    if (values.isEmpty) return null;
    return values.reduce((left, right) => left + right) / values.length;
  }
}
