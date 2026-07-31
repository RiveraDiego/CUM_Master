import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/student_local_data_source.dart';
import '../data/local/students_database.dart';
import '../data/repositories/sqlite_student_repository.dart';
import '../domain/repositories/student_repository.dart';
import 'student_use_cases.dart';

final studentsDatabaseProvider = Provider<StudentsDatabase>((ref) {
  final database = StudentsDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});

final studentLocalDataSourceProvider = Provider<StudentLocalDataSource>(
  (ref) => StudentLocalDataSource(ref.watch(studentsDatabaseProvider)),
);

final studentRepositoryProvider = Provider<StudentRepository>(
  (ref) => SqliteStudentRepository(ref.watch(studentLocalDataSourceProvider)),
);

final listStudentsProvider = Provider<ListStudents>(
  (ref) => ListStudents(ref.watch(studentRepositoryProvider)),
);

final getStudentProvider = Provider<GetStudent>(
  (ref) => GetStudent(ref.watch(studentRepositoryProvider)),
);

final createStudentProvider = Provider<CreateStudent>(
  (ref) => CreateStudent(ref.watch(studentRepositoryProvider)),
);

final updateStudentProvider = Provider<UpdateStudent>(
  (ref) => UpdateStudent(ref.watch(studentRepositoryProvider)),
);

final deleteStudentProvider = Provider<DeleteStudent>(
  (ref) => DeleteStudent(ref.watch(studentRepositoryProvider)),
);
