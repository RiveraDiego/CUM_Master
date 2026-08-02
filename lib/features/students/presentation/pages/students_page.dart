import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/student.dart';
import '../../domain/errors/student_exceptions.dart';
import '../controllers/students_controller.dart';

class StudentsPage extends ConsumerWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final students = ref.watch(studentsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.studentsTitle)),
      body: SafeArea(
        child: students.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ErrorState(
            onRetry: () =>
                ref.read(studentsControllerProvider.notifier).refresh(),
          ),
          data: (items) => items.isEmpty
              ? _EmptyState(
                  onCreate: () => context.pushNamed(AppRoute.studentCreate),
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      ref.read(studentsControllerProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _StudentCard(
                      student: items[index],
                      onOpen: () => context.pushNamed(
                        AppRoute.subjects,
                        pathParameters: {'studentId': items[index].id},
                      ),
                      onEdit: () => context.pushNamed(
                        AppRoute.studentEdit,
                        pathParameters: {'studentId': items[index].id},
                      ),
                      onDelete: () =>
                          _confirmDelete(context, ref, items[index]),
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoute.studentCreate),
        icon: const Icon(Icons.person_add_outlined),
        label: Text(l10n.studentsCreateAction),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Student student,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.studentDeleteTitle),
        content: Text(l10n.studentDeleteMessage(student.studentCard)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.deleteAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(studentsControllerProvider.notifier).delete(student.id);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.studentDeleted)));
      }
    } on StudentNotFoundException {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.studentNotFoundError)));
      }
    } on StudentException {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.studentStorageError)));
      }
    }
  }
}

class _StudentCard extends StatelessWidget {
  const _StudentCard({
    required this.student,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final Student student;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        onTap: onOpen,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
        leading: const CircleAvatar(child: Icon(Icons.person_outline)),
        title: Text(student.studentCard),
        subtitle: student.university == null
            ? Text(l10n.studentUniversityNotSpecified)
            : Text(student.university!),
        isThreeLine: false,
        trailing: PopupMenuButton<_StudentAction>(
          tooltip: l10n.studentMoreActions,
          onSelected: (action) {
            switch (action) {
              case _StudentAction.edit:
                onEdit();
                return;
              case _StudentAction.delete:
                onDelete();
                return;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _StudentAction.edit,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.edit_outlined),
                title: Text(l10n.editAction),
              ),
            ),
            PopupMenuItem(
              value: _StudentAction.delete,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.deleteAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _StudentAction { edit, delete }

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.school_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.studentsEmptyTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.studentsEmptyDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.person_add_outlined),
                label: Text(l10n.studentsCreateAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.studentsLoadError, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onRetry,
              child: Text(l10n.retryAction),
            ),
          ],
        ),
      ),
    );
  }
}
