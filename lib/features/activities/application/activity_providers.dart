import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../students/application/student_providers.dart';
import '../../../core/state/academic_data_revision.dart';
import '../domain/activity.dart';

final activitiesProvider = FutureProvider.family<List<Activity>, String>((
  ref,
  assessmentId,
) async {
  final db = await ref.watch(studentsDatabaseProvider).database;
  final rows = await db.query(
    'activities',
    where: 'assessment_id = ?',
    whereArgs: [assessmentId],
    orderBy: 'created_at ASC',
  );
  return rows
      .map(
        (m) => Activity(
          id: m['id']! as String,
          assessmentId: m['assessment_id']! as String,
          name: m['name']! as String,
          score: (m['score']! as num).toDouble(),
          maxScore: (m['max_score']! as num).toDouble(),
          weight: (m['weight']! as num).toDouble(),
          createdAt: DateTime.parse(m['created_at']! as String),
          updatedAt: DateTime.parse(m['updated_at']! as String),
        ),
      )
      .toList();
});

class ActivityActions {
  const ActivityActions(this.ref);
  final Ref ref;
  Future<void> save({
    required String assessmentId,
    String? id,
    required String name,
    required double score,
    required double maxScore,
    required double weight,
  }) async {
    final db = await ref.read(studentsDatabaseProvider).database;
    final now = DateTime.now().toUtc();
    if (id == null) {
      await db.insert('activities', {
        'id': const Uuid().v4(),
        'assessment_id': assessmentId,
        'name': name.trim(),
        'score': score,
        'max_score': maxScore,
        'weight': weight,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.abort);
    } else {
      await db.update(
        'activities',
        {
          'name': name.trim(),
          'score': score,
          'max_score': maxScore,
          'weight': weight,
          'updated_at': now.toIso8601String(),
        },
        where: 'id = ? AND assessment_id = ?',
        whereArgs: [id, assessmentId],
      );
    }
    ref.invalidate(activitiesProvider(assessmentId));
    ref.read(academicDataRevisionProvider.notifier).bump();
  }

  Future<void> delete(String assessmentId, String id) async {
    final db = await ref.read(studentsDatabaseProvider).database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
    ref.invalidate(activitiesProvider(assessmentId));
    ref.read(academicDataRevisionProvider.notifier).bump();
  }
}

final activityActionsProvider = Provider(ActivityActions.new);
