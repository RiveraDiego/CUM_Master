import 'package:sqflite/sqflite.dart';
import '../../students/data/local/students_database.dart';
import '../domain/entities/academic_cycle.dart';
import '../domain/errors/cycle_exceptions.dart';
import '../domain/repositories/cycle_repository.dart';

class SqliteCycleRepository implements CycleRepository {
  const SqliteCycleRepository(this.database);
  final StudentsDatabase database;
  @override
  Future<List<AcademicCycle>> getAll(String studentId) async {
    try {
      final db = await database.database;
      final rows = await db.query(
        'cycles',
        where: 'student_id = ?',
        whereArgs: [studentId],
        orderBy: 'is_active DESC, created_at DESC',
      );
      return rows
          .map(
            (m) => AcademicCycle(
              id: m['id']! as String,
              studentId: m['student_id']! as String,
              name: m['name']! as String,
              isActive: (m['is_active']! as int) == 1,
              createdAt: DateTime.parse(m['created_at']! as String),
              updatedAt: DateTime.parse(m['updated_at']! as String),
            ),
          )
          .toList();
    } on DatabaseException {
      throw const CycleStorageException();
    }
  }

  @override
  Future<void> create(AcademicCycle cycle) async {
    try {
      final db = await database.database;
      await db.transaction((txn) async {
        if (cycle.isActive) {
          await txn.update(
            'cycles',
            {'is_active': 0},
            where: 'student_id = ?',
            whereArgs: [cycle.studentId],
          );
        }
        await txn.insert('cycles', {
          'id': cycle.id,
          'student_id': cycle.studentId,
          'name': cycle.name,
          'is_active': cycle.isActive ? 1 : 0,
          'created_at': cycle.createdAt.toIso8601String(),
          'updated_at': cycle.updatedAt.toIso8601String(),
        });
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const DuplicateCycleNameException();
      }
      throw const CycleStorageException();
    }
  }

  @override
  Future<void> setActive(String studentId, String cycleId) async {
    try {
      final db = await database.database;
      await db.transaction((txn) async {
        await txn.update(
          'cycles',
          {'is_active': 0},
          where: 'student_id = ?',
          whereArgs: [studentId],
        );
        await txn.update(
          'cycles',
          {
            'is_active': 1,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          },
          where: 'id = ? AND student_id = ?',
          whereArgs: [cycleId, studentId],
        );
      });
    } on DatabaseException {
      throw const CycleStorageException();
    }
  }

  @override
  Future<void> rename(String cycleId, String name) async {
    try {
      final db = await database.database;
      await db.update(
        'cycles',
        {
          'name': name.trim(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [cycleId],
      );
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) {
        throw const DuplicateCycleNameException();
      }
      throw const CycleStorageException();
    }
  }

  @override
  Future<void> delete(String cycleId) async {
    try {
      final db = await database.database;
      final used =
          Sqflite.firstIntValue(
            await db.rawQuery(
              'SELECT COUNT(*) FROM subjects WHERE cycle_id = ?',
              [cycleId],
            ),
          ) ??
          0;
      if (used > 0) throw const CycleInUseException();
      await db.delete('cycles', where: 'id = ?', whereArgs: [cycleId]);
    } on CycleException {
      rethrow;
    } on DatabaseException {
      throw const CycleStorageException();
    }
  }
}
