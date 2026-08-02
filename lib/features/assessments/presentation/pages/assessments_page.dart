import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/application/academic_location_provider.dart';
import '../../../../shared/presentation/widgets/academic_location_bar.dart';
import '../../../../shared/presentation/widgets/app_drawer.dart';
import '../../../../shared/presentation/widgets/app_navigation_app_bar.dart';
import '../../../activities/application/activity_providers.dart';
import '../../../dashboard/application/hierarchical_grade_calculator.dart';
import '../../../settings/application/academic_settings_providers.dart';
import '../../../settings/domain/academic_settings.dart';
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
    final location = ref.watch(subjectLocationProvider(subjectId));
    final terminology = ref.watch(academicSettingsProvider).value;
    final title = terminology?.assessmentPlural?.trim();
    return Scaffold(
      appBar: appNavigationAppBar(
        context,
        title: Text(
          title == null || title.isEmpty ? l10n.assessmentsTitle : title,
        ),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _LocationHeader(location: location),
            Expanded(
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
          ],
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
    final location = await ref.read(subjectLocationProvider(subjectId).future);
    if (!context.mounted) return;
    final value = await showDialog<_AssessmentFormValue>(
      context: context,
      builder: (_) =>
          _AssessmentEditorDialog(current: current, location: location),
    );
    if (value != null && context.mounted) {
      try {
        final notifier = ref.read(
          assessmentsControllerProvider(subjectId).notifier,
        );
        if (current == null) {
          await notifier.create(
            name: value.name,
            score: value.score,
            maxScore: value.maxScore,
            weight: value.weight,
          );
        } else {
          await notifier.updateValue(
            id: current.id,
            name: value.name,
            score: value.score,
            maxScore: value.maxScore,
            weight: value.weight,
          );
        }
      } on DuplicateAssessmentNameException {
        if (context.mounted) _snack(context, l10n.assessmentDuplicateError);
      } on AssessmentException {
        if (context.mounted) _snack(context, l10n.assessmentStorageError);
      }
    }
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

  static void _snack(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class _AssessmentFormValue {
  const _AssessmentFormValue({
    required this.name,
    required this.score,
    required this.maxScore,
    required this.weight,
  });

  final String name;
  final double score;
  final double maxScore;
  final double? weight;
}

class _AssessmentEditorDialog extends StatefulWidget {
  const _AssessmentEditorDialog({this.current, this.location});

  final Assessment? current;
  final AcademicLocation? location;

  @override
  State<_AssessmentEditorDialog> createState() =>
      _AssessmentEditorDialogState();
}

class _AssessmentEditorDialogState extends State<_AssessmentEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _score;
  late final TextEditingController _maxScore;
  late final TextEditingController _weight;

  static final _decimalFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'^\d*[.]?\d{0,2}'),
  );

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.current?.name);
    _score = TextEditingController(text: widget.current?.score.toString());
    _maxScore = TextEditingController(
      text: widget.current?.maxScore.toString(),
    );
    _weight = TextEditingController(text: widget.current?.weight?.toString());
  }

  @override
  void dispose() {
    _name.dispose();
    _score.dispose();
    _maxScore.dispose();
    _weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
        widget.current == null
            ? l10n.assessmentCreateTitle
            : l10n.assessmentEditTitle,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.location != null)
                AcademicLocationBar(
                  semanticLabel: l10n.academicLocationLabel,
                  items: [
                    AcademicLocationItem(
                      Icons.person_outline,
                      widget.location!.student,
                    ),
                    AcademicLocationItem(
                      Icons.calendar_month_outlined,
                      widget.location!.cycle,
                    ),
                    AcademicLocationItem(
                      Icons.menu_book_outlined,
                      widget.location!.subject,
                    ),
                  ],
                ),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: l10n.assessmentNameLabel,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.assessmentNameRequiredError
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _score,
                decoration: InputDecoration(
                  labelText: l10n.assessmentScoreLabel,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [_decimalFormatter],
                validator: (value) =>
                    _positiveOrZero(value) ? null : l10n.assessmentNumberError,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxScore,
                decoration: InputDecoration(
                  labelText: l10n.assessmentMaxScoreLabel,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [_decimalFormatter],
                validator: (value) {
                  if (!_positive(value)) return l10n.assessmentPositiveError;
                  final obtained = double.tryParse(_score.text);
                  final maximum = double.parse(value!);
                  return obtained != null && obtained > maximum
                      ? l10n.assessmentScoreRangeError
                      : null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weight,
                decoration: InputDecoration(
                  labelText: l10n.assessmentWeightLabel,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [_decimalFormatter],
                validator: (value) =>
                    value == null ||
                        value.trim().isEmpty ||
                        (_positive(value) && double.parse(value) <= 100)
                    ? null
                    : l10n.assessmentWeightError,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancelAction),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.saveAction)),
      ],
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final score = double.parse(_score.text);
    final maxScore = double.parse(_maxScore.text);
    if (score > maxScore) return;
    Navigator.pop(
      context,
      _AssessmentFormValue(
        name: _name.text.trim(),
        score: score,
        maxScore: maxScore,
        weight: _weight.text.trim().isEmpty ? null : double.parse(_weight.text),
      ),
    );
  }

  static bool _positiveOrZero(String? value) {
    final number = double.tryParse(value ?? '');
    return number != null && number >= 0;
  }

  static bool _positive(String? value) {
    final number = double.tryParse(value ?? '');
    return number != null && number > 0;
  }
}

class _LocationHeader extends StatelessWidget {
  const _LocationHeader({required this.location});

  final AsyncValue<AcademicLocation?> location;

  @override
  Widget build(BuildContext context) => location.maybeWhen(
    data: (value) => value == null
        ? const SizedBox.shrink()
        : AcademicLocationBar(
            semanticLabel: AppLocalizations.of(context)!.academicLocationLabel,
            items: [
              AcademicLocationItem(Icons.person_outline, value.student),
              AcademicLocationItem(Icons.calendar_month_outlined, value.cycle),
              AcademicLocationItem(Icons.menu_book_outlined, value.subject),
            ],
          ),
    orElse: () => const SizedBox(height: 8),
  );
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
    final settings =
        ref.watch(academicSettingsProvider).value ?? AcademicSettings.defaults;
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
          child: Text(calculated == null ? '—' : settings.format(calculated)),
        ),
        title: Text(assessment.name),
        subtitle: Text(
          activities.value?.isEmpty ?? true
              ? l10n.assessmentManualGrade
              : l10n.assessmentCalculatedGrade,
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              action == 'edit' ? onEdit() : onDelete();
            });
          },
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
