import 'package:cum_master/features/students/application/student_use_cases.dart';
import 'package:cum_master/features/students/data/datasources/student_local_data_source.dart';
import 'package:cum_master/features/students/data/local/students_database.dart';
import 'package:cum_master/features/students/data/repositories/sqlite_student_repository.dart';
import 'package:cum_master/features/students/domain/entities/student.dart';
import 'package:cum_master/features/students/domain/errors/student_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

void main() {
  late StudentsDatabase database;
  late SqliteStudentRepository repository;
  late CreateStudent createStudent;

  setUpAll(sqfliteFfiInit);

  setUp(() {
    database = StudentsDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    repository = SqliteStudentRepository(StudentLocalDataSource(database));
    createStudent = CreateStudent(repository, const Uuid());
  });

  tearDown(() => database.close());

  test('creates, lists and gets a normalized student', () async {
    final created = await createStudent(
      studentCard: '  AB-123  ',
      university: '  UES  ',
    );

    expect(created.studentCard, 'AB-123');
    expect(created.university, 'UES');
    expect(await GetStudent(repository)(created.id), isNotNull);
    expect(await ListStudents(repository).call(), [created]);
  });

  test('updates and deletes a student', () async {
    final created = await createStudent(studentCard: 'A-1');
    final updated = await UpdateStudent(repository)(
      studentId: created.id,
      studentCard: 'B-2',
      university: 'UCA',
    );

    final persisted = await GetStudent(repository)(created.id);
    expect(persisted?.studentCard, 'B-2');
    expect(persisted?.university, 'UCA');
    expect(persisted?.createdAt, created.createdAt);
    expect(updated.updatedAt.isAfter(created.updatedAt), isTrue);

    await DeleteStudent(repository)(created.id);
    expect(await GetStudent(repository)(created.id), isNull);
  });

  test('rejects duplicate student cards ignoring case', () async {
    await createStudent(studentCard: 'ABC-123');

    expect(
      () => createStudent(studentCard: 'abc-123'),
      throwsA(isA<DuplicateStudentCardException>()),
    );
  });

  test('rejects a duplicate student card during update', () async {
    final first = await createStudent(studentCard: 'A-1');
    final second = await createStudent(studentCard: 'B-2');

    expect(
      () => UpdateStudent(repository)(
        studentId: second.id,
        studentCard: first.studentCard.toLowerCase(),
      ),
      throwsA(isA<DuplicateStudentCardException>()),
    );
  });

  test('reports updates and deletions for missing students', () async {
    final missing = Student(
      id: 'missing',
      studentCard: 'A-1',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

    expect(
      () => UpdateStudent(repository)(
        studentId: missing.id,
        studentCard: missing.studentCard,
      ),
      throwsA(isA<StudentNotFoundException>()),
    );
    expect(
      () => repository.delete(missing.id),
      throwsA(isA<StudentNotFoundException>()),
    );
  });

  test('rejects an empty student card before persistence', () async {
    expect(
      () => createStudent(studentCard: '   '),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('normalizes an empty university to null during update', () async {
    final created = await createStudent(studentCard: 'A-1', university: 'UES');

    await UpdateStudent(repository)(
      studentId: created.id,
      studentCard: created.studentCard,
      university: '   ',
    );

    expect((await GetStudent(repository)(created.id))?.university, isNull);
  });

  test('shares one handle for concurrent database opens', () async {
    final handles = await Future.wait(
      List.generate(8, (_) => database.database),
    );

    expect(handles.toSet(), hasLength(1));
  });
}
