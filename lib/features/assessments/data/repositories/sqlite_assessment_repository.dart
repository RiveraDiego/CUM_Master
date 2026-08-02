import 'package:sqflite/sqflite.dart';
import '../../domain/entities/assessment.dart';
import '../../domain/errors/assessment_exceptions.dart';
import '../../domain/repositories/assessment_repository.dart';
import '../datasources/assessment_local_data_source.dart';

class SqliteAssessmentRepository implements AssessmentRepository {
  const SqliteAssessmentRepository(this._source);
  final AssessmentLocalDataSource _source;
  @override
  Future<void> create(Assessment value) async {
    try {
      await _source.create(value);
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const DuplicateAssessmentNameException();
      }
      throw const AssessmentStorageException();
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      if (!await _source.delete(id)) throw AssessmentNotFoundException(id);
    } on AssessmentException {
      rethrow;
    } on DatabaseException {
      throw const AssessmentStorageException();
    }
  }

  @override
  Future<List<Assessment>> getAll(String subjectId) async {
    try {
      return await _source.getAll(subjectId);
    } on DatabaseException {
      throw const AssessmentStorageException();
    }
  }

  @override
  Future<Assessment?> getById(String id) async {
    try {
      return await _source.getById(id);
    } on DatabaseException {
      throw const AssessmentStorageException();
    }
  }

  @override
  Future<void> update(Assessment value) async {
    try {
      if (!await _source.update(value)) {
        throw AssessmentNotFoundException(value.id);
      }
    } on AssessmentException {
      rethrow;
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const DuplicateAssessmentNameException();
      }
      throw const AssessmentStorageException();
    }
  }
}
