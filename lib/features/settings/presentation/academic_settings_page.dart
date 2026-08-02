import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_mode_provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/academic_settings_providers.dart';
import '../domain/academic_settings.dart';

class AcademicSettingsPage extends ConsumerStatefulWidget {
  const AcademicSettingsPage({super.key});

  @override
  ConsumerState<AcademicSettingsPage> createState() =>
      _AcademicSettingsPageState();
}

class _AcademicSettingsPageState extends ConsumerState<AcademicSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _creditUnits = TextEditingController();
  final _terms = List.generate(8, (_) => TextEditingController());
  bool _initialized = false;
  bool _saving = false;
  int _decimalPlaces = 1;
  GradeRoundingMode _roundingMode = GradeRoundingMode.ceiling;

  @override
  void dispose() {
    _creditUnits.dispose();
    for (final controller in _terms) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(academicSettingsProvider);
    final themeMode = ref.watch(appThemeModeProvider).value ?? ThemeMode.system;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: settings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.settingsLoadError)),
        data: (value) {
          _initialize(value);
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              children: [
                Text(
                  l10n.settingsAppearanceTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ThemeMode>(
                  key: ValueKey(themeMode),
                  initialValue: themeMode,
                  decoration: InputDecoration(
                    labelText: l10n.settingsThemeLabel,
                    helperText: l10n.settingsThemeHelp,
                    prefixIcon: const Icon(Icons.brightness_6_outlined),
                  ),
                  items: ThemeMode.values
                      .map(
                        (mode) => DropdownMenuItem(
                          value: mode,
                          child: Text(_themeModeName(l10n, mode)),
                        ),
                      )
                      .toList(),
                  onChanged: _saving
                      ? null
                      : (mode) {
                          if (mode != null) {
                            ref.read(appThemeModeActionsProvider).save(mode);
                          }
                        },
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.settingsCalculationTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _creditUnits,
                  enabled: !_saving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.settingsDefaultUvLabel,
                    helperText: l10n.settingsDefaultUvHelp,
                    prefixIcon: const Icon(Icons.school_outlined),
                  ),
                  validator: (text) => (double.tryParse(text ?? '') ?? 0) > 0
                      ? null
                      : l10n.subjectCreditUnitsError,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: _decimalPlaces,
                  decoration: InputDecoration(
                    labelText: l10n.settingsDecimalsLabel,
                    prefixIcon: const Icon(Icons.pin_outlined),
                  ),
                  items: [
                    for (var value = 0; value <= 3; value++)
                      DropdownMenuItem(
                        value: value,
                        child: Text(l10n.settingsDecimalsValue(value)),
                      ),
                  ],
                  onChanged: _saving
                      ? null
                      : (value) => setState(() => _decimalPlaces = value!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<GradeRoundingMode>(
                  initialValue: _roundingMode,
                  decoration: InputDecoration(
                    labelText: l10n.settingsRoundingLabel,
                    prefixIcon: const Icon(Icons.calculate_outlined),
                  ),
                  items: GradeRoundingMode.values
                      .map(
                        (mode) => DropdownMenuItem(
                          value: mode,
                          child: Text(_roundingName(l10n, mode)),
                        ),
                      )
                      .toList(),
                  onChanged: _saving
                      ? null
                      : (value) => setState(() => _roundingMode = value!),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _saving ? null : _confirmApplyUv,
                  icon: const Icon(Icons.copy_all_outlined),
                  label: Text(l10n.settingsApplyUvAction),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.settingsTerminologyTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(l10n.settingsTerminologyHelp),
                const SizedBox(height: 16),
                _termPair(l10n.settingsCycleTerm, 0, 1),
                _termPair(l10n.settingsSubjectTerm, 2, 3),
                _termPair(l10n.settingsAssessmentTerm, 4, 5),
                _termPair(l10n.settingsActivityTerm, 6, 7),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(l10n.saveAction),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _termPair(String label, int singular, int plural) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _terms[singular],
              enabled: !_saving,
              decoration: InputDecoration(
                labelText: '$label · ${l10n.settingsSingularLabel}',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: _terms[plural],
              enabled: !_saving,
              decoration: InputDecoration(
                labelText: '$label · ${l10n.settingsPluralLabel}',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initialize(AcademicSettings value) {
    if (_initialized) return;
    _creditUnits.text = value.defaultCreditUnits.toString();
    _decimalPlaces = value.decimalPlaces;
    _roundingMode = value.roundingMode;
    final values = [
      value.cycleSingular,
      value.cyclePlural,
      value.subjectSingular,
      value.subjectPlural,
      value.assessmentSingular,
      value.assessmentPlural,
      value.activitySingular,
      value.activityPlural,
    ];
    for (var index = 0; index < _terms.length; index++) {
      _terms[index].text = values[index] ?? '';
    }
    _initialized = true;
  }

  AcademicSettings _value() => AcademicSettings(
    defaultCreditUnits: double.parse(_creditUnits.text),
    decimalPlaces: _decimalPlaces,
    roundingMode: _roundingMode,
    cycleSingular: _terms[0].text,
    cyclePlural: _terms[1].text,
    subjectSingular: _terms[2].text,
    subjectPlural: _terms[3].text,
    assessmentSingular: _terms[4].text,
    assessmentPlural: _terms[5].text,
    activitySingular: _terms[6].text,
    activityPlural: _terms[7].text,
  );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    try {
      await ref.read(academicSettingsActionsProvider).save(_value());
      if (mounted) _show(l10n.settingsSaved);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmApplyUv() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsApplyUvTitle),
        content: Text(l10n.settingsApplyUvMessage(_creditUnits.text)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.settingsApplyAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await Future<void>.delayed(kThemeAnimationDuration);
    await ref
        .read(academicSettingsActionsProvider)
        .applyCreditUnits(double.parse(_creditUnits.text));
    if (mounted) _show(l10n.settingsUvApplied);
  }

  String _roundingName(AppLocalizations l10n, GradeRoundingMode mode) =>
      switch (mode) {
        GradeRoundingMode.ceiling => l10n.settingsRoundingCeiling,
        GradeRoundingMode.nearest => l10n.settingsRoundingNearest,
        GradeRoundingMode.floor => l10n.settingsRoundingFloor,
      };

  String _themeModeName(AppLocalizations l10n, ThemeMode mode) =>
      switch (mode) {
        ThemeMode.system => l10n.settingsThemeSystem,
        ThemeMode.light => l10n.settingsThemeLight,
        ThemeMode.dark => l10n.settingsThemeDark,
      };

  void _show(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
}
