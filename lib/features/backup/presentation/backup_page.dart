import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../students/presentation/controllers/students_controller.dart';
import '../application/backup_providers.dart';
import '../domain/backup_exceptions.dart';

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              enabled: !_busy,
              leading: const Icon(Icons.ios_share_outlined),
              title: Text(l10n.backupExportTitle),
              subtitle: Text(l10n.backupExportDescription),
              trailing: const Icon(Icons.chevron_right),
              onTap: _export,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              enabled: !_busy,
              leading: const Icon(Icons.file_download_outlined),
              title: Text(l10n.backupImportTitle),
              subtitle: Text(l10n.backupImportDescription),
              trailing: const Icon(Icons.chevron_right),
              onTap: _confirmImport,
            ),
          ),
          if (_busy) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Future<void> _export() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      await ref.read(backupActionsProvider).exportAndShare();
    } on BackupException {
      _show(l10n.backupExportError);
    } on Exception {
      _show(l10n.backupExportError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmImport() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.backupImportConfirmTitle),
        content: Text(l10n.backupImportConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.backupChooseFileAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await Future<void>.delayed(kThemeAnimationDuration);
    if (!mounted) return;
    setState(() => _busy = true);
    try {
      final imported = await ref.read(backupActionsProvider).pickAndImport();
      if (!imported || !mounted) return;
      ref.invalidate(studentsControllerProvider);
      ref.invalidate(dashboardControllerProvider);
      _show(l10n.backupImportSuccess);
    } on InvalidBackupException {
      _show(l10n.backupInvalidFileError);
    } on BackupException {
      _show(l10n.backupImportError);
    } on FormatException {
      _show(l10n.backupInvalidFileError);
    } on Exception {
      _show(l10n.backupImportError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
