import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/presentation/widgets/app_drawer.dart';
import '../../../shared/presentation/widgets/app_navigation_app_bar.dart';
import '../../settings/application/academic_settings_providers.dart';
import '../../settings/domain/academic_settings.dart';
import '../application/statistics_provider.dart';
import '../domain/academic_history.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  String? _selectedStudentId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final history = ref.watch(academicHistoryProvider);
    final settings =
        ref.watch(academicSettingsProvider).value ?? AcademicSettings.defaults;
    return Scaffold(
      appBar: appNavigationAppBar(context, title: Text(l10n.statisticsTitle)),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: history.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _Message(
            icon: Icons.error_outline,
            text: l10n.statisticsLoadError,
            action: l10n.retryAction,
            onPressed: () => ref.invalidate(academicHistoryProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return _Message(
                icon: Icons.query_stats_outlined,
                text: l10n.statisticsNoStudents,
              );
            }
            final selectedId =
                items.any((item) => item.id == _selectedStudentId)
                ? _selectedStudentId
                : null;
            final visible = selectedId == null
                ? items
                : items.where((item) => item.id == selectedId).toList();
            return RefreshIndicator(
              onRefresh: () async =>
                  ref.refresh(academicHistoryProvider.future),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  DropdownButtonFormField<String?>(
                    key: ValueKey(selectedId),
                    initialValue: selectedId,
                    decoration: InputDecoration(
                      labelText: l10n.dashboardStudentFilterLabel,
                      prefixIcon: const Icon(Icons.person_search_outlined),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l10n.dashboardAllStudents),
                      ),
                      for (final student in items)
                        DropdownMenuItem<String?>(
                          value: student.id,
                          child: Text(
                            student.displayName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (studentId) =>
                        setState(() => _selectedStudentId = studentId),
                  ),
                  const SizedBox(height: 16),
                  for (final student in visible) ...[
                    _StudentHistoryCard(student: student, settings: settings),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StudentHistoryCard extends StatelessWidget {
  const _StudentHistoryCard({required this.student, required this.settings});
  final StudentAcademicHistory student;
  final AcademicSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              student.displayName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (student.name != null)
              Text(
                student.studentCard,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 18),
            if (student.cycles.isEmpty)
              Text(l10n.statisticsNoCycles)
            else ...[
              Text(
                l10n.statisticsEvolutionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Container(
                height: 170,
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: CustomPaint(
                  painter: _TrendPainter(
                    values: student.cycles
                        .map((cycle) => cycle.average)
                        .toList(),
                    color: colors.primary,
                    gridColor: colors.outlineVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              for (final cycle in student.cycles)
                _CycleRow(cycle: cycle, settings: settings),
            ],
          ],
        ),
      ),
    );
  }
}

class _CycleRow extends StatelessWidget {
  const _CycleRow({required this.cycle, required this.settings});
  final CycleHistoryPoint cycle;
  final AcademicSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final grade = cycle.average == null ? '—' : settings.format(cycle.average!);
    final cum = cycle.cumulativeCum == null
        ? '—'
        : settings.format(cycle.cumulativeCum!);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(child: Text(cycle.average == null ? '—' : grade)),
      title: Text(
        cycle.isCurrent
            ? '${cycle.name} · ${l10n.dashboardCurrentCycleShort}'
            : cycle.name,
      ),
      subtitle: Text(
        l10n.statisticsCycleSubjects(
          cycle.gradedSubjectCount,
          cycle.subjectCount,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(l10n.statisticsAverageValue(grade)),
          Text(l10n.statisticsCumValue(cum)),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter({
    required this.values,
    required this.color,
    required this.gridColor,
  });
  final List<double?> values;
  final Color color;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = gridColor;
    for (final fraction in [0.0, .5, 1.0]) {
      final y = size.height * fraction;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final available = <({int index, double value})>[];
    for (var index = 0; index < values.length; index++) {
      final value = values[index];
      if (value != null) available.add((index: index, value: value));
    }
    if (available.isEmpty) return;
    final denominator = math.max(values.length - 1, 1);
    Offset point(({int index, double value}) item) => Offset(
      size.width * item.index / denominator,
      size.height * (1 - item.value.clamp(0, 10) / 10),
    );
    final path = Path()
      ..moveTo(point(available.first).dx, point(available.first).dy);
    for (final item in available.skip(1)) {
      final current = point(item);
      path.lineTo(current.dx, current.dy);
    }
    final line = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, line);
    final dot = Paint()..color = color;
    for (final item in available) {
      canvas.drawCircle(point(item), 6, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.text,
    this.action,
    this.onPressed,
  });
  final IconData icon;
  final String text;
  final String? action;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 52),
          const SizedBox(height: 16),
          Text(text, textAlign: TextAlign.center),
          if (action != null && onPressed != null) ...[
            const SizedBox(height: 16),
            FilledButton(onPressed: onPressed, child: Text(action!)),
          ],
        ],
      ),
    ),
  );
}
