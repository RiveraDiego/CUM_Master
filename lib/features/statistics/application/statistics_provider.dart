import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/academic_data_revision.dart';
import '../../activities/application/activity_providers.dart';
import '../../assessments/application/assessment_providers.dart';
import '../../assessments/domain/entities/assessment.dart';
import '../../cycles/application/cycle_providers.dart';
import '../../dashboard/application/hierarchical_grade_calculator.dart';
import '../../students/application/student_providers.dart';
import '../../subjects/application/subject_providers.dart';
import '../../subjects/domain/entities/subject.dart';
import '../domain/academic_history.dart';

final academicHistoryProvider = FutureProvider<List<StudentAcademicHistory>>((
  ref,
) async {
  ref.watch(academicDataRevisionProvider);
  const calculator = HierarchicalGradeCalculator();
  final students = await ref.read(listStudentsProvider)();
  final histories = <StudentAcademicHistory>[];

  for (final student in students) {
    final cycles = await ref.read(cycleRepositoryProvider).getAll(student.id);
    final orderedCycles = [...cycles]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final subjects = await ref.read(listSubjectsProvider)(student.id);
    final grades = <String, double>{};

    for (final subject in subjects) {
      final assessments = await ref.read(listAssessmentsProvider)(subject.id);
      final calculated = <({Assessment assessment, double grade})>[];
      for (final assessment in assessments) {
        final activities = await ref.read(
          activitiesProvider(assessment.id).future,
        );
        final grade = calculator.evaluationGrade(assessment, activities);
        if (grade != null) {
          calculated.add((assessment: assessment, grade: grade));
        }
      }
      final grade =
          subject.manualFinalGrade ?? calculator.subjectGrade(calculated);
      if (grade != null) grades[subject.id] = grade;
    }

    final accumulated = <Subject>[];
    final points = <CycleHistoryPoint>[];
    for (final cycle in orderedCycles) {
      final cycleSubjects = subjects
          .where((subject) => subject.cycleId == cycle.id)
          .toList();
      accumulated.addAll(cycleSubjects);
      points.add(
        CycleHistoryPoint(
          id: cycle.id,
          name: cycle.name,
          isCurrent: cycle.isActive,
          subjectCount: cycleSubjects.length,
          gradedSubjectCount: cycleSubjects
              .where((subject) => grades.containsKey(subject.id))
              .length,
          average: _weightedAverage(cycleSubjects, grades),
          cumulativeCum: _weightedAverage(accumulated, grades),
        ),
      );
    }

    histories.add(
      StudentAcademicHistory(
        id: student.id,
        name: student.name,
        studentCard: student.studentCard,
        cycles: points,
      ),
    );
  }
  return histories;
});

double? _weightedAverage(List<Subject> subjects, Map<String, double> grades) {
  final graded = subjects
      .where((subject) => grades.containsKey(subject.id))
      .toList();
  if (graded.isEmpty) return null;
  final units = graded.fold<double>(
    0,
    (total, subject) => total + subject.creditUnits,
  );
  return graded.fold<double>(
        0,
        (total, subject) => total + grades[subject.id]! * subject.creditUnits,
      ) /
      units;
}
