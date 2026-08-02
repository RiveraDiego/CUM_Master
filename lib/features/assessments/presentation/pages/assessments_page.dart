import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../activities/application/activity_providers.dart';
import '../../../dashboard/application/hierarchical_grade_calculator.dart';
import '../../domain/entities/assessment.dart';
import '../../domain/errors/assessment_exceptions.dart';
import '../controllers/assessments_controller.dart';

class AssessmentsPage extends ConsumerWidget {
  const AssessmentsPage({super.key, required this.subjectId});
  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final values = ref.watch(assessmentsControllerProvider(subjectId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.assessmentsTitle)),
      body: SafeArea(
        child: values.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _CenterMessage(
            text: l10n.assessmentsLoadError,
            action: l10n.retryAction,
            onTap: () => ref
                .read(assessmentsControllerProvider(subjectId).notifier)
                .refresh(),
          ),
          data: (items) => items.isEmpty
              ? _CenterMessage(
                  text: l10n.assessmentsEmptyDescription,
                  action: l10n.assessmentsCreateAction,
                  onTap: () => _edit(context, ref),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, index) => _AssessmentCard(
                    assessment: items[index],
                    onOpen: () => context.pushNamed(
                      AppRoute.activities,
                      pathParameters: {'assessmentId': items[index].id},
                    ),
                    onEdit: () => _edit(context, ref, items[index]),
                    onDelete: () => _delete(context, ref, items[index]),
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.assessmentsCreateAction),
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, [
    Assessment? current,
  ]) async {
    final l10n = AppLocalizations.of(context)!;
    final name = TextEditingController(text: current?.name);
    final score = TextEditingController(text: current?.score.toString());
    final max = TextEditingController(text: current?.maxScore.toString());
    final weight = TextEditingController(text: current?.weight?.toString());
    final key = GlobalKey<FormState>();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          current == null
              ? l10n.assessmentCreateTitle
              : l10n.assessmentEditTitle,
        ),
        content: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: l10n.assessmentNameLabel,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.assessmentNameRequiredError
                      : null,
                ),
                TextFormField(
                  controller: score,
                  decoration: InputDecoration(
                    labelText: l10n.assessmentScoreLabel,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [_decimalFormatter],
                  validator: (v) =>
                      _positiveOrZero(v) ? null : l10n.assessmentNumberError,
                ),
                TextFormField(
                  controller: max,
                  decoration: InputDecoration(
                    labelText: l10n.assessmentMaxScoreLabel,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [_decimalFormatter],
                  validator: (v) {
                    if (!_positive(v)) return l10n.assessmentPositiveError;
                    final obtained = double.tryParse(score.text);
                    final maximum = double.parse(v!);
                    return obtained != null && obtained > maximum
                        ? l10n.assessmentScoreRangeError
                        : null;
                  },
                ),
                TextFormField(
                  controller: weight,
                  decoration: InputDecoration(
                    labelText: l10n.assessmentWeightLabel,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [_decimalFormatter],
                  validator: (v) =>
                      v == null ||
                          v.trim().isEmpty ||
                          (_positive(v) && double.parse(v) <= 100)
                      ? null
                      : l10n.assessmentWeightError,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () {
              if (key.currentState!.validate() &&
                  double.parse(score.text) <= double.parse(max.text)) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: Text(l10n.saveAction),
          ),
        ],
      ),
    );
    if (saved == true && context.mounted) {
      try {
        final notifier = ref.read(
          assessmentsControllerProvider(subjectId).notifier,
        );
        final optionalWeight = weight.text.trim().isEmpty
            ? null
            : double.parse(weight.text);
        if (current == null) {
          await notifier.create(
            name: name.text,
            score: double.parse(score.text),
            maxScore: double.parse(max.text),
            weight: optionalWeight,
          );
        } else {
          await notifier.updateValue(
            id: current.id,
            name: name.text,
            score: double.parse(score.text),
            maxScore: double.parse(max.text),
            weight: optionalWeight,
          );
        }
      } on DuplicateAssessmentNameException {
        if (context.mounted) _snack(context, l10n.assessmentDuplicateError);
      } on AssessmentException {
        if (context.mounted) _snack(context, l10n.assessmentStorageError);
      }
    }
    name.dispose();
    score.dispose();
    max.dispose();
    weight.dispose();
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Assessment value,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.assessmentDeleteTitle),
        content: Text(l10n.assessmentDeleteMessage(value.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(l10n.deleteAction),
          ),
        ],
      ),
    );
    if (yes == true) {
      try {
        await ref
            .read(assessmentsControllerProvider(subjectId).notifier)
            .delete(value.id);
      } on AssessmentException {
        if (context.mounted) _snack(context, l10n.assessmentStorageError);
      }
    }
  }

  static bool _positiveOrZero(String? value) {
    final number = double.tryParse(value ?? '');
    return number != null && number >= 0;
  }

  static bool _positive(String? value) {
    final number = double.tryParse(value ?? '');
    return number != null && number > 0;
  }

  static final _decimalFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'^\d*[.]?\d{0,2}'),
  );
  static void _snack(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class _AssessmentCard extends ConsumerWidget {
  const _AssessmentCard({
    required this.assessment,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });
  final Assessment assessment;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final activities = ref.watch(activitiesProvider(assessment.id));
    final grade = activities.whenData(
      (items) => const HierarchicalGradeCalculator().evaluationGrade(
        assessment,
        items,
      ),
    );
    final calculated = grade.value;
    return Card(
      child: ListTile(
        onTap: onOpen,
        leading: CircleAvatar(
          child: Text(calculated == null ? '—' : calculated.toStringAsFixed(1)),
        ),
        title: Text(assessment.name),
        subtitle: Text(
          activities.value?.isEmpty ?? true
              ? l10n.assessmentManualGrade
              : l10n.assessmentCalculatedGrade,
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => action == 'edit' ? onEdit() : onDelete(),
          itemBuilder: (_) => [
            PopupMenuItem(value: 'edit', child: Text(l10n.editAction)),
            PopupMenuItem(value: 'delete', child: Text(l10n.deleteAction)),
          ],
        ),
      ),
    );
  }
}

class _CenterMessage extends StatelessWidget {
  const _CenterMessage({
    required this.text,
    required this.action,
    required this.onTap,
  });
  final String text;
  final String action;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.fact_check_outlined, size: 48),
          const SizedBox(height: 16),
          Text(text, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton(onPressed: onTap, child: Text(action)),
        ],
      ),
    ),
  );
}
