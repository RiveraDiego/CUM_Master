import 'package:sqflite/sqflite.dart';
import '../../../students/data/local/students_database.dart';
import '../../domain/entities/assessment.dart';

class AssessmentLocalDataSource {
  const AssessmentLocalDataSource(this._database);
  final StudentsDatabase _database;

  Future<List<Assessment>> getAll(String subjectId) async {
    final db = await _database.database;
    final rows = await db.query(
      'assessments',
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'created_at ASC, id ASC',
    );
    return rows.map(_fromMap).toList(growable: false);
  }

  Future<Assessment?> getById(String id) async {
    final db = await _database.database;
    final rows = await db.query(
      'assessments',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : _fromMap(rows.single);
  }

  Future<void> create(Assessment value) async {
    final db = await _database.database;
    await db.insert(
      'assessments',
      _toMap(value),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<bool> update(Assessment value) async {
    final db = await _database.database;
    return await db.update(
          'assessments',
          {
            'name': value.name,
            'score': value.score,
            'max_score': value.maxScore,
            'weight': value.weight,
            'updated_at': value.updatedAt.toIso8601String(),
          },
          where: 'id = ? AND subject_id = ?',
          whereArgs: [value.id, value.subjectId],
          conflictAlgorithm: ConflictAlgorithm.abort,
        ) >
        0;
  }

  Future<bool> delete(String id) async {
    final db = await _database.database;
    return await db.delete('assessments', where: 'id = ?', whereArgs: [id]) > 0;
  }

  Map<String, Object?> _toMap(Assessment value) => {
    'id': value.id,
    'subject_id': value.subjectId,
    'name': value.name,
    'score': value.score,
    'max_score': value.maxScore,
    'weight': value.weight,
    'created_at': value.createdAt.toIso8601String(),
    'updated_at': value.updatedAt.toIso8601String(),
  };
  Assessment _fromMap(Map<String, Object?> map) => Assessment(
    id: map['id']! as String,
    subjectId: map['subject_id']! as String,
    name: map['name']! as String,
    score: (map['score']! as num).toDouble(),
    maxScore: (map['max_score']! as num).toDouble(),
    weight: (map['weight'] as num?)?.toDouble(),
    createdAt: DateTime.parse(map['created_at']! as String),
    updatedAt: DateTime.parse(map['updated_at']! as String),
  );
}
