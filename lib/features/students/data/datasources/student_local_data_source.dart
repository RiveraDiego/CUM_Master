import 'package:sqflite/sqflite.dart';

import '../../domain/entities/student.dart';
import '../local/students_database.dart';

class StudentLocalDataSource {
  const StudentLocalDataSource(this._database);

  final StudentsDatabase _database;

  Future<List<Student>> getAll() async {
    final database = await _database.database;
    final rows = await database.query(
      'students',
      orderBy: 'created_at ASC, id ASC',
    );
    return rows.map(_fromMap).toList(growable: false);
  }

  Future<Student?> getById(String id) async {
    final database = await _database.database;
    final rows = await database.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : _fromMap(rows.single);
  }

  Future<void> create(Student student) async {
    final database = await _database.database;
    await database.insert(
      'students',
      _toMap(student),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<bool> update(Student student) async {
    final database = await _database.database;
    final changed = await database.update(
      'students',
      {
        'student_card': student.studentCard,
        'university': student.university,
        'updated_at': student.updatedAt.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [student.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return changed > 0;
  }

  Future<bool> delete(String id) async {
    final database = await _database.database;
    final changed = await database.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
    return changed > 0;
  }

  Map<String, Object?> _toMap(Student student) => {
    'id': student.id,
    'student_card': student.studentCard,
    'university': student.university,
    'created_at': student.createdAt.toIso8601String(),
    'updated_at': student.updatedAt.toIso8601String(),
  };

  Student _fromMap(Map<String, Object?> map) => Student(
    id: map['id']! as String,
    studentCard: map['student_card']! as String,
    university: map['university'] as String?,
    createdAt: DateTime.parse(map['created_at']! as String),
    updatedAt: DateTime.parse(map['updated_at']! as String),
  );
}
