import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/state/academic_data_revision.dart';
import '../../onboarding/application/tutorial_providers.dart';
import '../../students/application/student_providers.dart';
import '../../settings/application/academic_settings_providers.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../data/sqlite_backup_repository.dart';
import '../domain/backup_exceptions.dart';
import '../domain/backup_repository.dart';

final backupRepositoryProvider = Provider<BackupRepository>(
  (ref) => SqliteBackupRepository(ref.watch(studentsDatabaseProvider)),
);

class BackupActions {
  const BackupActions(this.ref);
  final Ref ref;

  Future<({String json, String name})> _createExport() async {
    final json = await ref.read(backupRepositoryProvider).exportJson();
    final date = DateTime.now().toIso8601String().substring(0, 10);
    return (json: json, name: 'cum-master-$date.json');
  }

  Future<bool> exportAndShare() async {
    final export = await _createExport();
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}${Platform.pathSeparator}${export.name}',
    );
    await file.writeAsString(export.json, encoding: utf8, flush: true);
    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: 'CUM Master backup',
      ),
    );
    return result.status != ShareResultStatus.unavailable;
  }

  Future<bool> exportAndSave() async {
    final export = await _createExport();
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar copia de CUM Master',
      fileName: export.name,
      type: FileType.custom,
      allowedExtensions: const ['json'],
      bytes: Uint8List.fromList(utf8.encode(export.json)),
    );
    return path != null;
  }

  Future<bool> pickAndImport() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Seleccionar copia de CUM Master',
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    if (result == null) return false;
    final bytes = result.files.single.bytes;
    if (bytes == null) throw const BackupStorageException();
    await ref.read(backupRepositoryProvider).importJson(utf8.decode(bytes));
    ref.invalidate(academicSettingsProvider);
    ref.invalidate(tutorialCompletedProvider);
    ref.invalidate(appThemeModeProvider);
    ref.read(academicDataRevisionProvider.notifier).bump();
    return true;
  }
}

final backupActionsProvider = Provider(BackupActions.new);
