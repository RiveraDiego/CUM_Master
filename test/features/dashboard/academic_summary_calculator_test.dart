import 'package:cum_master/features/assessments/domain/entities/assessment.dart';
import 'package:cum_master/features/dashboard/application/academic_summary_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculator = AcademicSummaryCalculator();

  test('returns null without assessments', () {
    expect(calculator(const []), isNull);
  });

  test('calculates a simple average when a weight is missing', () {
    final result = calculator([
      _assessment(id: '1', score: 8, maxScore: 10),
      _assessment(id: '2', score: 10, maxScore: 10, weight: 40),
    ]);

    expect(result?.value, 90);
    expect(result?.isWeighted, isFalse);
  });

  test('normalizes the weighted average when all weights exist', () {
    final result = calculator([
      _assessment(id: '1', score: 8, maxScore: 10, weight: 30),
      _assessment(id: '2', score: 10, maxScore: 10, weight: 70),
    ]);

    expect(result?.value, 94);
    expect(result?.isWeighted, isTrue);
  });
}

Assessment _assessment({
  required String id,
  required double score,
  required double maxScore,
  double? weight,
}) {
  final now = DateTime.utc(2026);
  return Assessment(
    id: id,
    subjectId: 'subject',
    name: 'Assessment $id',
    score: score,
    maxScore: maxScore,
    weight: weight,
    createdAt: now,
    updatedAt: now,
  );
}
