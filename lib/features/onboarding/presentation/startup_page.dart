import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard/presentation/pages/dashboard_page.dart';
import '../application/tutorial_providers.dart';
import 'tutorial_page.dart';

class StartupPage extends ConsumerWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref.watch(tutorialCompletedProvider);
    return completed.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => const DashboardPage(),
      data: (value) =>
          value ? const DashboardPage() : const TutorialPage(firstLaunch: true),
    );
  }
}
