import 'package:uuid/uuid.dart';

import '../domain/entities/student.dart';
import '../domain/errors/student_exceptions.dart';
import '../domain/repositories/student_repository.dart';

typedef UtcNow = DateTime Function();

DateTime _utcNow() => DateTime.now().toUtc();

class ListStudents {
  const ListStudents(this._repository);
  final StudentRepository _repository;

  Future<List<Student>> call() => _repository.getAll();
}

class GetStudent {
  const GetStudent(this._repository);
  final StudentRepository _repository;

  Future<Student?> call(String id) => _repository.getById(id);
}

class CreateStudent {
  CreateStudent(
    this._repository, [
    this._uuid = const Uuid(),
    this._now = _utcNow,
  ]);

  final StudentRepository _repository;
  final Uuid _uuid;
  final UtcNow _now;

  Future<Student> call({
    required String studentCard,
    String? name,
    String? university,
  }) async {
    final now = _now().toUtc();
    final student = Student(
      id: _uuid.v4(),
      studentCard: studentCard,
      name: name,
      university: university,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.create(student);
    return student;
  }
}

class UpdateStudent {
  const UpdateStudent(this._repository, [this._now = _utcNow]);

  final StudentRepository _repository;
  final UtcNow _now;

  Future<Student> call({
    required String studentId,
    required String studentCard,
    String? name,
    String? university,
  }) async {
    final student = await _repository.getById(studentId);
    if (student == null) {
      throw StudentNotFoundException(studentId);
    }

    final currentTime = _now().toUtc();
    final updatedAt = currentTime.isAfter(student.updatedAt)
        ? currentTime
        : student.updatedAt.add(const Duration(microseconds: 1));
    final updated = student.copyWith(
      studentCard: studentCard,
      name: name,
      university: university,
      updatedAt: updatedAt,
    );
    await _repository.update(updated);
    return updated;
  }
}

class DeleteStudent {
  const DeleteStudent(this._repository);
  final StudentRepository _repository;

  Future<void> call(String id) => _repository.delete(id);
}
