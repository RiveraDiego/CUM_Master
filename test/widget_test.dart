import 'package:cum_master/app/app.dart';
import 'package:cum_master/core/localization/locale_provider.dart';
import 'package:cum_master/core/router/app_router.dart';
import 'package:cum_master/features/students/application/student_providers.dart';
import 'package:cum_master/features/students/domain/entities/student.dart';
import 'package:cum_master/features/students/domain/repositories/student_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the localized empty students state', (
    WidgetTester tester,
  ) async {
    appRouter.go('/students');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLocaleProvider.overrideWithValue(const Locale('es')),
          studentRepositoryProvider.overrideWithValue(_EmptyRepository()),
        ],
        child: const CumMasterApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aún no hay estudiantes'), findsOneWidget);
  });

  testWidgets('supports the English locale', (WidgetTester tester) async {
    appRouter.go('/students');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLocaleProvider.overrideWithValue(const Locale('en')),
          studentRepositoryProvider.overrideWithValue(_EmptyRepository()),
        ],
        child: const CumMasterApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No students yet'), findsOneWidget);
  });

  testWidgets('drawer keeps history and back returns to the previous screen', (
    WidgetTester tester,
  ) async {
    appRouter.go('/students');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLocaleProvider.overrideWithValue(const Locale('es')),
          studentRepositoryProvider.overrideWithValue(_EmptyRepository()),
        ],
        child: const CumMasterApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Estudiantes'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Estudiantes'), findsWidgets);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Inicio'), findsWidgets);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Estudiantes'), findsWidgets);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });
}

class _EmptyRepository implements StudentRepository {
  @override
  Future<void> create(Student student) async {}

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Student>> getAll() async => const [];

  @override
  Future<Student?> getById(String id) async => null;

  @override
  Future<void> update(Student student) async {}
}
