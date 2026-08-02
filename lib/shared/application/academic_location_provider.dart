import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/assessments/application/assessment_providers.dart';
import '../../features/cycles/application/cycle_providers.dart';
import '../../features/students/application/student_providers.dart';
import '../../features/subjects/application/subject_providers.dart';

class AcademicLocation {
  const AcademicLocation({
    required this.student,
    required this.cycle,
    required this.subject,
    this.assessment,
  });

  final String student;
  final String cycle;
  final String subject;
  final String? assessment;
}

final subjectLocationProvider =
    FutureProvider.family<AcademicLocation?, String>((ref, subjectId) async {
      final subject = await ref.watch(getSubjectProvider)(subjectId);
      if (subject == null) return null;
      final student = await ref.watch(getStudentProvider)(subject.studentId);
      final cycles = await ref
          .watch(cycleRepositoryProvider)
          .getAll(subject.studentId);
      final cycle = cycles
          .where((item) => item.id == subject.cycleId)
          .firstOrNull;
      return AcademicLocation(
        student: student?.name ?? student?.studentCard ?? '',
        cycle: cycle?.name ?? '',
        subject: subject.name,
      );
    });

final assessmentLocationProvider =
    FutureProvider.family<AcademicLocation?, String>((ref, assessmentId) async {
      final assessment = await ref.watch(getAssessmentProvider)(assessmentId);
      if (assessment == null) return null;
      final parent = await ref.watch(
        subjectLocationProvider(assessment.subjectId).future,
      );
      if (parent == null) return null;
      return AcademicLocation(
        student: parent.student,
        cycle: parent.cycle,
        subject: parent.subject,
        assessment: assessment.name,
      );
    });
