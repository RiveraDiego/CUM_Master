import 'package:cum_master/features/cycles/application/cycle_providers.dart';
import 'package:cum_master/features/cycles/data/cycle_repository_sqlite.dart';
import 'package:cum_master/features/cycles/domain/entities/academic_cycle.dart';
import 'package:cum_master/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:cum_master/features/students/application/student_providers.dart';
import 'package:cum_master/features/students/application/student_use_cases.dart';
import 'package:cum_master/features/students/data/datasources/student_local_data_source.dart';
import 'package:cum_master/features/students/data/local/students_database.dart';
import 'package:cum_master/features/students/data/repositories/sqlite_student_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test(
    'keeps the displayed cycle until the user chooses current again',
    () async {
      final database = StudentsDatabase(
        factory: databaseFactoryFfi,
        databasePath: inMemoryDatabasePath,
      );
      addTearDown(database.close);
      final students = SqliteStudentRepository(
        StudentLocalDataSource(database),
      );
      final cycles = SqliteCycleRepository(database);
      final student = await CreateStudent(students)(studentCard: 'TEST-1');
      final now = DateTime.now().toUtc();
      await cycles.create(
        AcademicCycle(
          id: 'cycle-1',
          studentId: student.id,
          name: 'Ciclo I',
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await cycles.create(
        AcademicCycle(
          id: 'cycle-2',
          studentId: student.id,
          name: 'Ciclo II',
          isActive: false,
          createdAt: now,
          updatedAt: now,
        ),
      );
      final container = ProviderContainer(
        overrides: [studentsDatabaseProvider.overrideWithValue(database)],
      );
      addTearDown(container.dispose);

      var summary = (await container.read(
        dashboardControllerProvider.future,
      )).single;
      expect(summary.selectedCycleId, 'cycle-1');
      expect(summary.isViewingCurrentCycle, isTrue);

      await container
          .read(cycleActionsProvider)
          .setActive(student.id, 'cycle-2');
      await container.read(dashboardControllerProvider.notifier).refresh();
      summary = container.read(dashboardControllerProvider).value!.single;
      expect(summary.currentCycleId, 'cycle-2');
      expect(summary.selectedCycleId, 'cycle-1');
      expect(summary.isViewingCurrentCycle, isFalse);

      await container
          .read(dashboardControllerProvider.notifier)
          .showCurrentCycle(student.id);
      summary = container.read(dashboardControllerProvider).value!.single;
      expect(summary.selectedCycleId, 'cycle-2');
      expect(summary.isViewingCurrentCycle, isTrue);
    },
  );
}
