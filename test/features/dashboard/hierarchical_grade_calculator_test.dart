import 'package:cum_master/features/activities/domain/activity.dart';
import 'package:cum_master/features/assessments/domain/entities/assessment.dart';
import 'package:cum_master/features/dashboard/application/hierarchical_grade_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculator = HierarchicalGradeCalculator();
  final now = DateTime.utc(2026);

  Assessment evaluation(String id, double grade, {double? weight}) =>
      Assessment(
        id: id,
        subjectId: 'subject',
        name: id,
        score: grade,
        maxScore: 10,
        weight: weight,
        createdAt: now,
        updatedAt: now,
      );
  Activity activity(String id, double grade, double weight) => Activity(
    id: id,
    assessmentId: 'evaluation',
    name: id,
    score: grade,
    maxScore: 10,
    weight: weight,
    createdAt: now,
    updatedAt: now,
  );

  test('uses the manual evaluation grade when there are no activities', () {
    expect(calculator.evaluationGrade(evaluation('E1', 8.5), const []), 8.5);
  });

  test('calculates 9.2 from three tasks and one partial', () {
    final grade = calculator.evaluationGrade(evaluation('E1', 10), [
      activity('Task 1', 10, 20),
      activity('Task 2', 10, 20),
      activity('Task 3', 10, 20),
      activity('Parcial', 8, 40),
    ]);
    expect(grade, closeTo(9.2, 0.0001));
  });

  test('uses remaining weight for the average of unweighted evaluations', () {
    final grade = calculator.subjectGrade([
      (assessment: evaluation('E1', 8, weight: 30), grade: 8.0),
      (assessment: evaluation('E2', 9), grade: 9.0),
      (assessment: evaluation('E3', 7), grade: 7.0),
    ]);
    expect(grade, closeTo(8.0, 0.0001));
  });

  test('calculates the reported five-evaluation average as 8.52', () {
    final grades = [6.3, 10.0, 10.0, 6.3, 10.0];
    final calculated = calculator.subjectGrade([
      for (var index = 0; index < grades.length; index++)
        (
          assessment: evaluation('E${index + 1}', grades[index]),
          grade: grades[index],
        ),
    ]);

    expect(calculated, closeTo(8.52, 0.0001));
  });

  test('does not calculate activities until their weight totals 100', () {
    expect(
      calculator.evaluationGrade(evaluation('E1', 9), [
        activity('Task', 10, 20),
      ]),
      isNull,
    );
  });
}
