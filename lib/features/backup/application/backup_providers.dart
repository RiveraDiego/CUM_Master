import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart' hide XFile;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/state/academic_data_revision.dart';
import '../../onboarding/application/tutorial_providers.dart';
import '../../students/application/student_providers.dart';
import '../../settings/application/academic_settings_providers.dart';
import '../data/sqlite_backup_repository.dart';
import '../domain/backup_repository.dart';

final backupRepositoryProvider = Provider<BackupRepository>(
  (ref) => SqliteBackupRepository(ref.watch(studentsDatabaseProvider)),
);

class BackupActions {
  const BackupActions(this.ref);
  final Ref ref;

  Future<bool> exportAndShare() async {
    final json = await ref.read(backupRepositoryProvider).exportJson();
    final directory = await getTemporaryDirectory();
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final file = File(
      '${directory.path}${Platform.pathSeparator}cum-master-$date.json',
    );
    await file.writeAsString(json, encoding: utf8, flush: true);
    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: 'CUM Master backup',
      ),
    );
    return result.status != ShareResultStatus.unavailable;
  }

  Future<bool> pickAndImport() async {
    const type = XTypeGroup(
      label: 'CUM Master backup',
      extensions: ['json'],
      mimeTypes: ['application/json'],
    );
    final picked = await openFile(acceptedTypeGroups: const [type]);
    if (picked == null) return false;
    final bytes = await picked.readAsBytes();
    await ref.read(backupRepositoryProvider).importJson(utf8.decode(bytes));
    ref.invalidate(academicSettingsProvider);
    ref.invalidate(tutorialCompletedProvider);
    ref.read(academicDataRevisionProvider.notifier).bump();
    return true;
  }
}

final backupActionsProvider = Provider(BackupActions.new);
