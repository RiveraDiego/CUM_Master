import '../../activities/domain/activity.dart';
import '../../assessments/domain/entities/assessment.dart';

class HierarchicalGradeCalculator {
  const HierarchicalGradeCalculator();

  double? evaluationGrade(Assessment evaluation, List<Activity> activities) {
    if (activities.isEmpty) return evaluation.percentage / 10;
    final totalWeight = activities.fold<double>(
      0,
      (sum, item) => sum + item.weight,
    );
    if ((totalWeight - 100).abs() > 0.001) return null;
    return activities.fold<double>(
      0,
      (sum, item) => sum + (item.percentage / 10) * item.weight / 100,
    );
  }

  double? subjectGrade(List<({Assessment assessment, double grade})> values) {
    if (values.isEmpty) return null;
    final weighted = values
        .where((item) => item.assessment.weight != null)
        .toList();
    if (weighted.isEmpty) {
      return values.fold<double>(0, (sum, item) => sum + item.grade) /
          values.length;
    }
    final explicitWeight = weighted.fold<double>(
      0,
      (sum, item) => sum + item.assessment.weight!,
    );
    if (explicitWeight > 100) return null;
    final unweighted = values
        .where((item) => item.assessment.weight == null)
        .toList();
    final weightedContribution = weighted.fold<double>(
      0,
      (sum, item) => sum + item.grade * item.assessment.weight! / 100,
    );
    if (unweighted.isEmpty) {
      return (explicitWeight - 100).abs() < 0.001 ? weightedContribution : null;
    }
    final remaining = 100 - explicitWeight;
    if (remaining <= 0) return null;
    final remainingAverage =
        unweighted.fold<double>(0, (sum, item) => sum + item.grade) /
        unweighted.length;
    return weightedContribution + remainingAverage * remaining / 100;
  }
}
