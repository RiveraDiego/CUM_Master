import 'package:sqflite/sqflite.dart';

import '../../domain/entities/student.dart';
import '../../domain/errors/student_exceptions.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_local_data_source.dart';

class SqliteStudentRepository implements StudentRepository {
  const SqliteStudentRepository(this._dataSource);

  final StudentLocalDataSource _dataSource;

  @override
  Future<void> create(Student student) async {
    try {
      await _dataSource.create(student);
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) {
        throw DuplicateStudentCardException(student.studentCard);
      }
      throw const StudentStorageException();
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final deleted = await _dataSource.delete(id);
      if (!deleted) {
        throw StudentNotFoundException(id);
      }
    } on StudentException {
      rethrow;
    } on DatabaseException {
      throw const StudentStorageException();
    }
  }

  @override
  Future<List<Student>> getAll() async {
    try {
      return await _dataSource.getAll();
    } on DatabaseException {
      throw const StudentStorageException();
    }
  }

  @override
  Future<Student?> getById(String id) async {
    try {
      return await _dataSource.getById(id);
    } on DatabaseException {
      throw const StudentStorageException();
    }
  }

  @override
  Future<void> update(Student student) async {
    try {
      final updated = await _dataSource.update(student);
      if (!updated) {
        throw StudentNotFoundException(student.id);
      }
    } on StudentException {
      rethrow;
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) {
        throw DuplicateStudentCardException(student.studentCard);
      }
      throw const StudentStorageException();
    }
  }
}
