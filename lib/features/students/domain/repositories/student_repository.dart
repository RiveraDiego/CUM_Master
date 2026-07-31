import '../entities/student.dart';

abstract interface class StudentRepository {
  Future<List<Student>> getAll();

  Future<Student?> getById(String id);

  Future<void> create(Student student);

  Future<void> update(Student student);

  Future<void> delete(String id);
}
