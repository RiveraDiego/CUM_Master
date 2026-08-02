import 'package:cum_master/features/cycles/data/cycle_repository_sqlite.dart';
import 'package:cum_master/features/cycles/domain/entities/academic_cycle.dart';
import 'package:cum_master/features/cycles/domain/errors/cycle_exceptions.dart';
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
  late StudentsDatabase database;
  late SqliteCycleRepository cycles;
  late SqliteSubjectRepository subjects;
  late String studentId;

  setUpAll(sqfliteFfiInit);
  setUp(() async {
    database = StudentsDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    final students = SqliteStudentRepository(StudentLocalDataSource(database));
    cycles = SqliteCycleRepository(database);
    subjects = SqliteSubjectRepository(SubjectLocalDataSource(database));
    studentId = (await CreateStudent(students)(studentCard: 'A-1')).id;
  });
  tearDown(() => database.close());

  test('starts without a cycle and allows at most one current cycle', () async {
    final initial = await cycles.getAll(studentId);
    expect(initial, isEmpty);

    final now = DateTime.now().toUtc();
    await cycles.create(
      AcademicCycle(
        id: 'cycle-2',
        studentId: studentId,
        name: 'Ciclo 02-2026',
        isActive: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await cycles.setActive(studentId, 'cycle-2');

    final updated = await cycles.getAll(studentId);
    expect(updated.singleWhere((item) => item.isActive).id, 'cycle-2');
    await cycles.clearActive(studentId);
    expect(
      (await cycles.getAll(studentId)).any((item) => item.isActive),
      isFalse,
    );
  });

  test('associates a subject and protects a cycle in use', () async {
    final now = DateTime.now().toUtc();
    final cycle = AcademicCycle(
      id: 'cycle-history',
      studentId: studentId,
      name: 'Ciclo I',
      isActive: false,
      createdAt: now,
      updatedAt: now,
    );
    await cycles.create(cycle);
    final subject = await CreateSubject(subjects)(
      studentId: studentId,
      cycleId: cycle.id,
      name: 'Programación',
    );
    expect(subject.cycleId, cycle.id);
    expect(() => cycles.delete(cycle.id), throwsA(isA<CycleInUseException>()));
  });
}
