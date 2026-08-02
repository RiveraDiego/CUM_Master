import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/state/academic_data_revision.dart';
import '../../../assessments/application/assessment_providers.dart';
import '../../../students/application/student_providers.dart';
import '../../../subjects/application/subject_providers.dart';
import '../../application/academic_summary_calculator.dart';
import '../../domain/entities/academic_summary.dart';

final dashboardControllerProvider =
    AsyncNotifierProvider<DashboardController, List<StudentAcademicSummary>>(
      DashboardController.new,
    );

class DashboardController extends AsyncNotifier<List<StudentAcademicSummary>> {
  @override
  Future<List<StudentAcademicSummary>> build() {
    ref.watch(academicDataRevisionProvider);
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<List<StudentAcademicSummary>> _load() async {
    const calculator = AcademicSummaryCalculator();
    final students = await ref.read(listStudentsProvider)();
    final summaries = <StudentAcademicSummary>[];
    for (final student in students) {
      final subjects = await ref.read(listSubjectsProvider)(student.id);
      final subjectSummaries = <SubjectSummary>[];
      for (final subject in subjects) {
        final assessments = await ref.read(listAssessmentsProvider)(subject.id);
        final average = calculator(assessments);
        subjectSummaries.add(
          SubjectSummary(
            id: subject.id,
            name: subject.name,
            assessmentCount: assessments.length,
            average: average?.value,
            isWeighted: average?.isWeighted ?? false,
          ),
        );
      }
      summaries.add(
        StudentAcademicSummary(
          id: student.id,
          studentCard: student.studentCard,
          university: student.university,
          subjects: subjectSummaries,
        ),
      );
    }
    return summaries;
  }
}
