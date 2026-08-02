import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../students/application/student_providers.dart';
import '../data/datasources/subject_local_data_source.dart';
import '../data/repositories/sqlite_subject_repository.dart';
import '../domain/repositories/subject_repository.dart';
import 'subject_use_cases.dart';

final subjectLocalDataSourceProvider = Provider<SubjectLocalDataSource>(
  (ref) => SubjectLocalDataSource(ref.watch(studentsDatabaseProvider)),
);
final subjectRepositoryProvider = Provider<SubjectRepository>(
  (ref) => SqliteSubjectRepository(ref.watch(subjectLocalDataSourceProvider)),
);
final listSubjectsProvider = Provider<ListSubjects>(
  (ref) => ListSubjects(ref.watch(subjectRepositoryProvider)),
);
final getSubjectProvider = Provider<GetSubject>(
  (ref) => GetSubject(ref.watch(subjectRepositoryProvider)),
);
final createSubjectProvider = Provider<CreateSubject>(
  (ref) => CreateSubject(ref.watch(subjectRepositoryProvider)),
);
final updateSubjectProvider = Provider<UpdateSubject>(
  (ref) => UpdateSubject(ref.watch(subjectRepositoryProvider)),
);
final deleteSubjectProvider = Provider<DeleteSubject>(
  (ref) => DeleteSubject(ref.watch(subjectRepositoryProvider)),
);
