import 'package:cum_master/features/onboarding/presentation/tutorial_page.dart';
import 'package:cum_master/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('navigates through and skips the reusable tutorial', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, _) => const Scaffold(body: Text('Inicio de prueba')),
        ),
        GoRoute(
          path: '/tutorial',
          builder: (_, _) => const TutorialPage(firstLaunch: false),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    router.push('/tutorial');
    await tester.pumpAndSettle();

    expect(find.text('Cómo usar CUM Master'), findsOneWidget);
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 2 de 6'), findsOneWidget);

    await tester.tap(find.text('Saltar'));
    await tester.pumpAndSettle();
    expect(find.text('Inicio de prueba'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
