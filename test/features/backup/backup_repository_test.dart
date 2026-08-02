import 'dart:convert';

import 'package:cum_master/features/backup/data/sqlite_backup_repository.dart';
import 'package:cum_master/features/backup/domain/backup_exceptions.dart';
import 'package:cum_master/features/cycles/data/cycle_repository_sqlite.dart';
import 'package:cum_master/features/cycles/domain/entities/academic_cycle.dart';
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
  late SqliteBackupRepository backup;
  late SqliteStudentRepository students;
  late SqliteCycleRepository cycles;
  late SqliteSubjectRepository subjects;

  setUpAll(sqfliteFfiInit);
  setUp(() {
    database = StudentsDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    backup = SqliteBackupRepository(database);
    students = SqliteStudentRepository(StudentLocalDataSource(database));
    cycles = SqliteCycleRepository(database);
    subjects = SqliteSubjectRepository(SubjectLocalDataSource(database));
  });
  tearDown(() => database.close());

  test('exports and restores the complete relational data set', () async {
    final student = await CreateStudent(students)(
      studentCard: 'AB-123',
      university: 'Universidad de prueba',
    );
    final now = DateTime.now().toUtc();
    final cycle = AcademicCycle(
      id: 'cycle-1',
      studentId: student.id,
      name: 'Ciclo III',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    await cycles.create(cycle);
    await CreateSubject(subjects)(
      studentId: student.id,
      cycleId: cycle.id,
      name: 'Programación',
    );

    final json = await backup.exportJson();
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    expect(decoded['format'], SqliteBackupRepository.format);
    expect((decoded['data'] as Map<String, dynamic>)['subjects'], hasLength(1));

    await DeleteStudent(students)(student.id);
    expect(await ListStudents(students)(), isEmpty);
    await backup.importJson(json);

    expect((await ListStudents(students)()).single.studentCard, 'AB-123');
    expect((await cycles.getAll(student.id)).single.name, 'Ciclo III');
    expect(
      (await ListSubjects(subjects)(student.id)).single.name,
      'Programación',
    );
  });

  test('rejects invalid files without deleting current data', () async {
    await CreateStudent(students)(studentCard: 'SAFE-1');

    expect(
      () => backup.importJson('{"format":"unknown"}'),
      throwsA(isA<InvalidBackupException>()),
    );
    expect((await ListStudents(students)()).single.studentCard, 'SAFE-1');
  });
}
