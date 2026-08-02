import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class StudentsDatabase {
  StudentsDatabase({DatabaseFactory? factory, this.databasePath})
    : _factory = factory ?? databaseFactory;

  static const schemaVersion = 8;
  static const fileName = 'cum_master.db';

  final DatabaseFactory _factory;
  final String? databasePath;
  Future<Database>? _databaseFuture;

  Future<Database> get database async {
    var opening = _databaseFuture;
    if (opening == null) {
      opening = _open();
      _databaseFuture = opening;
    }

    try {
      return await opening;
    } catch (_) {
      if (identical(_databaseFuture, opening)) {
        _databaseFuture = null;
      }
      rethrow;
    }
  }

  Future<Database> _open() async {
    return _factory.openDatabase(
      databasePath ?? p.join(await getDatabasesPath(), fileName),
      options: OpenDatabaseOptions(
        version: schemaVersion,
        onConfigure: (database) => database.execute('PRAGMA foreign_keys = ON'),
        onCreate: (database, version) async {
          await database.execute('''
            CREATE TABLE students (
              id TEXT PRIMARY KEY NOT NULL,
              student_card TEXT NOT NULL COLLATE NOCASE UNIQUE,
              university TEXT,
              created_at TEXT NOT NULL,
              updated_at TEXT NOT NULL,
              CHECK(length(trim(student_card)) > 0),
              CHECK(updated_at >= created_at)
            )
          ''');
          await _createCyclesTable(database);
          await _createSubjectsTable(database);
          await _createAssessmentsTable(database);
          await _createActivitiesTable(database);
          await _createAcademicSettingsTable(database);
          await _createAppPreferencesTable(database);
        },
        onUpgrade: (database, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await _createCyclesTable(database);
            await _createDefaultCycles(database);
            await _createSubjectsTable(database);
          } else if (oldVersion < 4) {
            await _createCyclesTable(database);
            await _createDefaultCycles(database);
            await database.execute(
              'ALTER TABLE subjects ADD COLUMN cycle_id TEXT',
            );
            await database.execute(
              "UPDATE subjects SET cycle_id = 'cycle-' || student_id",
            );
          }
          if (oldVersion < 3) await _createAssessmentsTable(database);
          if (oldVersion < 5) {
            if (oldVersion >= 2) {
              await database.execute(
                'ALTER TABLE subjects ADD COLUMN credit_units REAL NOT NULL DEFAULT 1',
              );
              await database.execute(
                'ALTER TABLE subjects ADD COLUMN manual_final_grade REAL',
              );
            }
            await _createActivitiesTable(database);
          }
          if (oldVersion < 6) {
            await database.execute(
              'DROP TRIGGER IF EXISTS create_default_cycle_after_student',
            );
            await database.update(
              'cycles',
              {'is_active': 0},
              where: "id = 'cycle-' || student_id AND name = ?",
              whereArgs: ['Ciclo actual'],
            );
          }
          if (oldVersion < 7) await _createAcademicSettingsTable(database);
          if (oldVersion < 8) await _createAppPreferencesTable(database);
        },
      ),
    );
  }

  static Future<void> _createCyclesTable(Database database) async {
    await database.execute('''
      CREATE TABLE cycles (
        id TEXT PRIMARY KEY NOT NULL,
        student_id TEXT NOT NULL,
        name TEXT NOT NULL COLLATE NOCASE,
        is_active INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE,
        UNIQUE(student_id, name),
        CHECK(is_active IN (0, 1))
      )
    ''');
    await database.execute(
      'CREATE INDEX idx_cycles_student_id ON cycles(student_id)',
    );
    await database.execute(
      'CREATE UNIQUE INDEX idx_cycles_one_active ON cycles(student_id) WHERE is_active = 1',
    );
  }

  static Future<void> _createDefaultCycles(Database database) async {
    await database.execute('''
      INSERT INTO cycles (id, student_id, name, is_active, created_at, updated_at)
      SELECT 'cycle-' || id, id, 'Ciclo actual', 1, created_at, updated_at
      FROM students
    ''');
  }

  static Future<void> _createSubjectsTable(Database database) async {
    await database.execute('''
      CREATE TABLE subjects (
        id TEXT PRIMARY KEY NOT NULL,
        student_id TEXT NOT NULL,
        cycle_id TEXT NOT NULL,
        name TEXT NOT NULL COLLATE NOCASE,
        code TEXT,
        credit_units REAL NOT NULL DEFAULT 1,
        manual_final_grade REAL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE,
        FOREIGN KEY(cycle_id) REFERENCES cycles(id) ON DELETE RESTRICT,
        UNIQUE(cycle_id, name),
        CHECK(length(trim(name)) > 0),
        CHECK(credit_units > 0),
        CHECK(manual_final_grade IS NULL OR (manual_final_grade >= 0 AND manual_final_grade <= 10)),
        CHECK(updated_at >= created_at)
      )
    ''');
    await database.execute(
      'CREATE INDEX idx_subjects_student_id ON subjects(student_id)',
    );
  }

  static Future<void> _createAssessmentsTable(Database database) async {
    await database.execute('''
      CREATE TABLE assessments (
        id TEXT PRIMARY KEY NOT NULL,
        subject_id TEXT NOT NULL,
        name TEXT NOT NULL COLLATE NOCASE,
        score REAL NOT NULL,
        max_score REAL NOT NULL,
        weight REAL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
        UNIQUE(subject_id, name),
        CHECK(length(trim(name)) > 0),
        CHECK(score >= 0 AND max_score > 0 AND score <= max_score),
        CHECK(weight IS NULL OR (weight > 0 AND weight <= 100)),
        CHECK(updated_at >= created_at)
      )
    ''');
    await database.execute(
      'CREATE INDEX idx_assessments_subject_id ON assessments(subject_id)',
    );
  }

  static Future<void> _createActivitiesTable(Database database) async {
    await database.execute('''
      CREATE TABLE activities (
        id TEXT PRIMARY KEY NOT NULL,
        assessment_id TEXT NOT NULL,
        name TEXT NOT NULL COLLATE NOCASE,
        score REAL NOT NULL,
        max_score REAL NOT NULL,
        weight REAL NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(assessment_id) REFERENCES assessments(id) ON DELETE CASCADE,
        UNIQUE(assessment_id, name),
        CHECK(length(trim(name)) > 0),
        CHECK(score >= 0 AND max_score > 0 AND score <= max_score),
        CHECK(weight > 0 AND weight <= 100)
      )
    ''');
    await database.execute(
      'CREATE INDEX idx_activities_assessment_id ON activities(assessment_id)',
    );
  }

  static Future<void> _createAcademicSettingsTable(Database database) async {
    await database.execute('''
      CREATE TABLE academic_settings (
        id INTEGER PRIMARY KEY CHECK(id = 1),
        default_credit_units REAL NOT NULL DEFAULT 1,
        decimal_places INTEGER NOT NULL DEFAULT 1,
        rounding_mode TEXT NOT NULL DEFAULT 'ceiling',
        cycle_singular TEXT,
        cycle_plural TEXT,
        subject_singular TEXT,
        subject_plural TEXT,
        assessment_singular TEXT,
        assessment_plural TEXT,
        activity_singular TEXT,
        activity_plural TEXT,
        CHECK(default_credit_units > 0),
        CHECK(decimal_places BETWEEN 0 AND 3),
        CHECK(rounding_mode IN ('ceiling', 'nearest', 'floor'))
      )
    ''');
    await database.insert('academic_settings', {
      'id': 1,
      'default_credit_units': 1,
      'decimal_places': 1,
      'rounding_mode': 'ceiling',
    });
  }

  static Future<void> _createAppPreferencesTable(Database database) async {
    await database.execute('''
      CREATE TABLE app_preferences (
        key TEXT PRIMARY KEY NOT NULL,
        value TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final opening = _databaseFuture;
    _databaseFuture = null;
    if (opening != null) {
      final database = await opening;
      await database.close();
    }
  }
}
