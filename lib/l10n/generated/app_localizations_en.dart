// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CUM Master';

  @override
  String get studentsEmptyTitle => 'No students yet';

  @override
  String get studentsEmptyDescription =>
      'Create a student profile to organize academic information on this device.';

  @override
  String get studentsCreateAction => 'Add student';
}
