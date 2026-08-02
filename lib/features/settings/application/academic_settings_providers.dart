import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/academic_data_revision.dart';
import '../../students/application/student_providers.dart';
import '../data/sqlite_academic_settings_repository.dart';
import '../domain/academic_settings.dart';
import '../domain/academic_settings_repository.dart';

final academicSettingsRepositoryProvider = Provider<AcademicSettingsRepository>(
  (ref) =>
      SqliteAcademicSettingsRepository(ref.watch(studentsDatabaseProvider)),
);

final academicSettingsProvider = FutureProvider<AcademicSettings>(
  (ref) => ref.watch(academicSettingsRepositoryProvider).get(),
);

class AcademicSettingsActions {
  const AcademicSettingsActions(this.ref);
  final Ref ref;

  Future<void> save(AcademicSettings settings) async {
    await ref.read(academicSettingsRepositoryProvider).save(settings);
    ref.invalidate(academicSettingsProvider);
    ref.read(academicDataRevisionProvider.notifier).bump();
  }

  Future<void> applyCreditUnits(double value) async {
    await ref
        .read(academicSettingsRepositoryProvider)
        .applyDefaultCreditUnitsToAllSubjects(value);
    ref.read(academicDataRevisionProvider.notifier).bump();
  }
}

final academicSettingsActionsProvider = Provider(AcademicSettingsActions.new);
