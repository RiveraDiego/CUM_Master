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

  @override
  String get studentsTitle => 'Students';

  @override
  String get studentCreateTitle => 'Add student';

  @override
  String get studentEditTitle => 'Edit student';

  @override
  String get studentCardLabel => 'Student ID';

  @override
  String get studentCardHint => 'Enter the student ID number';

  @override
  String get studentCardRequiredError => 'Student ID is required.';

  @override
  String get studentCardDuplicateError =>
      'A student with this ID already exists.';

  @override
  String get studentUniversityLabel => 'University (optional)';

  @override
  String get studentUniversityHint => 'Enter the university name';

  @override
  String get studentUniversityNotSpecified => 'University not specified';

  @override
  String get studentMoreActions => 'More student actions';

  @override
  String get studentDeleteTitle => 'Delete student?';

  @override
  String studentDeleteMessage(String studentCard) {
    return 'This will permanently delete student $studentCard.';
  }

  @override
  String get studentDeleted => 'Student deleted.';

  @override
  String get studentNotFoundError => 'This student no longer exists.';

  @override
  String get studentStorageError =>
      'Student data could not be saved. Try again.';

  @override
  String get studentsLoadError => 'Students could not be loaded.';

  @override
  String get saveAction => 'Save';

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get closeAction => 'Close';

  @override
  String get retryAction => 'Try again';
}
