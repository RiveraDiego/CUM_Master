import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/state/academic_data_revision.dart';
import '../../application/assessment_providers.dart';
import '../../domain/entities/assessment.dart';

final assessmentsControllerProvider =
    AsyncNotifierProvider.family<
      AssessmentsController,
      List<Assessment>,
      String
    >(AssessmentsController.new);

class AssessmentsController extends AsyncNotifier<List<Assessment>> {
  AssessmentsController(this.subjectId);
  final String subjectId;
  @override
  Future<List<Assessment>> build() =>
      ref.watch(listAssessmentsProvider)(subjectId);
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(listAssessmentsProvider)(subjectId),
    );
  }

  Future<void> create({
    required String name,
    required double score,
    required double maxScore,
    double? weight,
  }) async {
    await ref.read(createAssessmentProvider)(
      subjectId: subjectId,
      name: name,
      score: score,
      maxScore: maxScore,
      weight: weight,
    );
    await refresh();
    ref.read(academicDataRevisionProvider.notifier).bump();
  }

  Future<void> updateValue({
    required String id,
    required String name,
    required double score,
    required double maxScore,
    double? weight,
  }) async {
    await ref.read(updateAssessmentProvider)(
      id: id,
      subjectId: subjectId,
      name: name,
      score: score,
      maxScore: maxScore,
      weight: weight,
    );
    await refresh();
    ref.read(academicDataRevisionProvider.notifier).bump();
  }

  Future<void> delete(String id) async {
    await ref.read(deleteAssessmentProvider)(id);
    await refresh();
    ref.read(academicDataRevisionProvider.notifier).bump();
  }
}
