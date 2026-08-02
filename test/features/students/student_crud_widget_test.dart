import 'package:cum_master/app/app.dart';
import 'package:cum_master/core/localization/locale_provider.dart';
import 'package:cum_master/core/router/app_router.dart';
import 'package:cum_master/features/students/application/student_providers.dart';
import 'package:cum_master/features/students/domain/entities/student.dart';
import 'package:cum_master/features/students/domain/errors/student_exceptions.dart';
import 'package:cum_master/features/students/domain/repositories/student_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeStudentRepository repository;

  setUp(() {
    repository = FakeStudentRepository();
    appRouter.go('/students');
  });

  Future<void> pumpApp(WidgetTester tester) async {
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
  }

  testWidgets('validates and creates a student', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Agregar estudiante').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pump();
    expect(find.text('El carnet estudiantil es obligatorio.'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nombre del estudiante'),
      '  Diego  ',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Carnet estudiantil'),
      '  AB-123  ',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Universidad (opcional)'),
      '  Universidad Nacional  ',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Diego'), findsOneWidget);
    expect(find.text('AB-123 · Universidad Nacional'), findsOneWidget);
    expect(repository.students, hasLength(1));
    expect(repository.students.single.name, 'Diego');
  });

  testWidgets('shows a specific duplicate-card error', (tester) async {
    repository.students.add(_student(id: 'one', card: 'AB-123'));
    await pumpApp(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Carnet estudiantil'),
      'ab-123',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(
      find.text('Ya existe un estudiante con este carnet.'),
      findsOneWidget,
    );
  });

  testWidgets('edits an existing student', (tester) async {
    repository.students.add(_student(id: 'one', card: 'OLD-1'));
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Más acciones del estudiante'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Carnet estudiantil'),
      'NEW-2',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('NEW-2'), findsOneWidget);
    expect(repository.students.single.studentCard, 'NEW-2');
  });

  testWidgets('deletes only after confirmation', (tester) async {
    repository.students.add(_student(id: 'one', card: 'AB-123'));
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Más acciones del estudiante'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar').last);
    await tester.pumpAndSettle();
    expect(find.text('¿Eliminar estudiante?'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(repository.students, hasLength(1));

    await tester.tap(find.byTooltip('Más acciones del estudiante'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar').last);
    await tester.pumpAndSettle();

    expect(repository.students, isEmpty);
    expect(find.text('A\u00fan no hay estudiantes'), findsOneWidget);
  });
}

Student _student({required String id, required String card}) {
  final now = DateTime.utc(2026);
  return Student(id: id, studentCard: card, createdAt: now, updatedAt: now);
}

class FakeStudentRepository implements StudentRepository {
  final List<Student> students = [];

  @override
  Future<void> create(Student student) async {
    if (_hasCard(student.studentCard)) {
      throw DuplicateStudentCardException(student.studentCard);
    }
    students.add(student);
  }

  @override
  Future<void> delete(String id) async {
    final removed = students.where((student) => student.id == id).toList();
    if (removed.isEmpty) throw StudentNotFoundException(id);
    students.removeWhere((student) => student.id == id);
  }

  @override
  Future<List<Student>> getAll() async => List.unmodifiable(students);

  @override
  Future<Student?> getById(String id) async {
    for (final student in students) {
      if (student.id == id) return student;
    }
    return null;
  }

  @override
  Future<void> update(Student student) async {
    final index = students.indexWhere((item) => item.id == student.id);
    if (index < 0) throw StudentNotFoundException(student.id);
    if (_hasCard(student.studentCard, exceptId: student.id)) {
      throw DuplicateStudentCardException(student.studentCard);
    }
    students[index] = student;
  }

  bool _hasCard(String card, {String? exceptId}) {
    final normalized = card.trim().toLowerCase();
    return students.any(
      (student) =>
          student.id != exceptId &&
          student.studentCard.toLowerCase() == normalized,
    );
  }
}
