import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/state/academic_data_revision.dart';
import '../../../assessments/application/assessment_providers.dart';
import '../../../assessments/domain/entities/assessment.dart';
import '../../../activities/application/activity_providers.dart';
import '../../../cycles/application/cycle_providers.dart';
import '../../../students/application/student_providers.dart';
import '../../../subjects/application/subject_providers.dart';
import '../../application/hierarchical_grade_calculator.dart';
import '../../domain/entities/academic_summary.dart';

final dashboardControllerProvider =
    AsyncNotifierProvider<DashboardController, List<StudentAcademicSummary>>(
      DashboardController.new,
    );

class DashboardController extends AsyncNotifier<List<StudentAcademicSummary>> {
  final _selectedCycleIds = <String, String>{};

  @override
  Future<List<StudentAcademicSummary>> build() {
    ref.watch(academicDataRevisionProvider);
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> selectCycle(String studentId, String cycleId) async {
    _selectedCycleIds[studentId] = cycleId;
    state = await AsyncValue.guard(_load);
  }

  Future<void> showCurrentCycle(String studentId) async {
    final current = state.value
        ?.where((summary) => summary.id == studentId)
        .firstOrNull
        ?.currentCycleId;
    if (current == null) return;
    await selectCycle(studentId, current);
  }

  Future<List<StudentAcademicSummary>> _load() async {
    const calculator = HierarchicalGradeCalculator();
    final students = await ref.read(listStudentsProvider)();
    final summaries = <StudentAcademicSummary>[];
    for (final student in students) {
      final subjects = await ref.read(listSubjectsProvider)(student.id);
      final cycles = await ref.read(cycleRepositoryProvider).getAll(student.id);
      final activeCycle = cycles.where((item) => item.isActive).firstOrNull;
      final requestedCycleId = _selectedCycleIds[student.id];
      final selectedCycle = activeCycle == null
          ? null
          : cycles.where((item) => item.id == requestedCycleId).firstOrNull ??
                activeCycle;
      if (selectedCycle == null) {
        _selectedCycleIds.remove(student.id);
      } else {
        _selectedCycleIds[student.id] = selectedCycle.id;
      }
      final allSubjectSummaries = <SubjectSummary>[];
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
        final finalGrade =
            subject.manualFinalGrade ?? calculator.subjectGrade(calculated);
        allSubjectSummaries.add(
          SubjectSummary(
            id: subject.id,
            name: subject.name,
            assessmentCount: assessments.length,
            average: finalGrade,
            isWeighted: assessments.any((item) => item.weight != null),
            creditUnits: subject.creditUnits,
            cycleId: subject.cycleId,
          ),
        );
      }
      summaries.add(
        StudentAcademicSummary(
          id: student.id,
          studentCard: student.studentCard,
          studentName: student.name,
          university: student.university,
          activeCycleName: activeCycle?.name,
          currentCycleId: activeCycle?.id,
          selectedCycleId: selectedCycle?.id,
          cycles: cycles
              .map(
                (cycle) => CycleSummaryOption(
                  id: cycle.id,
                  name: cycle.name,
                  isCurrent: cycle.isActive,
                ),
              )
              .toList(growable: false),
          subjects: allSubjectSummaries
              .where((item) => item.cycleId == selectedCycle?.id)
              .toList(),
          generalCum: _cum(allSubjectSummaries),
        ),
      );
    }
    return summaries;
  }

  double? _cum(List<SubjectSummary> subjects) {
    final graded = subjects.where((item) => item.average != null).toList();
    if (graded.isEmpty) return null;
    final units = graded.fold<double>(0, (sum, item) => sum + item.creditUnits);
    return graded.fold<double>(
          0,
          (sum, item) => sum + item.average! * item.creditUnits,
        ) /
        units;
  }
}
