import 'package:cum_master/features/cycles/application/cycle_providers.dart';
import 'package:cum_master/features/cycles/domain/entities/academic_cycle.dart';
import 'package:cum_master/features/cycles/domain/repositories/cycle_repository.dart';
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

    final repository = _CycleRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cyclesProvider('student-1').overrideWith((ref) async => [cycle]),
          cycleRepositoryProvider.overrideWithValue(repository),
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

    await tester.enterText(find.byType(TextField), 'Ciclo IV');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(repository.renamedCycleId, 'cycle-1');
    expect(repository.renamedValue, 'Ciclo IV');
    expect(tester.takeException(), isNull);
  });
}

class _CycleRepository implements CycleRepository {
  String? renamedCycleId;
  String? renamedValue;

  @override
  Future<void> rename(String cycleId, String name) async {
    renamedCycleId = cycleId;
    renamedValue = name;
  }

  @override
  Future<void> clearActive(String studentId) async {}

  @override
  Future<void> create(AcademicCycle cycle) async {}

  @override
  Future<void> delete(String cycleId) async {}

  @override
  Future<List<AcademicCycle>> getAll(String studentId) async => const [];

  @override
  Future<void> setActive(String studentId, String cycleId) async {}
}
