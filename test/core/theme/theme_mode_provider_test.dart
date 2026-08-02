import 'package:cum_master/core/theme/theme_mode_provider.dart';
import 'package:cum_master/features/students/application/student_providers.dart';
import 'package:cum_master/features/students/data/local/students_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('uses the system theme by default and persists a selection', () async {
    final database = StudentsDatabase(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    final container = ProviderContainer(
      overrides: [studentsDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(() async {
      container.dispose();
      await database.close();
    });

    expect(await container.read(appThemeModeProvider.future), ThemeMode.system);

    await container.read(appThemeModeActionsProvider).save(ThemeMode.dark);
    expect(await container.read(appThemeModeProvider.future), ThemeMode.dark);
  });
}
