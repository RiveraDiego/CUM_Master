import '../../assessments/domain/entities/assessment.dart';

class AcademicAverage {
  const AcademicAverage({required this.value, required this.isWeighted});
  final double value;
  final bool isWeighted;
}

class AcademicSummaryCalculator {
  const AcademicSummaryCalculator();

  AcademicAverage? call(List<Assessment> assessments) {
    if (assessments.isEmpty) return null;
    final allWeighted = assessments.every((item) => item.weight != null);
    if (allWeighted) {
      final totalWeight = assessments.fold<double>(
        0,
        (total, item) => total + item.weight!,
      );
      final value =
          assessments.fold<double>(
            0,
            (total, item) => total + item.percentage * item.weight!,
          ) /
          totalWeight;
      return AcademicAverage(value: value, isWeighted: true);
    }
    final value =
        assessments.fold<double>(0, (total, item) => total + item.percentage) /
        assessments.length;
    return AcademicAverage(value: value, isWeighted: false);
  }
}
