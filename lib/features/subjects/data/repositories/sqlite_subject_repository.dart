import 'package:sqflite/sqflite.dart';

import '../../domain/entities/subject.dart';
import '../../domain/errors/subject_exceptions.dart';
import '../../domain/repositories/subject_repository.dart';
import '../datasources/subject_local_data_source.dart';

class SqliteSubjectRepository implements SubjectRepository {
  const SqliteSubjectRepository(this._dataSource);
  final SubjectLocalDataSource _dataSource;

  @override
  Future<void> create(Subject subject) async {
    try {
      await _dataSource.create(subject);
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) {
        throw DuplicateSubjectNameException(subject.name);
      }
      throw const SubjectStorageException();
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      if (!await _dataSource.delete(id)) throw SubjectNotFoundException(id);
    } on SubjectException {
      rethrow;
    } on DatabaseException {
      throw const SubjectStorageException();
    }
  }

  @override
  Future<List<Subject>> getAll(String studentId) async {
    try {
      return await _dataSource.getAll(studentId);
    } on DatabaseException {
      throw const SubjectStorageException();
    }
  }

  @override
  Future<Subject?> getById(String id) async {
    try {
      return await _dataSource.getById(id);
    } on DatabaseException {
      throw const SubjectStorageException();
    }
  }

  @override
  Future<void> update(Subject subject) async {
    try {
      if (!await _dataSource.update(subject)) {
        throw SubjectNotFoundException(subject.id);
      }
    } on SubjectException {
      rethrow;
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) {
        throw DuplicateSubjectNameException(subject.name);
      }
      throw const SubjectStorageException();
    }
  }
}
