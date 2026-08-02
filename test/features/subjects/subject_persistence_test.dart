import 'package:cum_master/features/cycles/data/cycle_repository_sqlite.dart';
import 'package:cum_master/features/cycles/domain/entities/academic_cycle.dart';
import 'package:cum_master/features/students/application/student_use_cases.dart';
import 'package:cum_master/features/students/data/datasources/student_local_data_source.dart';
import 'package:cum_master/features/students/data/local/students_database.dart';
import 'package:cum_master/features/students/data/repositories/sqlite_student_repository.dart';
import 'package:cum_master/features/subjects/application/subject_use_cases.dart';
import 'package:cum_master/features/subjects/data/datasources/subject_local_data_source.dart';
import 'package:cum_master/features/subjects/data/repositories/sqlite_subject_repository.dart';
import 'package:cum_master/features/subjects/domain/errors/subject_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late StudentsDatabase database;
  late SqliteStudentRepository students;
  late SqliteSubjectRepository subjects;
  late SqliteCycleRepository cycles;

  setUpAll(sqfliteFfiInit);

  setUp(() {
    database = StudentsDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    students = SqliteStudentRepository(StudentLocalDataSource(database));
    subjects = SqliteSubjectRepository(SubjectLocalDataSource(database));
    cycles = SqliteCycleRepository(database);
  });

  tearDown(() => database.close());

  test('keeps subjects isolated by student', () async {
    final first = await CreateStudent(students)(studentCard: 'A-1');
    final second = await CreateStudent(students)(studentCard: 'B-2');
    final firstCycle = await createCycle(cycles, first.id, 'Ciclo I');
    final secondCycle = await createCycle(cycles, second.id, 'Ciclo I');

    final math = await CreateSubject(subjects)(
      studentId: first.id,
      cycleId: firstCycle.id,
      name: '  Matemática  ',
      code: ' MAT-01 ',
    );
    await CreateSubject(subjects)(
      studentId: second.id,
      cycleId: secondCycle.id,
      name: 'Historia',
    );

    expect(await ListSubjects(subjects)(first.id), hasLength(1));
    expect((await ListSubjects(subjects)(first.id)).single.name, 'Matemática');
    expect(math.code, 'MAT-01');
    expect((await ListSubjects(subjects)(second.id)).single.name, 'Historia');
  });

  test('creates, updates and deletes a subject', () async {
    final student = await CreateStudent(students)(studentCard: 'A-1');
    final cycle = await createCycle(cycles, student.id, 'Ciclo I');
    final created = await CreateSubject(subjects)(
      studentId: student.id,
      cycleId: cycle.id,
      name: 'Programación I',
    );
    final updated = await UpdateSubject(subjects)(
      id: created.id,
      studentId: student.id,
      name: 'Programación II',
      code: 'PRG-2',
    );

    expect(updated.updatedAt.isAfter(created.updatedAt), isTrue);
    expect((await GetSubject(subjects)(created.id))?.code, 'PRG-2');
    await DeleteSubject(subjects)(created.id);
    expect(await GetSubject(subjects)(created.id), isNull);
  });

  test('rejects duplicate names only inside the same student', () async {
    final first = await CreateStudent(students)(studentCard: 'A-1');
    final second = await CreateStudent(students)(studentCard: 'B-2');
    final firstCycle = await createCycle(cycles, first.id, 'Ciclo I');
    final secondCycle = await createCycle(cycles, second.id, 'Ciclo I');
    await CreateSubject(subjects)(
      studentId: first.id,
      cycleId: firstCycle.id,
      name: 'Cálculo',
    );

    expect(
      () => CreateSubject(subjects)(
        studentId: first.id,
        cycleId: firstCycle.id,
        name: 'cálculo',
      ),
      throwsA(isA<DuplicateSubjectNameException>()),
    );
    await CreateSubject(subjects)(
      studentId: second.id,
      cycleId: secondCycle.id,
      name: 'Cálculo',
    );
  });

  test('deleting a student cascades to their subjects', () async {
    final student = await CreateStudent(students)(studentCard: 'A-1');
    final cycle = await createCycle(cycles, student.id, 'Ciclo I');
    final subject = await CreateSubject(subjects)(
      studentId: student.id,
      cycleId: cycle.id,
      name: 'Física',
    );

    await DeleteStudent(students)(student.id);

    expect(await GetSubject(subjects)(subject.id), isNull);
  });
}

Future<AcademicCycle> createCycle(
  SqliteCycleRepository repository,
  String studentId,
  String name,
) async {
  final now = DateTime.now().toUtc();
  final cycle = AcademicCycle(
    id: 'cycle-$studentId-$name',
    studentId: studentId,
    name: name,
    isActive: false,
    createdAt: now,
    updatedAt: now,
  );
  await repository.create(cycle);
  return cycle;
}
