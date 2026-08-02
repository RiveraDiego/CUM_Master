import 'package:sqflite/sqflite.dart';

import '../../../students/data/local/students_database.dart';
import '../../domain/entities/subject.dart';

class SubjectLocalDataSource {
  const SubjectLocalDataSource(this._database);
  final StudentsDatabase _database;

  Future<List<Subject>> getAll(String studentId) async {
    final database = await _database.database;
    final rows = await database.query(
      'subjects',
      where: 'student_id = ?',
      whereArgs: [studentId],
      orderBy: 'name COLLATE NOCASE ASC, id ASC',
    );
    return rows.map(_fromMap).toList(growable: false);
  }

  Future<Subject?> getById(String id) async {
    final database = await _database.database;
    final rows = await database.query(
      'subjects',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : _fromMap(rows.single);
  }

  Future<void> create(Subject subject) async {
    final database = await _database.database;
    await database.insert(
      'subjects',
      _toMap(subject),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<bool> update(Subject subject) async {
    final database = await _database.database;
    return await database.update(
          'subjects',
          {
            'name': subject.name,
            'code': subject.code,
            'updated_at': subject.updatedAt.toIso8601String(),
          },
          where: 'id = ? AND student_id = ?',
          whereArgs: [subject.id, subject.studentId],
          conflictAlgorithm: ConflictAlgorithm.abort,
        ) >
        0;
  }

  Future<bool> delete(String id) async {
    final database = await _database.database;
    return await database.delete('subjects', where: 'id = ?', whereArgs: [id]) >
        0;
  }

  Map<String, Object?> _toMap(Subject subject) => {
    'id': subject.id,
    'student_id': subject.studentId,
    'name': subject.name,
    'code': subject.code,
    'created_at': subject.createdAt.toIso8601String(),
    'updated_at': subject.updatedAt.toIso8601String(),
  };

  Subject _fromMap(Map<String, Object?> map) => Subject(
    id: map['id']! as String,
    studentId: map['student_id']! as String,
    name: map['name']! as String,
    code: map['code'] as String?,
    createdAt: DateTime.parse(map['created_at']! as String),
    updatedAt: DateTime.parse(map['updated_at']! as String),
  );
}
