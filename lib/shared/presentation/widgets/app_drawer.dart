import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../l10n/generated/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                l10n.appTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: Text(l10n.dashboardTitle),
              onTap: () => _navigate(context, AppRoute.dashboard),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: Text(l10n.studentsTitle),
              onTap: () => _navigate(context, AppRoute.students),
            ),
            ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: Text(l10n.backupTitle),
              onTap: () => _navigate(context, AppRoute.backup),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.settingsTitle),
              onTap: () => _navigate(context, AppRoute.settings),
            ),
            ListTile(
              leading: const Icon(Icons.school_outlined),
              title: Text(l10n.tutorialMenuAction),
              onTap: () => _openTutorial(context),
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
      router.pushNamed(routeName);
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
