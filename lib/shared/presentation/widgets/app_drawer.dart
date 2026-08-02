import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../l10n/generated/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentRoute = GoRouterState.of(context).name;
    final colors = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          child: const Icon(Icons.school_rounded, size: 30),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.appTitle,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.drawerTagline,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.dashboard_outlined),
                    title: Text(l10n.dashboardTitle),
                    selected: currentRoute == AppRoute.dashboard,
                    onTap: () => _navigate(context, AppRoute.dashboard),
                  ),
                  const SizedBox(height: 4),
                  ListTile(
                    leading: const Icon(Icons.people_outline),
                    title: Text(l10n.studentsTitle),
                    selected: currentRoute == AppRoute.students,
                    onTap: () => _navigate(context, AppRoute.students),
                  ),
                  const SizedBox(height: 4),
                  ListTile(
                    leading: const Icon(Icons.insights_outlined),
                    title: Text(l10n.statisticsTitle),
                    selected: currentRoute == AppRoute.statistics,
                    onTap: () => _navigate(context, AppRoute.statistics),
                  ),
                  const SizedBox(height: 4),
                  ListTile(
                    leading: const Icon(Icons.backup_outlined),
                    title: Text(l10n.backupTitle),
                    selected: currentRoute == AppRoute.backup,
                    onTap: () => _navigate(context, AppRoute.backup),
                  ),
                  const SizedBox(height: 4),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: Text(l10n.settingsTitle),
                    selected: currentRoute == AppRoute.settings,
                    onTap: () => _navigate(context, AppRoute.settings),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.school_outlined),
                    title: Text(l10n.tutorialMenuAction),
                    onTap: () => _openTutorial(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: _DeveloperSignature(colors: colors),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String routeName) {
    final router = GoRouter.of(context);
    final currentRoute = GoRouterState.of(context).name;
    Navigator.of(context).pop();
    if (currentRoute == routeName) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (routeName == AppRoute.dashboard) {
        router.goNamed(routeName);
      } else {
        router.pushNamed(routeName);
      }
    });
  }

  void _openTutorial(BuildContext context) {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.pushNamed(AppRoute.tutorial);
    });
  }
}

class _DeveloperSignature extends StatelessWidget {
  const _DeveloperSignature({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: colors.outlineVariant),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Desarrollada por Diego Menendez',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 3),
        Text(
          'Estudiante de Ingeniería en Sistemas',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          'en la Universidad Tecnológica de El Salvador',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}
