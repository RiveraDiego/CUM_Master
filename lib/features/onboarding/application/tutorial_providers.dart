import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../../students/application/student_providers.dart';

const _tutorialCompletedKey = 'tutorial_completed';

final tutorialCompletedProvider = FutureProvider<bool>((ref) async {
  final database = await ref.watch(studentsDatabaseProvider).database;
  final rows = await database.query(
    'app_preferences',
    columns: ['value'],
    where: 'key = ?',
    whereArgs: [_tutorialCompletedKey],
    limit: 1,
  );
  return rows.isNotEmpty && rows.single['value'] == 'true';
});

class TutorialActions {
  const TutorialActions(this.ref);
  final Ref ref;

  Future<void> complete() async {
    final database = await ref.read(studentsDatabaseProvider).database;
    await database.insert('app_preferences', {
      'key': _tutorialCompletedKey,
      'value': 'true',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    ref.invalidate(tutorialCompletedProvider);
  }
}

final tutorialActionsProvider = Provider(TutorialActions.new);
