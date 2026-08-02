import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class StudentsDatabase {
  StudentsDatabase({DatabaseFactory? factory, this.databasePath})
    : _factory = factory ?? databaseFactory;

  static const schemaVersion = 2;
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
          await _createSubjectsTable(database);
        },
        onUpgrade: (database, oldVersion, newVersion) async {
          if (oldVersion < 2) await _createSubjectsTable(database);
        },
      ),
    );
  }

  static Future<void> _createSubjectsTable(Database database) async {
    await database.execute('''
      CREATE TABLE subjects (
        id TEXT PRIMARY KEY NOT NULL,
        student_id TEXT NOT NULL,
        name TEXT NOT NULL COLLATE NOCASE,
        code TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE,
        UNIQUE(student_id, name),
        CHECK(length(trim(name)) > 0),
        CHECK(updated_at >= created_at)
      )
    ''');
    await database.execute(
      'CREATE INDEX idx_subjects_student_id ON subjects(student_id)',
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
