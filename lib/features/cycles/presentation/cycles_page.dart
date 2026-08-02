import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/cycle_providers.dart';
import '../domain/errors/cycle_exceptions.dart';

class CyclesPage extends ConsumerWidget {
  const CyclesPage({super.key, required this.studentId});
  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cycles = ref.watch(cyclesProvider(studentId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.cyclesTitle)),
      body: cycles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.cyclesLoadError)),
        data: (items) => items.isEmpty
            ? Center(child: Text(l10n.cyclesEmpty))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, index) => Card(
                  child: ListTile(
                    leading: Icon(
                      items[index].isActive
                          ? Icons.check_circle
                          : Icons.calendar_month_outlined,
                    ),
                    title: Text(items[index].name),
                    subtitle: items[index].isActive
                        ? Text(l10n.cycleActive)
                        : null,
                    onTap: items[index].isActive
                        ? null
                        : () => ref
                              .read(cycleActionsProvider)
                              .setActive(studentId, items[index].id),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(context, ref, items[index].id),
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.cyclesCreateAction),
      ),
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.cycleCreateTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.cycleNameLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, controller.text.trim()),
            child: Text(l10n.saveAction),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    try {
      final existing = await ref.read(cyclesProvider(studentId).future);
      await ref
          .read(cycleActionsProvider)
          .create(studentId, name, active: existing.isEmpty);
    } on DuplicateCycleNameException {
      if (context.mounted) _show(context, l10n.cycleDuplicateError);
    } on CycleException {
      if (context.mounted) _show(context, l10n.cycleStorageError);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref.read(cycleActionsProvider).delete(studentId, id);
    } on CycleInUseException {
      if (context.mounted) _show(context, l10n.cycleInUseError);
    } on CycleException {
      if (context.mounted) _show(context, l10n.cycleStorageError);
    }
  }

  static void _show(BuildContext context, String message) =>
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
}
