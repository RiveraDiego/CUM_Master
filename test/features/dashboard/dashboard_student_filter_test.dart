import 'package:cum_master/features/dashboard/domain/entities/academic_summary.dart';
import 'package:cum_master/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:cum_master/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:cum_master/features/settings/application/academic_settings_providers.dart';
import 'package:cum_master/features/settings/domain/academic_settings.dart';
import 'package:cum_master/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('shows all students by default and filters by one', (
    tester,
  ) async {
    final summaries = [
      _summary('1', 'Diego', 'DR-001'),
      _summary('2', 'Ana', 'AM-002'),
    ];
    final router = GoRouter(
      routes: [GoRoute(path: '/', builder: (_, _) => const DashboardPage())],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardControllerProvider.overrideWith(
            () => _FakeDashboardController(summaries),
          ),
          academicSettingsProvider.overrideWith(
            (ref) async => AcademicSettings.defaults,
          ),
        ],
        child: MaterialApp.router(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Completa la configuración inicial'), findsWidgets);
    expect(find.text('Diego'), findsOneWidget);
    await tester.tap(find.text('Todos los estudiantes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ana').last);
    await tester.pumpAndSettle();

    expect(find.text('Ana'), findsNWidgets(2));
    expect(find.text('AM-002'), findsOneWidget);
    expect(find.text('Diego'), findsNothing);
  });
}

StudentAcademicSummary _summary(String id, String name, String card) =>
    StudentAcademicSummary(
      id: id,
      studentCard: card,
      studentName: name,
      university: null,
      activeCycleName: null,
      currentCycleId: null,
      selectedCycleId: null,
      cycles: const [],
      subjects: const [],
      generalCum: null,
    );

class _FakeDashboardController extends DashboardController {
  _FakeDashboardController(this.summaries);
  final List<StudentAcademicSummary> summaries;

  @override
  Future<List<StudentAcademicSummary>> build() async => summaries;
}
