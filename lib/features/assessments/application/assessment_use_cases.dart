import 'package:uuid/uuid.dart';
import '../domain/entities/assessment.dart';
import '../domain/errors/assessment_exceptions.dart';
import '../domain/repositories/assessment_repository.dart';

class ListAssessments {
  const ListAssessments(this.repository);
  final AssessmentRepository repository;
  Future<List<Assessment>> call(String subjectId) =>
      repository.getAll(subjectId);
}

class GetAssessment {
  const GetAssessment(this.repository);
  final AssessmentRepository repository;
  Future<Assessment?> call(String id) => repository.getById(id);
}

class CreateAssessment {
  CreateAssessment(this.repository, [this.uuid = const Uuid()]);
  final AssessmentRepository repository;
  final Uuid uuid;
  Future<Assessment> call({
    required String subjectId,
    required String name,
    required double score,
    required double maxScore,
    double? weight,
  }) async {
    final now = DateTime.now().toUtc();
    final value = Assessment(
      id: uuid.v4(),
      subjectId: subjectId,
      name: name,
      score: score,
      maxScore: maxScore,
      weight: weight,
      createdAt: now,
      updatedAt: now,
    );
    await repository.create(value);
    return value;
  }
}

class UpdateAssessment {
  const UpdateAssessment(this.repository);
  final AssessmentRepository repository;
  Future<Assessment> call({
    required String id,
    required String subjectId,
    required String name,
    required double score,
    required double maxScore,
    double? weight,
  }) async {
    final current = await repository.getById(id);
    if (current == null || current.subjectId != subjectId) {
      throw AssessmentNotFoundException(id);
    }
    final now = DateTime.now().toUtc();
    final value = current.copyWith(
      name: name,
      score: score,
      maxScore: maxScore,
      weight: weight,
      updatedAt: now.isAfter(current.updatedAt)
          ? now
          : current.updatedAt.add(const Duration(microseconds: 1)),
    );
    await repository.update(value);
    return value;
  }
}

class DeleteAssessment {
  const DeleteAssessment(this.repository);
  final AssessmentRepository repository;
  Future<void> call(String id) => repository.delete(id);
}
