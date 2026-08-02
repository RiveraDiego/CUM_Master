import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/students/application/student_providers.dart';

const _themeModeKey = 'theme_mode';

final appThemeModeProvider = FutureProvider<ThemeMode>((ref) async {
  final database = await ref.watch(studentsDatabaseProvider).database;
  final rows = await database.query(
    'app_preferences',
    columns: ['value'],
    where: 'key = ?',
    whereArgs: [_themeModeKey],
    limit: 1,
  );
  if (rows.isEmpty) return ThemeMode.system;
  return ThemeMode.values.firstWhere(
    (mode) => mode.name == rows.single['value'],
    orElse: () => ThemeMode.system,
  );
});

class AppThemeModeActions {
  const AppThemeModeActions(this.ref);
  final Ref ref;

  Future<void> save(ThemeMode mode) async {
    final database = await ref.read(studentsDatabaseProvider).database;
    await database.insert('app_preferences', {
      'key': _themeModeKey,
      'value': mode.name,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    ref.invalidate(appThemeModeProvider);
  }
}

final appThemeModeActionsProvider = Provider(AppThemeModeActions.new);
