import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../cycles/application/cycle_providers.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _code = TextEditingController();
  Future<Subject?>? _subjectFuture;
  bool _initialized = false;
  bool _saving = false;
  String? _cycleId;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? l10n.subjectEditTitle : l10n.subjectCreateTitle),
      ),
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
                _cycleId ??= items
                    .where((item) => item.isActive)
                    .firstOrNull
                    ?.id;
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
                      .toList(),
                  onChanged: _saving
                      ? null
                      : (value) => setState(() => _cycleId = value),
                  validator: (value) =>
                      value == null ? l10n.subjectCycleRequiredError : null,
                );
              },
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
        );
      } else {
        await notifier.create(
          cycleId: _cycleId!,
          name: _name.text,
          code: _code.text,
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
