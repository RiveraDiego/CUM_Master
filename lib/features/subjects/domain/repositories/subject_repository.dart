import '../entities/subject.dart';

abstract interface class SubjectRepository {
  Future<List<Subject>> getAll(String studentId);
  Future<Subject?> getById(String id);
  Future<void> create(Subject subject);
  Future<void> update(Subject subject);
  Future<void> delete(String id);
}
