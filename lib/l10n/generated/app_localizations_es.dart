// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'CUM Master';

  @override
  String get studentsEmptyTitle => 'Aún no hay estudiantes';

  @override
  String get studentsEmptyDescription =>
      'Crea un perfil de estudiante para organizar la información académica en este dispositivo.';

  @override
  String get studentsCreateAction => 'Agregar estudiante';
}
