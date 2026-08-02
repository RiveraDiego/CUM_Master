import 'package:sqflite/sqflite.dart';

import '../../students/data/local/students_database.dart';
import '../domain/academic_settings.dart';
import '../domain/academic_settings_repository.dart';

class SqliteAcademicSettingsRepository implements AcademicSettingsRepository {
  const SqliteAcademicSettingsRepository(this.database);
  final StudentsDatabase database;

  @override
  Future<AcademicSettings> get() async {
    final db = await database.database;
    final rows = await db.query('academic_settings', where: 'id = 1', limit: 1);
    if (rows.isEmpty) return AcademicSettings.defaults;
    final row = rows.single;
    return AcademicSettings(
      defaultCreditUnits: (row['default_credit_units']! as num).toDouble(),
      decimalPlaces: row['decimal_places']! as int,
      roundingMode: GradeRoundingMode.values.byName(
        row['rounding_mode']! as String,
      ),
      cycleSingular: row['cycle_singular'] as String?,
      cyclePlural: row['cycle_plural'] as String?,
      subjectSingular: row['subject_singular'] as String?,
      subjectPlural: row['subject_plural'] as String?,
      assessmentSingular: row['assessment_singular'] as String?,
      assessmentPlural: row['assessment_plural'] as String?,
      activitySingular: row['activity_singular'] as String?,
      activityPlural: row['activity_plural'] as String?,
    );
  }

  @override
  Future<void> save(AcademicSettings settings) async {
    final db = await database.database;
    await db.insert('academic_settings', {
      'id': 1,
      'default_credit_units': settings.defaultCreditUnits,
      'decimal_places': settings.decimalPlaces,
      'rounding_mode': settings.roundingMode.name,
      'cycle_singular': _nullable(settings.cycleSingular),
      'cycle_plural': _nullable(settings.cyclePlural),
      'subject_singular': _nullable(settings.subjectSingular),
      'subject_plural': _nullable(settings.subjectPlural),
      'assessment_singular': _nullable(settings.assessmentSingular),
      'assessment_plural': _nullable(settings.assessmentPlural),
      'activity_singular': _nullable(settings.activitySingular),
      'activity_plural': _nullable(settings.activityPlural),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> applyDefaultCreditUnitsToAllSubjects(double value) async {
    final db = await database.database;
    await db.update('subjects', {'credit_units': value});
  }

  String? _nullable(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }
}
