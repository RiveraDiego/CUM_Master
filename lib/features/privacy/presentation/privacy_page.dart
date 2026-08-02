import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/presentation/widgets/app_drawer.dart';
import '../../../shared/presentation/widgets/app_navigation_app_bar.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  static final Uri policyUri = Uri.parse(
    'https://riveradiego.github.io/CUM_Master/',
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appNavigationAppBar(context, title: Text(l10n.privacyTitle)),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Icon(
              Icons.shield_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.privacySummaryTitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.privacySummaryDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _PrivacyItem(
              icon: Icons.phone_android_outlined,
              title: l10n.privacyLocalTitle,
              description: l10n.privacyLocalDescription,
            ),
            _PrivacyItem(
              icon: Icons.badge_outlined,
              title: l10n.privacyIdentifierTitle,
              description: l10n.privacyIdentifierDescription,
            ),
            _PrivacyItem(
              icon: Icons.cloud_off_outlined,
              title: l10n.privacyNoCloudTitle,
              description: l10n.privacyNoCloudDescription,
            ),
            _PrivacyItem(
              icon: Icons.share_outlined,
              title: l10n.privacyBackupTitle,
              description: l10n.privacyBackupDescription,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _openPolicy(context),
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.privacyFullPolicyAction),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPolicy(BuildContext context) async {
    final opened = await launchUrl(
      policyUri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.privacyOpenError)),
      );
    }
  }
}

class _PrivacyItem extends StatelessWidget {
  const _PrivacyItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(description),
      ),
    ),
  );
}
