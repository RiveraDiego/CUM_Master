import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/presentation/widgets/app_drawer.dart';
import '../../../../shared/presentation/widgets/app_navigation_app_bar.dart';
import '../../../cycles/application/cycle_providers.dart';
import '../../../cycles/application/viewed_cycle_provider.dart';
import '../../../cycles/domain/errors/cycle_exceptions.dart';
import '../../../settings/application/academic_settings_providers.dart';
import '../../application/subject_providers.dart';
import '../../domain/entities/subject.dart';
import '../../domain/errors/subject_exceptions.dart';
import '../controllers/subjects_controller.dart';

class SubjectFormPage extends ConsumerStatefulWidget {
  const SubjectFormPage({super.key, required this.studentId, this.subjectId});
  final String studentId;
  final String? subjectId;

  @override
  ConsumerState<SubjectFormPage> createState() => _SubjectFormPageState();
}

class _SubjectFormPageState extends ConsumerState<SubjectFormPage> {
  static const _createCycleValue = '__create_cycle__';
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _code = TextEditingController();
  final _creditUnits = TextEditingController();
  final _manualGrade = TextEditingController();
  Future<Subject?>? _subjectFuture;
  bool _initialized = false;
  bool _saving = false;
  String? _cycleId;
  bool _defaultUvInitialized = false;

  bool get _editing => widget.subjectId != null;

