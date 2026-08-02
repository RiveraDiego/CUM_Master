import 'package:cum_master/features/cycles/data/cycle_repository_sqlite.dart';
import 'package:cum_master/features/cycles/domain/entities/academic_cycle.dart';
import 'package:cum_master/features/settings/data/sqlite_academic_settings_repository.dart';
import 'package:cum_master/features/settings/domain/academic_settings.dart';
import 'package:cum_master/features/students/application/student_use_cases.dart';
import 'package:cum_master/features/students/data/datasources/student_local_data_source.dart';
import 'package:cum_master/features/students/data/local/students_database.dart';
import 'package:cum_master/features/students/data/repositories/sqlite_student_repository.dart';
import 'package:cum_master/features/subjects/application/subject_use_cases.dart';
import 'package:cum_master/features/subjects/data/datasources/subject_local_data_source.dart';
import 'package:cum_master/features/subjects/data/repositories/sqlite_subject_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('rounds one decimal conventionally by default', () {
    expect(AcademicSettings.defaults.format(8.52), '8.5');
    expect(AcademicSettings.defaults.format(8.55), '8.6');
    expect(AcademicSettings.defaults.format(8.10), '8.1');
  });

  test('persists settings and applies UV to existing subjects', () async {
    final database = StudentsDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    addTearDown(database.close);
    final settingsRepository = SqliteAcademicSettingsRepository(database);
    final students = SqliteStudentRepository(StudentLocalDataSource(database));
    final subjects = SqliteSubjectRepository(SubjectLocalDataSource(database));
    final cycles = SqliteCycleRepository(database);
    final student = await CreateStudent(students)(studentCard: 'SET-1');
    final now = DateTime.now().toUtc();
    final cycle = AcademicCycle(
      id: 'cycle-1',
      studentId: student.id,
      name: 'Semestre I',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    await cycles.create(cycle);
    await CreateSubject(subjects)(
      studentId: student.id,
      cycleId: cycle.id,
      name: 'Cálculo',
      creditUnits: 2,
    );
    const settings = AcademicSettings(
      defaultCreditUnits: 4,
      decimalPlaces: 2,
      roundingMode: GradeRoundingMode.nearest,
      cycleSingular: 'Semestre',
      cyclePlural: 'Semestres',
    );

    await settingsRepository.save(settings);
    await settingsRepository.applyDefaultCreditUnitsToAllSubjects(4);

    final restored = await settingsRepository.get();
    expect(restored.defaultCreditUnits, 4);
    expect(restored.decimalPlaces, 2);
    expect(restored.roundingMode, GradeRoundingMode.nearest);
    expect(restored.cyclePlural, 'Semestres');
    expect((await ListSubjects(subjects)(student.id)).single.creditUnits, 4);
  });
}
