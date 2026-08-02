import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/subject.dart';
import '../../domain/errors/subject_exceptions.dart';
import '../controllers/subjects_controller.dart';

class SubjectsPage extends ConsumerWidget {
  const SubjectsPage({super.key, required this.studentId});
  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final subjects = ref.watch(subjectsControllerProvider(studentId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.subjectsTitle)),
      body: SafeArea(
        child: subjects.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _MessageState(
            message: l10n.subjectsLoadError,
            action: l10n.retryAction,
            onPressed: () => ref
                .read(subjectsControllerProvider(studentId).notifier)
                .refresh(),
          ),
          data: (items) => items.isEmpty
              ? _MessageState(
                  message: l10n.subjectsEmptyDescription,
                  action: l10n.subjectsCreateAction,
                  onPressed: () => _create(context),
                )
              : RefreshIndicator(
                  onRefresh: () => ref
                      .read(subjectsControllerProvider(studentId).notifier)
                      .refresh(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _SubjectCard(
                      subject: items[index],
                      onEdit: () => context.pushNamed(
                        AppRoute.subjectEdit,
                        pathParameters: {
                          'studentId': studentId,
                          'subjectId': items[index].id,
                        },
                      ),
                      onDelete: () => _delete(context, ref, items[index]),
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.subjectsCreateAction),
      ),
    );
  }

  void _create(BuildContext context) => context.pushNamed(
    AppRoute.subjectCreate,
    pathParameters: {'studentId': studentId},
  );

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.subjectDeleteTitle),
        content: Text(l10n.subjectDeleteMessage(subject.name)),
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
      await ref
          .read(subjectsControllerProvider(studentId).notifier)
          .delete(subject.id);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.subjectDeleted)));
      }
    } on SubjectNotFoundException {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.subjectNotFoundError)));
      }
    } on SubjectException {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.subjectStorageError)));
      }
    }
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.subject,
    required this.onEdit,
    required this.onDelete,
  });
  final Subject subject;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.menu_book_outlined)),
        title: Text(subject.name),
        subtitle: subject.code == null
            ? Text(l10n.subjectCodeNotSpecified)
            : Text(subject.code!),
        trailing: PopupMenuButton<_Action>(
          tooltip: l10n.subjectMoreActions,
          onSelected: (action) =>
              action == _Action.edit ? onEdit() : onDelete(),
          itemBuilder: (_) => [
            PopupMenuItem(value: _Action.edit, child: Text(l10n.editAction)),
            PopupMenuItem(
              value: _Action.delete,
              child: Text(l10n.deleteAction),
            ),
          ],
        ),
      ),
    );
  }
}

enum _Action { edit, delete }

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.message,
    required this.action,
    required this.onPressed,
  });
  final String message;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.menu_book_outlined, size: 48),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.add),
            label: Text(action),
          ),
        ],
      ),
    ),
  );
}
