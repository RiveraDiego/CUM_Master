import 'package:cum_master/features/cycles/application/cycle_providers.dart';
import 'package:cum_master/features/cycles/domain/entities/academic_cycle.dart';
import 'package:cum_master/features/cycles/presentation/cycles_page.dart';
import 'package:cum_master/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens rename dialog after the cycle menu is dismissed', (
    tester,
  ) async {
    final now = DateTime.utc(2026);
    final cycle = AcademicCycle(
      id: 'cycle-1',
      studentId: 'student-1',
      name: 'Ciclo III',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cyclesProvider('student-1').overrideWith((ref) async => [cycle]),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CyclesPage(studentId: 'student-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Renombrar'));
    await tester.pumpAndSettle();

    expect(find.text('Renombrar ciclo'), findsOneWidget);
    expect(find.text('Ciclo III'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
