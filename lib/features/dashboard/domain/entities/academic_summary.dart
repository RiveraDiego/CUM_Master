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

class CycleSummaryOption {
  const CycleSummaryOption({
    required this.id,
    required this.name,
    required this.isCurrent,
  });

  final String id;
  final String name;
  final bool isCurrent;
}

class StudentAcademicSummary {
  const StudentAcademicSummary({
    required this.id,
    required this.studentCard,
    required this.studentName,
    required this.university,
    required this.activeCycleName,
    required this.currentCycleId,
    required this.selectedCycleId,
    required this.cycles,
    required this.subjects,
    required this.generalCum,
  });

  final String id;
  final String studentCard;
  final String? studentName;
  final String? university;
  final String? activeCycleName;
  final String? currentCycleId;
  final String? selectedCycleId;
  final List<CycleSummaryOption> cycles;
  final List<SubjectSummary> subjects;
  final double? generalCum;

  bool get isViewingCurrentCycle =>
      currentCycleId != null && selectedCycleId == currentCycleId;

  bool get hasCurrentCycle => currentCycleId != null;
  bool get hasSubjectsInViewedCycle => subjects.isNotEmpty;
  bool get hasAssessmentsInViewedCycle =>
      subjects.any((subject) => subject.assessmentCount > 0);
  bool get isInitialSetupComplete =>
      hasCurrentCycle &&
      hasSubjectsInViewedCycle &&
      hasAssessmentsInViewedCycle;

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
