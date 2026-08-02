import 'package:uuid/uuid.dart';

import '../domain/entities/subject.dart';
import '../domain/errors/subject_exceptions.dart';
import '../domain/repositories/subject_repository.dart';

typedef UtcNow = DateTime Function();
DateTime _utcNow() => DateTime.now().toUtc();

class ListSubjects {
  const ListSubjects(this._repository);
  final SubjectRepository _repository;
  Future<List<Subject>> call(String studentId) => _repository.getAll(studentId);
}

class GetSubject {
  const GetSubject(this._repository);
  final SubjectRepository _repository;
  Future<Subject?> call(String id) => _repository.getById(id);
}

class CreateSubject {
  CreateSubject(
    this._repository, [
    this._uuid = const Uuid(),
    this._now = _utcNow,
  ]);
  final SubjectRepository _repository;
  final Uuid _uuid;
  final UtcNow _now;

  Future<Subject> call({
    required String studentId,
    String? cycleId,
    required String name,
    String? code,
    double creditUnits = 1,
    double? manualFinalGrade,
  }) async {
    final now = _now().toUtc();
    final subject = Subject(
      id: _uuid.v4(),
      studentId: studentId,
      cycleId: cycleId ?? 'cycle-$studentId',
      name: name,
      code: code,
      creditUnits: creditUnits,
      manualFinalGrade: manualFinalGrade,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.create(subject);
    return subject;
  }
}

class UpdateSubject {
  const UpdateSubject(this._repository, [this._now = _utcNow]);
  final SubjectRepository _repository;
  final UtcNow _now;

  Future<Subject> call({
    required String id,
    required String studentId,
    String? cycleId,
    required String name,
    String? code,
    double? creditUnits,
    Object? manualFinalGrade = _notProvided,
  }) async {
    final current = await _repository.getById(id);
    if (current == null || current.studentId != studentId) {
      throw SubjectNotFoundException(id);
    }
    final now = _now().toUtc();
    final updated = current.copyWith(
      cycleId: cycleId ?? current.cycleId,
      name: name,
      code: code,
      creditUnits: creditUnits,
      manualFinalGrade: identical(manualFinalGrade, _notProvided)
          ? current.manualFinalGrade
          : manualFinalGrade,
      updatedAt: now.isAfter(current.updatedAt)
          ? now
          : current.updatedAt.add(const Duration(microseconds: 1)),
    );
    await _repository.update(updated);
    return updated;
  }
}

const _notProvided = Object();

class DeleteSubject {
  const DeleteSubject(this._repository);
  final SubjectRepository _repository;
  Future<void> call(String id) => _repository.delete(id);
}
