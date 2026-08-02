import 'package:cum_master/features/assessments/application/assessment_use_cases.dart';
import 'package:cum_master/features/assessments/data/datasources/assessment_local_data_source.dart';
import 'package:cum_master/features/assessments/data/repositories/sqlite_assessment_repository.dart';
import 'package:cum_master/features/assessments/domain/errors/assessment_exceptions.dart';
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
  late SqliteAssessmentRepository assessments;
  late String subjectId;

  setUpAll(sqfliteFfiInit);
  setUp(() async {
    database = StudentsDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    final students = SqliteStudentRepository(StudentLocalDataSource(database));
    final subjects = SqliteSubjectRepository(SubjectLocalDataSource(database));
    assessments = SqliteAssessmentRepository(
      AssessmentLocalDataSource(database),
    );
    final student = await CreateStudent(students)(studentCard: 'A-1');
    subjectId = (await CreateSubject(subjects)(
      studentId: student.id,
      name: 'Cálculo',
    )).id;
  });
  tearDown(() => database.close());

  test('creates, calculates and updates an assessment', () async {
    final created = await CreateAssessment(assessments)(
      subjectId: subjectId,
      name: 'Parcial 1',
      score: 8,
      maxScore: 10,
      weight: 30,
    );
    expect(created.percentage, 80);
    final updated = await UpdateAssessment(assessments)(
      id: created.id,
      subjectId: subjectId,
      name: 'Parcial final',
      score: 9,
      maxScore: 10,
      weight: 40,
    );
    expect(updated.percentage, 90);
    expect(
      (await ListAssessments(assessments)(subjectId)).single.name,
      'Parcial final',
    );
  });

  test('rejects invalid scores and duplicate names', () async {
    await CreateAssessment(assessments)(
      subjectId: subjectId,
      name: 'Quiz',
      score: 5,
      maxScore: 10,
    );
    expect(
      () => CreateAssessment(assessments)(
        subjectId: subjectId,
        name: 'quiz',
        score: 4,
        maxScore: 10,
      ),
      throwsA(isA<DuplicateAssessmentNameException>()),
    );
    expect(
      () => CreateAssessment(assessments)(
        subjectId: subjectId,
        name: 'Final',
        score: 11,
        maxScore: 10,
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('deletes an assessment', () async {
    final value = await CreateAssessment(assessments)(
      subjectId: subjectId,
      name: 'Tarea',
      score: 10,
      maxScore: 10,
    );
    await DeleteAssessment(assessments)(value.id);
    expect(await GetAssessment(assessments)(value.id), isNull);
  });
}
