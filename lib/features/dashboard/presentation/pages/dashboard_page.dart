import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/presentation/widgets/app_drawer.dart';
import '../../domain/entities/academic_summary.dart';
import '../controllers/dashboard_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final summaries = ref.watch(dashboardControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardTitle)),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: summaries.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _DashboardMessage(
            title: l10n.dashboardLoadError,
            action: l10n.retryAction,
            onTap: () =>
                ref.read(dashboardControllerProvider.notifier).refresh(),
          ),
          data: (items) => items.isEmpty
              ? _DashboardMessage(
                  title: l10n.dashboardNoStudents,
                  action: l10n.studentsCreateAction,
                  onTap: () => context.goNamed(AppRoute.students),
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      ref.read(dashboardControllerProvider.notifier).refresh(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    children: [
                      Text(
                        l10n.activeCycleTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.activeCycleCurrentScope,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      for (final item in items) ...[
                        _StudentSummaryCard(summary: item),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _StudentSummaryCard extends StatelessWidget {
  const _StudentSummaryCard({required this.summary});
  final StudentAcademicSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person_outline)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    summary.studentCard,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _AverageBadge(value: summary.overallAverage),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              summary.activeCycleName ?? l10n.dashboardNoActiveCycle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (summary.subjects.isEmpty)
              Text(l10n.dashboardNoSubjects)
            else
              for (final subject in summary.subjects)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(subject.name),
                  subtitle: Text(
                    subject.assessmentCount == 0
                        ? l10n.dashboardNoGrades
                        : subject.isWeighted
                        ? l10n.dashboardWeightedAverage
                        : l10n.dashboardSimpleAverage,
                  ),
                  trailing: _AverageBadge(value: subject.average),
                  onTap: () => context.pushNamed(
                    AppRoute.assessments,
                    pathParameters: {
                      'studentId': summary.id,
                      'subjectId': subject.id,
                    },
                  ),
                ),
            TextButton.icon(
              onPressed: () => context.pushNamed(
                AppRoute.subjects,
                pathParameters: {'studentId': summary.id},
              ),
              icon: const Icon(Icons.menu_book_outlined),
              label: Text(l10n.dashboardManageSubjects),
            ),
          ],
        ),
      ),
    );
  }
}

class _AverageBadge extends StatelessWidget {
  const _AverageBadge({required this.value});
  final double? value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(value == null ? '—' : '${value!.toStringAsFixed(1)}%'),
  );
}

class _DashboardMessage extends StatelessWidget {
  const _DashboardMessage({
    required this.title,
    required this.action,
    required this.onTap,
  });
  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.dashboard_outlined, size: 52),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton(onPressed: onTap, child: Text(action)),
        ],
      ),
    ),
  );
}
