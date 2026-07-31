import 'package:cum_master/app/app.dart';
import 'package:cum_master/core/localization/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the localized empty students state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appLocaleProvider.overrideWithValue(const Locale('es'))],
        child: const CumMasterApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aún no hay estudiantes'), findsOneWidget);
  });

  testWidgets('supports the English locale', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appLocaleProvider.overrideWithValue(const Locale('en'))],
        child: const CumMasterApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No students yet'), findsOneWidget);
  });
}
