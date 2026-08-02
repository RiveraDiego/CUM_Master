class SubjectSummary {
  const SubjectSummary({
    required this.id,
    required this.name,
    required this.assessmentCount,
    required this.average,
    required this.isWeighted,
    required this.creditUnits,
    required this.cycleId,
  });

  final String id;
  final String name;
  final int assessmentCount;
  final double? average;
  final bool isWeighted;
  final double creditUnits;
  final String cycleId;
}

class StudentAcademicSummary {
  const StudentAcademicSummary({
    required this.id,
    required this.studentCard,
    required this.university,
    required this.activeCycleName,
    required this.subjects,
    required this.generalCum,
  });

  final String id;
  final String studentCard;
  final String? university;
  final String? activeCycleName;
  final List<SubjectSummary> subjects;
  final double? generalCum;

  double? get overallAverage {
    final values = subjects.map((item) => item.average).whereType<double>();
    if (values.isEmpty) return null;
    final graded = subjects.where((item) => item.average != null).toList();
    final units = graded.fold<double>(0, (sum, item) => sum + item.creditUnits);
    return graded.fold<double>(
          0,
          (sum, item) => sum + item.average! * item.creditUnits,
        ) /
        units;
  }
}
