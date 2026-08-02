import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/state/academic_data_revision.dart';
import '../../students/application/student_providers.dart';
import '../data/cycle_repository_sqlite.dart';
import '../domain/entities/academic_cycle.dart';
import '../domain/repositories/cycle_repository.dart';

final cycleRepositoryProvider = Provider<CycleRepository>(
  (ref) => SqliteCycleRepository(ref.watch(studentsDatabaseProvider)),
);
final cyclesProvider = FutureProvider.family<List<AcademicCycle>, String>(
  (ref, studentId) => ref.watch(cycleRepositoryProvider).getAll(studentId),
);

class CycleActions {
  const CycleActions(this.ref);
  final Ref ref;
  Future<void> create(
    String studentId,
    String name, {
    required bool active,
  }) async {
    final now = DateTime.now().toUtc();
    await ref
        .read(cycleRepositoryProvider)
        .create(
          AcademicCycle(
            id: const Uuid().v4(),
            studentId: studentId,
            name: name,
            isActive: active,
            createdAt: now,
            updatedAt: now,
          ),
        );
    ref.invalidate(cyclesProvider(studentId));
    ref.read(academicDataRevisionProvider.notifier).bump();
  }

  Future<void> setActive(String studentId, String id) async {
    await ref.read(cycleRepositoryProvider).setActive(studentId, id);
    ref.invalidate(cyclesProvider(studentId));
    ref.read(academicDataRevisionProvider.notifier).bump();
  }

  Future<void> delete(String studentId, String id) async {
    await ref.read(cycleRepositoryProvider).delete(id);
    ref.invalidate(cyclesProvider(studentId));
    ref.read(academicDataRevisionProvider.notifier).bump();
  }
}

final cycleActionsProvider = Provider(CycleActions.new);
