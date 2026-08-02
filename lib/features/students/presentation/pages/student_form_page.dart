import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/presentation/widgets/app_drawer.dart';
import '../../../../shared/presentation/widgets/app_navigation_app_bar.dart';
import '../../application/student_providers.dart';
import '../../domain/entities/student.dart';
import '../../domain/errors/student_exceptions.dart';
import '../controllers/students_controller.dart';

class StudentFormPage extends ConsumerStatefulWidget {
  const StudentFormPage({super.key, this.studentId});

  final String? studentId;

  @override
  ConsumerState<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends ConsumerState<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _studentCardController = TextEditingController();
  final _nameController = TextEditingController();
  final _universityController = TextEditingController();
  Future<Student?>? _studentFuture;
  bool _saving = false;
  bool _initialized = false;

  bool get _isEditing => widget.studentId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _studentFuture = ref.read(getStudentProvider)(widget.studentId!);
    }
  }

  @override
  void dispose() {
    _studentCardController.dispose();
    _nameController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appNavigationAppBar(
        context,
        title: Text(
          _isEditing ? l10n.studentEditTitle : l10n.studentCreateTitle,
        ),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: _isEditing && !_initialized
            ? FutureBuilder<Student?>(
                future: _studentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _LoadFailureState(
                      message: l10n.studentStorageError,
                      onRetry: _reloadStudent,
                      onClose: () => context.pop(),
                    );
                  }
                  if (snapshot.data == null) {
                    return _LoadFailureState(
                      message: l10n.studentNotFoundError,
                      onClose: () => context.pop(),
                    );
                  }
                  _initialize(snapshot.data!);
                  return _buildForm(l10n);
                },
              )
            : _buildForm(l10n),
      ),
    );
  }

  void _initialize(Student student) {
    _studentCardController.text = student.studentCard;
    _nameController.text = student.name ?? '';
    _universityController.text = student.university ?? '';
    _initialized = true;
  }

  void _reloadStudent() {
    setState(() {
      _studentFuture = ref.read(getStudentProvider)(widget.studentId!);
    });
  }

  Widget _buildForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  enabled: !_saving,
                  textInputAction: TextInputAction.next,
                  autofocus: !_isEditing,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.studentNameLabel,
                    hintText: l10n.studentNameHint,
                    helperText: l10n.optionalFieldLabel,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _studentCardController,
                  enabled: !_saving,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.studentCardLabel,
                    hintText: l10n.studentCardHint,
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.studentCardRequiredError
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _universityController,
                  enabled: !_saving,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _save(),
                  decoration: InputDecoration(
                    labelText: l10n.studentUniversityLabel,
                    hintText: l10n.studentUniversityHint,
                    prefixIcon: const Icon(Icons.account_balance_outlined),
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
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      final notifier = ref.read(studentsControllerProvider.notifier);
      if (_isEditing) {
        await notifier.updateStudent(
          studentId: widget.studentId!,
          studentCard: _studentCardController.text,
          name: _nameController.text,
          university: _universityController.text,
        );
      } else {
        await notifier.create(
          studentCard: _studentCardController.text,
          name: _nameController.text,
          university: _universityController.text,
        );
      }
      if (mounted) context.pop();
    } on DuplicateStudentCardException {
      _showError(l10n.studentCardDuplicateError);
    } on StudentNotFoundException {
      _showError(l10n.studentNotFoundError);
    } on StudentException {
      _showError(l10n.studentStorageError);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _LoadFailureState extends StatelessWidget {
  const _LoadFailureState({
    required this.message,
    required this.onClose,
    this.onRetry,
  });

  final String message;
  final VoidCallback onClose;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            if (onRetry != null) ...[
              FilledButton(onPressed: onRetry, child: Text(l10n.retryAction)),
              const SizedBox(height: 8),
            ],
            FilledButton.tonal(
              onPressed: onClose,
              child: Text(l10n.closeAction),
            ),
          ],
        ),
      ),
    );
  }
}
