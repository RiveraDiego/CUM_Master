import '../entities/assessment.dart';

abstract interface class AssessmentRepository {
  Future<List<Assessment>> getAll(String subjectId);
  Future<Assessment?> getById(String id);
  Future<void> create(Assessment assessment);
  Future<void> update(Assessment assessment);
  Future<void> delete(String id);
}
