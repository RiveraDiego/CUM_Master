import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/presentation/widgets/app_drawer.dart';
import '../../../../shared/presentation/widgets/app_navigation_app_bar.dart';
import '../../../cycles/application/cycle_providers.dart';
import '../../../cycles/domain/entities/academic_cycle.dart';
import '../../../settings/application/academic_settings_providers.dart';
import '../../domain/entities/subject.dart';
import '../../domain/errors/subject_exceptions.dart';
import '../controllers/subjects_controller.dart';

class SubjectsPage extends ConsumerStatefulWidget {
  const SubjectsPage({super.key, required this.studentId});
  final String studentId;

  @override
  ConsumerState<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends ConsumerState<SubjectsPage> {
  String? _selectedCycleId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subjects = ref.watch(subjectsControllerProvider(widget.studentId));
    final cycles = ref.watch(cyclesProvider(widget.studentId));
    final terminology = ref.watch(academicSettingsProvider).value;
    final title = terminology?.subjectPlural?.trim();
    return Scaffold(
      appBar: appNavigationAppBar(
        context,
        title: Text(
          title == null || title.isEmpty ? l10n.subjectsTitle : title,
        ),
        actions: [
          IconButton(
            tooltip: l10n.cyclesTitle,
            onPressed: _manageCycles,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: cycles.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _MessageState(
            message: l10n.cyclesLoadError,
            action: l10n.retryAction,
            onPressed: () => ref.invalidate(cyclesProvider(widget.studentId)),
          ),
          data: (cycleItems) => _content(l10n, subjects, cycleItems),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.subjectsCreateAction),
      ),
    );
  }

  Widget _content(
    AppLocalizations l10n,
    AsyncValue<List<Subject>> subjects,
    List<AcademicCycle> cycles,
  ) {
    if (cycles.isEmpty) {
      return _MessageState(
        message: l10n.cyclesEmpty,
        action: l10n.cyclesCreateAction,
        onPressed: _manageCycles,
      );
    }
    final selected = cycles.any((cycle) => cycle.id == _selectedCycleId)
        ? _selectedCycleId!
        : cycles.where((cycle) => cycle.isActive).firstOrNull?.id ??
              cycles.first.id;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selected,
                  decoration: InputDecoration(
                    labelText: l10n.subjectsCycleFilterLabel,
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                  ),
                  items: cycles
                      .map<DropdownMenuItem<String>>(
                        (cycle) => DropdownMenuItem(
                          value: cycle.id,
                          child: Text(
                            cycle.isActive
                                ? '${cycle.name} · ${l10n.cycleActive}'
                                : cycle.name,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedCycleId = value),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: l10n.cyclesManageAction,
                onPressed: _manageCycles,
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
        ),
        Expanded(
          child: subjects.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => _MessageState(
              message: l10n.subjectsLoadError,
              action: l10n.retryAction,
              onPressed: () => ref
                  .read(subjectsControllerProvider(widget.studentId).notifier)
                  .refresh(),
            ),
            data: (items) {
              final visible = items
                  .where((item) => item.cycleId == selected)
                  .toList();
              if (visible.isEmpty) {
                return _MessageState(
                  message: l10n.subjectsEmptyForCycle,
                  action: l10n.subjectsCreateAction,
                  onPressed: () => _create(context),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref
                    .read(subjectsControllerProvider(widget.studentId).notifier)
                    .refresh(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _SubjectCard(
                    subject: visible[index],
                    onOpen: () => context.pushNamed(
                      AppRoute.assessments,
                      pathParameters: {
                        'studentId': widget.studentId,
                        'subjectId': visible[index].id,
                      },
                    ),
                    onEdit: () => context.pushNamed(
                      AppRoute.subjectEdit,
                      pathParameters: {
                        'studentId': widget.studentId,
                        'subjectId': visible[index].id,
                      },
                    ),
                    onDelete: () => _delete(context, ref, visible[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _manageCycles() => context.pushNamed(
    AppRoute.cycles,
    pathParameters: {'studentId': widget.studentId},
  );

  void _create(BuildContext context) => context.pushNamed(
    AppRoute.subjectCreate,
    pathParameters: {'studentId': widget.studentId},
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
          .read(subjectsControllerProvider(widget.studentId).notifier)
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
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });
  final Subject subject;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        onTap: onOpen,
        leading: const CircleAvatar(child: Icon(Icons.menu_book_outlined)),
        title: Text(subject.name),
        subtitle: subject.code == null
            ? Text(l10n.subjectCodeNotSpecified)
            : Text(subject.code!),
        trailing: PopupMenuButton<_Action>(
          tooltip: l10n.subjectMoreActions,
          onSelected: (action) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              action == _Action.edit ? onEdit() : onDelete();
            });
          },
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
