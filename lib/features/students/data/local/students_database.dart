import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class StudentsDatabase {
  StudentsDatabase({DatabaseFactory? factory, this.databasePath})
    : _factory = factory ?? databaseFactory;

  static const schemaVersion = 4;
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
    await database.execute('''
      CREATE TRIGGER create_default_cycle_after_student
      AFTER INSERT ON students
      BEGIN
        INSERT INTO cycles (id, student_id, name, is_active, created_at, updated_at)
        VALUES ('cycle-' || NEW.id, NEW.id, 'Ciclo actual', 1, NEW.created_at, NEW.updated_at);
      END
    ''');
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
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE,
        FOREIGN KEY(cycle_id) REFERENCES cycles(id) ON DELETE RESTRICT,
        UNIQUE(cycle_id, name),
        CHECK(length(trim(name)) > 0),
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

  Future<void> close() async {
    final opening = _databaseFuture;
    _databaseFuture = null;
    if (opening != null) {
      final database = await opening;
      await database.close();
    }
  }
}
