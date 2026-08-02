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

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('Desarrollada por Diego Menendez'), findsOneWidget);
    expect(find.text('Estudiante de Ingeniería en Sistemas'), findsOneWidget);
    expect(
      find.text('en la Universidad Tecnológica de El Salvador'),
      findsOneWidget,
    );
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

  testWidgets('home from drawer resets history and root navigation', (
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
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.byIcon(Icons.menu), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Estudiantes'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Estudiantes'), findsWidgets);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Inicio'), findsWidgets);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });

  testWidgets('home discards an open edit screen from the stack', (
    WidgetTester tester,
  ) async {
    final repository = _SingleStudentRepository();
    appRouter.goNamed(
      AppRoute.studentEdit,
      pathParameters: {'studentId': repository.student.id},
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLocaleProvider.overrideWithValue(const Locale('es')),
          studentRepositoryProvider.overrideWithValue(repository),
        ],
        child: const CumMasterApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Editar estudiante'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();

    expect(find.text('Editar estudiante'), findsNothing);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(appRouter.canPop(), isFalse);
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

class _SingleStudentRepository implements StudentRepository {
  final Student student = Student(
    id: 'student-1',
    studentCard: 'TEST-1',
    name: 'Estudiante de prueba',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );

  @override
  Future<void> create(Student student) async {}

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Student>> getAll() async => [student];

  @override
  Future<Student?> getById(String id) async =>
      id == student.id ? student : null;

  @override
  Future<void> update(Student student) async {}
}
