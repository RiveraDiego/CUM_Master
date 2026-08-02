import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../application/tutorial_providers.dart';

class TutorialPage extends ConsumerStatefulWidget {
  const TutorialPage({super.key, required this.firstLaunch});
  final bool firstLaunch;

  @override
  ConsumerState<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends ConsumerState<TutorialPage> {
  final _controller = PageController();
  int _index = 0;
  bool _finishing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = _steps(l10n);
    final last = _index == steps.length - 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tutorialTitle),
        automaticallyImplyLeading: !widget.firstLaunch,
        actions: [
          TextButton(
            onPressed: _finishing ? null : _finish,
            child: Text(l10n.tutorialSkipAction),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (_index + 1) / steps.length),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: steps.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (_, index) => _TutorialStepView(
                  step: steps[index],
                  position: l10n.tutorialStepPosition(index + 1, steps.length),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  if (_index > 0)
                    TextButton.icon(
                      onPressed: _finishing
                          ? null
                          : () => _controller.previousPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            ),
                      icon: const Icon(Icons.arrow_back),
                      label: Text(l10n.tutorialPreviousAction),
                    )
                  else
                    const Spacer(),
                  if (_index > 0) const Spacer(),
                  FilledButton.icon(
                    onPressed: _finishing
                        ? null
                        : last
                        ? _finish
                        : () => _controller.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          ),
                    icon: Icon(last ? Icons.check : Icons.arrow_forward),
                    label: Text(
                      last
                          ? l10n.tutorialFinishAction
                          : l10n.tutorialNextAction,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    if (widget.firstLaunch) {
      await ref.read(tutorialActionsProvider).complete();
    } else if (mounted) {
      context.pop();
    }
  }

  List<_TutorialStep> _steps(AppLocalizations l10n) => [
    _TutorialStep(
      icon: Icons.waving_hand_outlined,
      title: l10n.tutorialWelcomeTitle,
      description: l10n.tutorialWelcomeDescription,
    ),
    _TutorialStep(
      icon: Icons.people_outline,
      title: l10n.tutorialStudentsTitle,
      description: l10n.tutorialStudentsDescription,
    ),
    _TutorialStep(
      icon: Icons.calendar_month_outlined,
      title: l10n.tutorialCyclesTitle,
      description: l10n.tutorialCyclesDescription,
    ),
    _TutorialStep(
      icon: Icons.fact_check_outlined,
      title: l10n.tutorialGradesTitle,
      description: l10n.tutorialGradesDescription,
    ),
    _TutorialStep(
      icon: Icons.dashboard_outlined,
      title: l10n.tutorialDashboardTitle,
      description: l10n.tutorialDashboardDescription,
    ),
    _TutorialStep(
      icon: Icons.backup_outlined,
      title: l10n.tutorialBackupTitle,
      description: l10n.tutorialBackupDescription,
    ),
  ];
}

class _TutorialStepView extends StatelessWidget {
  const _TutorialStepView({required this.step, required this.position});
  final _TutorialStep step;
  final String position;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(32),
    child: Column(
      children: [
        const SizedBox(height: 32),
        CircleAvatar(radius: 52, child: Icon(step.icon, size: 52)),
        const SizedBox(height: 32),
        Text(position, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(
          step.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Text(
          step.description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    ),
  );
}

class _TutorialStep {
  const _TutorialStep({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;
}
