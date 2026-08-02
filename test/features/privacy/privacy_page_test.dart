import 'package:cum_master/features/privacy/presentation/privacy_page.dart';
import 'package:cum_master/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('explains local storage and optional student identifiers', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: PrivacyPage(),
      ),
    );

    expect(find.text('Tus datos permanecen contigo'), findsOneWidget);
    expect(find.text('No necesitas usar tu carnet real'), findsOneWidget);
    expect(find.text('Sin nube ni envío de datos'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Leer la política completa'),
      300,
    );
    expect(find.text('Leer la política completa'), findsOneWidget);
  });
}
