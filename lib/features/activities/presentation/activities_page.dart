import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/activity_providers.dart';
import '../domain/activity.dart';
import '../../settings/application/academic_settings_providers.dart';

class ActivitiesPage extends ConsumerWidget {
  const ActivitiesPage({super.key, required this.assessmentId});
  final String assessmentId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final values = ref.watch(activitiesProvider(assessmentId));
    final terminology = ref.watch(academicSettingsProvider).value;
    final title = terminology?.activityPlural?.trim();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title == null || title.isEmpty ? l10n.activitiesTitle : title,
        ),
      ),
      body: values.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.activitiesLoadError)),
        data: (items) {
          final total = items.fold<double>(0, (sum, item) => sum + item.weight);
          return Column(
            children: [
              ListTile(
                title: Text(l10n.activityWeightTotal(total)),
                subtitle: Text(
                  (total - 100).abs() < .001
                      ? l10n.activityCalculationReady
                      : l10n.activityCalculationIncomplete,
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(child: Text(l10n.activitiesEmpty))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (_, i) => ListTile(
                          title: Text(items[i].name),
                          subtitle: Text(
                            '${items[i].score}/${items[i].maxScore} · ${items[i].weight}%',
                          ),
                          onTap: () => _edit(context, ref, items[i]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => ref
                                .read(activityActionsProvider)
                                .delete(assessmentId, items[i].id),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.activitiesCreateAction),
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, [
    Activity? current,
  ]) async {
    final l10n = AppLocalizations.of(context)!;
    final name = TextEditingController(text: current?.name);
    final score = TextEditingController(text: current?.score.toString());
    final max = TextEditingController(text: current?.maxScore.toString());
    final weight = TextEditingController(text: current?.weight.toString());
    final key = GlobalKey<FormState>();
    final save = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(
          current == null ? l10n.activityCreateTitle : l10n.activityEditTitle,
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
                    labelText: l10n.activityNameLabel,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? l10n.activityRequiredError
                      : null,
                ),
                TextFormField(
                  controller: score,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.assessmentScoreLabel,
                  ),
                  validator: (v) => _valid(v, allowZero: true)
                      ? null
                      : l10n.assessmentNumberError,
                ),
                TextFormField(
                  controller: max,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.assessmentMaxScoreLabel,
                  ),
                  validator: (v) =>
                      _valid(v) ? null : l10n.assessmentPositiveError,
                ),
                TextFormField(
                  controller: weight,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.assessmentWeightLabel,
                  ),
                  validator: (v) {
                    final n = double.tryParse(v ?? '');
                    return n != null && n > 0 && n <= 100
                        ? null
                        : l10n.assessmentWeightError;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () {
              if (key.currentState!.validate() &&
                  double.parse(score.text) <= double.parse(max.text)) {
                Navigator.pop(c, true);
              }
            },
            child: Text(l10n.saveAction),
          ),
        ],
      ),
    );
    if (save == true) {
      await ref
          .read(activityActionsProvider)
          .save(
            assessmentId: assessmentId,
            id: current?.id,
            name: name.text,
            score: double.parse(score.text),
            maxScore: double.parse(max.text),
            weight: double.parse(weight.text),
          );
    }
    name.dispose();
    score.dispose();
    max.dispose();
    weight.dispose();
  }

  static bool _valid(String? value, {bool allowZero = false}) {
    final n = double.tryParse(value ?? '');
    return n != null && (allowZero ? n >= 0 : n > 0);
  }
}
