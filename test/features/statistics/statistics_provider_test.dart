import 'package:cum_master/features/cycles/data/cycle_repository_sqlite.dart';
import 'package:cum_master/features/cycles/domain/entities/academic_cycle.dart';
import 'package:cum_master/features/statistics/application/statistics_provider.dart';
import 'package:cum_master/features/students/application/student_providers.dart';
import 'package:cum_master/features/students/application/student_use_cases.dart';
import 'package:cum_master/features/students/data/datasources/student_local_data_source.dart';
import 'package:cum_master/features/students/data/local/students_database.dart';
import 'package:cum_master/features/students/data/repositories/sqlite_student_repository.dart';
import 'package:cum_master/features/subjects/application/subject_use_cases.dart';
import 'package:cum_master/features/subjects/data/datasources/subject_local_data_source.dart';
import 'package:cum_master/features/subjects/data/repositories/sqlite_subject_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('calculates cycle averages and cumulative CUM in order', () async {
    final database = StudentsDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    final students = SqliteStudentRepository(StudentLocalDataSource(database));
    final subjects = SqliteSubjectRepository(SubjectLocalDataSource(database));
    final cycles = SqliteCycleRepository(database);
    final student = await CreateStudent(students)(
      studentCard: 'HIST-1',
      name: 'Diego',
    );
    final firstDate = DateTime.utc(2025, 1);
    final secondDate = DateTime.utc(2025, 7);
    await cycles.create(
      AcademicCycle(
        id: 'cycle-1',
        studentId: student.id,
        name: 'Ciclo I',
        isActive: false,
        createdAt: firstDate,
        updatedAt: firstDate,
      ),
    );
    await cycles.create(
      AcademicCycle(
        id: 'cycle-2',
        studentId: student.id,
        name: 'Ciclo II',
        isActive: true,
        createdAt: secondDate,
        updatedAt: secondDate,
      ),
    );
    await CreateSubject(subjects)(
      studentId: student.id,
      cycleId: 'cycle-1',
      name: 'Materia I',
      creditUnits: 2,
      manualFinalGrade: 8,
    );
    await CreateSubject(subjects)(
      studentId: student.id,
      cycleId: 'cycle-2',
      name: 'Materia II',
      creditUnits: 4,
      manualFinalGrade: 10,
    );
    final container = ProviderContainer(
      overrides: [studentsDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(() async {
      container.dispose();
      await database.close();
    });

    final history = (await container.read(
      academicHistoryProvider.future,
    )).single;
    expect(history.displayName, 'Diego');
    expect(history.cycles.map((cycle) => cycle.name), ['Ciclo I', 'Ciclo II']);
    expect(history.cycles.first.average, 8);
    expect(history.cycles.first.cumulativeCum, 8);
    expect(history.cycles.last.average, 10);
    expect(history.cycles.last.cumulativeCum, closeTo(9.333, .001));
  });
}