  @override
  void initState() {
    super.initState();
    if (_editing) {
      _subjectFuture = ref.read(getSubjectProvider)(widget.subjectId!);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _creditUnits.dispose();
    _manualGrade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appNavigationAppBar(
        context,
        title: Text(_editing ? l10n.subjectEditTitle : l10n.subjectCreateTitle),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: _editing && !_initialized
            ? FutureBuilder<Subject?>(
                future: _subjectFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _loadError(l10n.subjectStorageError, retry: true);
                  }
                  final subject = snapshot.data;
                  if (subject == null ||
                      subject.studentId != widget.studentId) {
                    return _loadError(l10n.subjectNotFoundError);
                  }
                  _name.text = subject.name;
                  _code.text = subject.code ?? '';
                  _creditUnits.text = subject.creditUnits.toString();
                  _manualGrade.text =
                      subject.manualFinalGrade?.toString() ?? '';
                  _cycleId = subject.cycleId;
                  _initialized = true;
                  return _form(l10n);
                },
              )
            : _form(l10n),
      ),
    );
  }

  Widget _form(AppLocalizations l10n) {
    final cycles = ref.watch(cyclesProvider(widget.studentId));
    final academicSettings = ref.watch(academicSettingsProvider).value;
    if (!_editing && !_defaultUvInitialized && academicSettings != null) {
      _creditUnits.text = academicSettings.defaultCreditUnits.toString();
      _defaultUvInitialized = true;
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            cycles.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => Text(l10n.cyclesLoadError),
              data: (items) {
                final viewedCycleId = ref.watch(
                  viewedCycleIdsProvider,
                )[widget.studentId];
                _cycleId ??= items.any((item) => item.id == viewedCycleId)
                    ? viewedCycleId
                    : items.where((item) => item.isActive).firstOrNull?.id;
                return DropdownButtonFormField<String>(
                  initialValue: _cycleId,
                  decoration: InputDecoration(
                    labelText: l10n.subjectCycleLabel,
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                  ),
                  items: items
                      .map(
                        (item) => DropdownMenuItem(
                          value: item.id,
                          child: Text(item.name),
                        ),
                      )
                      .followedBy([
                        DropdownMenuItem(
                          value: _createCycleValue,
                          child: Row(
                            children: [
                              const Icon(Icons.add, size: 20),
                              const SizedBox(width: 8),
                              Text(l10n.cycleCreateInlineAction),
                            ],
                          ),
                        ),
                      ])
                      .toList(),
                  onChanged: _saving
                      ? null
                      : (value) async {
                          if (value == _createCycleValue) {
                            await _createCycle(l10n);
                          } else {
                            setState(() => _cycleId = value);
                            if (value != null) {
                              ref
                                  .read(viewedCycleIdsProvider.notifier)
                                  .select(widget.studentId, value);
                            }
                          }
                        },
                  validator: (value) =>
                      value == null ? l10n.subjectCycleRequiredError : null,
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _saving
                    ? null
                    : () => context.pushNamed(
                        AppRoute.cycles,
                        pathParameters: {'studentId': widget.studentId},
                      ),
                icon: const Icon(Icons.settings_outlined),
                label: Text(l10n.cyclesManageAction),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              enabled: !_saving,
              autofocus: !_editing,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.subjectNameLabel,
                prefixIcon: const Icon(Icons.menu_book_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.subjectNameRequiredError
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _code,
              enabled: !_saving,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _save(),
              decoration: InputDecoration(
                labelText: l10n.subjectCodeLabel,
                prefixIcon: const Icon(Icons.tag),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _creditUnits,
              enabled: !_saving,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.subjectCreditUnitsLabel,
                prefixIcon: const Icon(Icons.school_outlined),
              ),
              validator: (value) => (double.tryParse(value ?? '') ?? 0) > 0
                  ? null
                  : l10n.subjectCreditUnitsError,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _manualGrade,
              enabled: !_saving,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.subjectHistoricalGradeLabel,
                helperText: l10n.subjectHistoricalGradeHelp,
                prefixIcon: const Icon(Icons.history_edu_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                final grade = double.tryParse(value);
                return grade != null && grade >= 0 && grade <= 10
                    ? null
                    : l10n.subjectHistoricalGradeError;
              },
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(l10n.saveAction),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createCycle(AppLocalizations l10n) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.cycleCreateTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) => Navigator.pop(dialogContext, value.trim()),
          decoration: InputDecoration(labelText: l10n.cycleNameLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(l10n.saveAction),
          ),
        ],
      ),
    );
    await Future<void>.delayed(kThemeAnimationDuration);
    controller.dispose();
    if (name == null || name.isEmpty || !mounted) return;
    try {
      final cycle = await ref
          .read(cycleActionsProvider)
          .create(widget.studentId, name, active: false);
      if (mounted) {
        ref
            .read(viewedCycleIdsProvider.notifier)
            .select(widget.studentId, cycle.id);
        setState(() => _cycleId = cycle.id);
      }
    } on DuplicateCycleNameException {
      _show(l10n.cycleDuplicateError);
    } on CycleException {
      _show(l10n.cycleStorageError);
    }
  }

  Widget _loadError(String message, {bool retry = false}) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          if (retry)
            TextButton(
              onPressed: () => setState(
                () => _subjectFuture = ref.read(getSubjectProvider)(
                  widget.subjectId!,
                ),
              ),
              child: Text(l10n.retryAction),
            ),
          TextButton(onPressed: context.pop, child: Text(l10n.closeAction)),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      final notifier = ref.read(
        subjectsControllerProvider(widget.studentId).notifier,
      );
      if (_editing) {
        await notifier.updateSubject(
          id: widget.subjectId!,
          cycleId: _cycleId!,
          name: _name.text,
          code: _code.text,
          creditUnits: double.parse(_creditUnits.text),
          manualFinalGrade: _manualGrade.text.trim().isEmpty
              ? null
              : double.parse(_manualGrade.text),
        );
      } else {
        await notifier.create(
          cycleId: _cycleId!,
          name: _name.text,
          code: _code.text,
          creditUnits: double.parse(_creditUnits.text),
          manualFinalGrade: _manualGrade.text.trim().isEmpty
              ? null
              : double.parse(_manualGrade.text),
        );
      }
      if (mounted) context.pop();
    } on DuplicateSubjectNameException {
      _show(l10n.subjectDuplicateError);
    } on SubjectNotFoundException {
      _show(l10n.subjectNotFoundError);
    } on SubjectException {
      _show(l10n.subjectStorageError);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _show(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
