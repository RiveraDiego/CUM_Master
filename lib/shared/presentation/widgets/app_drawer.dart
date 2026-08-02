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
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String routeName) {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.goNamed(routeName);
    });
  }
}
