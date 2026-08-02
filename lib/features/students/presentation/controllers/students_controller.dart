import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/state/academic_data_revision.dart';
import '../../application/student_providers.dart';
import '../../domain/entities/student.dart';

final studentsControllerProvider =
    AsyncNotifierProvider<StudentsController, List<Student>>(
      StudentsController.new,
    );

class StudentsController extends AsyncNotifier<List<Student>> {
  @override
  Future<List<Student>> build() => ref.watch(listStudentsProvider)();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(ref.read(listStudentsProvider).call);
  }

  Future<Student> create({
    required String studentCard,
    String? name,
    String? university,
  }) async {
    final student = await ref.read(createStudentProvider)(
      studentCard: studentCard,
      name: name,
      university: university,
    );
    await refresh();
    ref.read(academicDataRevisionProvider.notifier).bump();
    return student;
  }

  Future<Student> updateStudent({
    required String studentId,
    required String studentCard,
    String? name,
    String? university,
  }) async {
    final student = await ref.read(updateStudentProvider)(
      studentId: studentId,
      studentCard: studentCard,
      name: name,
      university: university,
    );
    await refresh();
    ref.read(academicDataRevisionProvider.notifier).bump();
    return student;
  }

  Future<void> delete(String studentId) async {
    await ref.read(deleteStudentProvider)(studentId);
    await refresh();
    ref.read(academicDataRevisionProvider.notifier).bump();
  }
}
