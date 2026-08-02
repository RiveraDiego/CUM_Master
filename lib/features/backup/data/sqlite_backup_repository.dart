import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../students/data/local/students_database.dart';
import '../domain/backup_exceptions.dart';
import '../domain/backup_repository.dart';

class SqliteBackupRepository implements BackupRepository {
  const SqliteBackupRepository(this.database);

  static const format = 'cum_master_backup';
  static const formatVersion = 1;
  static const _tables = [
    'students',
    'cycles',
    'subjects',
    'assessments',
    'activities',
  ];

  final StudentsDatabase database;

  @override
  Future<String> exportJson() async {
    try {
      final db = await database.database;
      final data = <String, Object?>{};
      for (final table in _tables) {
        data[table] = await db.query(table);
      }
      return const JsonEncoder.withIndent('  ').convert({
        'format': format,
        'version': formatVersion,
        'exported_at': DateTime.now().toUtc().toIso8601String(),
        'data': data,
      });
    } on DatabaseException {
      throw const BackupStorageException();
    }
  }

  @override
  Future<void> importJson(String content) async {
    final tables = _decodeAndValidate(content);
    try {
      final db = await database.database;
      await db.transaction((transaction) async {
        await transaction.delete('students');
        for (final table in _tables) {
          for (final row in tables[table]!) {
            await transaction.insert(
              table,
              row,
              conflictAlgorithm: ConflictAlgorithm.abort,
            );
          }
        }
      });
    } on DatabaseException {
      throw const InvalidBackupException();
    }
  }

  Map<String, List<Map<String, Object?>>> _decodeAndValidate(String content) {
    try {
      final decoded = jsonDecode(content);
      if (decoded is! Map<String, dynamic> ||
          decoded['format'] != format ||
          decoded['version'] != formatVersion ||
          decoded['data'] is! Map<String, dynamic>) {
        throw const InvalidBackupException();
      }
      final data = decoded['data']! as Map<String, dynamic>;
      return {for (final table in _tables) table: _rows(data[table])};
    } on BackupException {
      rethrow;
    } on FormatException {
      throw const InvalidBackupException();
    } on TypeError {
      throw const InvalidBackupException();
    }
  }

  List<Map<String, Object?>> _rows(Object? value) {
    if (value is! List) throw const InvalidBackupException();
    return value
        .map((row) {
          if (row is! Map<String, dynamic>) {
            throw const InvalidBackupException();
          }
          for (final cell in row.values) {
            if (cell != null && cell is! String && cell is! num) {
              throw const InvalidBackupException();
            }
          }
          return Map<String, Object?>.from(row);
        })
        .toList(growable: false);
  }
}
