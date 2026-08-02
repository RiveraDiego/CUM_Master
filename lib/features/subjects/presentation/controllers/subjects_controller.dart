import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/state/academic_data_revision.dart';
import '../../application/subject_providers.dart';
import '../../domain/entities/subject.dart';

final subjectsControllerProvider =
    AsyncNotifierProvider.family<SubjectsController, List<Subject>, String>(
      SubjectsController.new,
    );

class SubjectsController extends AsyncNotifier<List<Subject>> {
  SubjectsController(this.studentId);

  final String studentId;

  @override
  Future<List<Subject>> build() => ref.watch(listSubjectsProvider)(studentId);

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(listSubjectsProvider)(studentId),
    );
  }

  Future<void> create({required String name, String? code}) async {
    await ref.read(createSubjectProvider)(
      studentId: studentId,
      name: name,
      code: code,
    );
    await refresh();
    ref.read(academicDataRevisionProvider.notifier).bump();
  }

  Future<void> updateSubject({
    required String id,
    required String name,
    String? code,
  }) async {
    await ref.read(updateSubjectProvider)(
      id: id,
      studentId: studentId,
      name: name,
      code: code,
    );
    await refresh();
    ref.read(academicDataRevisionProvider.notifier).bump();
  }

  Future<void> delete(String id) async {
    await ref.read(deleteSubjectProvider)(id);
    await refresh();
    ref.read(academicDataRevisionProvider.notifier).bump();
  }
}
