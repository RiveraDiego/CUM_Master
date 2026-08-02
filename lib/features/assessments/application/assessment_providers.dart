import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../students/application/student_providers.dart';
import '../data/datasources/assessment_local_data_source.dart';
import '../data/repositories/sqlite_assessment_repository.dart';
import '../domain/repositories/assessment_repository.dart';
import 'assessment_use_cases.dart';

final assessmentSourceProvider = Provider(
  (ref) => AssessmentLocalDataSource(ref.watch(studentsDatabaseProvider)),
);
final assessmentRepositoryProvider = Provider<AssessmentRepository>(
  (ref) => SqliteAssessmentRepository(ref.watch(assessmentSourceProvider)),
);
final listAssessmentsProvider = Provider(
  (ref) => ListAssessments(ref.watch(assessmentRepositoryProvider)),
);
final getAssessmentProvider = Provider(
  (ref) => GetAssessment(ref.watch(assessmentRepositoryProvider)),
);
final createAssessmentProvider = Provider(
  (ref) => CreateAssessment(ref.watch(assessmentRepositoryProvider)),
);
final updateAssessmentProvider = Provider(
  (ref) => UpdateAssessment(ref.watch(assessmentRepositoryProvider)),
);
final deleteAssessmentProvider = Provider(
  (ref) => DeleteAssessment(ref.watch(assessmentRepositoryProvider)),
);
