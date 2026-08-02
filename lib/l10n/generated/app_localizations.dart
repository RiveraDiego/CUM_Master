import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'CUM Master'**
  String get appTitle;

  /// Heading shown before the first student is created
  ///
  /// In en, this message translates to:
  /// **'No students yet'**
  String get studentsEmptyTitle;

  /// Explains why the user should create a student profile
  ///
  /// In en, this message translates to:
  /// **'Create a student profile to organize academic information on this device.'**
  String get studentsEmptyDescription;

  /// Label for the action that creates a student
  ///
  /// In en, this message translates to:
  /// **'Add student'**
  String get studentsCreateAction;

  /// No description provided for @studentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get studentsTitle;

  /// No description provided for @studentCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Add student'**
  String get studentCreateTitle;

  /// No description provided for @studentEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit student'**
  String get studentEditTitle;

  /// No description provided for @studentCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Student ID'**
  String get studentCardLabel;

  /// No description provided for @studentCardHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the student ID number'**
  String get studentCardHint;

  /// No description provided for @studentCardRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Student ID is required.'**
  String get studentCardRequiredError;

  /// No description provided for @studentCardDuplicateError.
  ///
  /// In en, this message translates to:
  /// **'A student with this ID already exists.'**
  String get studentCardDuplicateError;

  /// No description provided for @studentUniversityLabel.
  ///
  /// In en, this message translates to:
  /// **'University (optional)'**
  String get studentUniversityLabel;

  /// No description provided for @studentUniversityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the university name'**
  String get studentUniversityHint;

  /// No description provided for @studentUniversityNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'University not specified'**
  String get studentUniversityNotSpecified;

  /// No description provided for @studentMoreActions.
  ///
  /// In en, this message translates to:
  /// **'More student actions'**
  String get studentMoreActions;

  /// No description provided for @studentDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete student?'**
  String get studentDeleteTitle;

  /// No description provided for @studentDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete student {studentCard}.'**
  String studentDeleteMessage(String studentCard);

  /// No description provided for @studentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Student deleted.'**
  String get studentDeleted;

  /// No description provided for @studentNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'This student no longer exists.'**
  String get studentNotFoundError;

  /// No description provided for @studentStorageError.
  ///
  /// In en, this message translates to:
  /// **'Student data could not be saved. Try again.'**
  String get studentStorageError;

  /// No description provided for @studentsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Students could not be loaded.'**
  String get studentsLoadError;

  /// No description provided for @saveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @closeAction.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeAction;

  /// No description provided for @retryAction.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retryAction;

  /// No description provided for @subjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjectsTitle;

  /// No description provided for @subjectsCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Add subject'**
  String get subjectsCreateAction;

  /// No description provided for @subjectsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'This student has no subjects yet. Add the first one to start organizing grades.'**
  String get subjectsEmptyDescription;

  /// No description provided for @subjectsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Subjects could not be loaded.'**
  String get subjectsLoadError;

  /// No description provided for @subjectCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Add subject'**
  String get subjectCreateTitle;

  /// No description provided for @subjectEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit subject'**
  String get subjectEditTitle;

  /// No description provided for @subjectNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject name'**
  String get subjectNameLabel;

  /// No description provided for @subjectNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'The subject name is required.'**
  String get subjectNameRequiredError;

  /// No description provided for @subjectCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code (optional)'**
  String get subjectCodeLabel;

  /// No description provided for @subjectCodeNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'No code'**
  String get subjectCodeNotSpecified;

  /// No description provided for @subjectDuplicateError.
  ///
  /// In en, this message translates to:
  /// **'A subject with this name already exists for the student.'**
  String get subjectDuplicateError;

  /// No description provided for @subjectMoreActions.
  ///
  /// In en, this message translates to:
  /// **'More subject actions'**
  String get subjectMoreActions;

  /// No description provided for @subjectDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete subject?'**
  String get subjectDeleteTitle;

  /// No description provided for @subjectDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'The subject {subjectName} will be permanently deleted.'**
  String subjectDeleteMessage(String subjectName);

  /// No description provided for @subjectDeleted.
  ///
  /// In en, this message translates to:
  /// **'Subject deleted.'**
  String get subjectDeleted;

  /// No description provided for @subjectNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'This subject no longer exists.'**
  String get subjectNotFoundError;

  /// No description provided for @subjectStorageError.
  ///
  /// In en, this message translates to:
  /// **'The subject data could not be saved. Try again.'**
  String get subjectStorageError;

  /// No description provided for @assessmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Assessments and grades'**
  String get assessmentsTitle;

  /// No description provided for @assessmentsCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Add assessment'**
  String get assessmentsCreateAction;

  /// No description provided for @assessmentsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'This subject has no assessments yet. Add the first grade.'**
  String get assessmentsEmptyDescription;

  /// No description provided for @assessmentsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Assessments could not be loaded.'**
  String get assessmentsLoadError;

  /// No description provided for @assessmentCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Add assessment'**
  String get assessmentCreateTitle;

  /// No description provided for @assessmentEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit assessment'**
  String get assessmentEditTitle;

  /// No description provided for @assessmentNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Assessment name'**
  String get assessmentNameLabel;

  /// No description provided for @assessmentNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'The name is required.'**
  String get assessmentNameRequiredError;

  /// No description provided for @assessmentScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score obtained'**
  String get assessmentScoreLabel;

  /// No description provided for @assessmentMaxScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum score'**
  String get assessmentMaxScoreLabel;

  /// No description provided for @assessmentWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight % (optional)'**
  String get assessmentWeightLabel;

  /// No description provided for @assessmentNumberError.
  ///
  /// In en, this message translates to:
  /// **'Enter a number equal to or greater than zero.'**
  String get assessmentNumberError;

  /// No description provided for @assessmentPositiveError.
  ///
  /// In en, this message translates to:
  /// **'Enter a number greater than zero.'**
  String get assessmentPositiveError;

  /// No description provided for @assessmentScoreRangeError.
  ///
  /// In en, this message translates to:
  /// **'The obtained score cannot exceed the maximum score.'**
  String get assessmentScoreRangeError;

  /// No description provided for @assessmentWeightError.
  ///
  /// In en, this message translates to:
  /// **'The weight must be between 0 and 100.'**
  String get assessmentWeightError;

  /// No description provided for @assessmentDuplicateError.
  ///
  /// In en, this message translates to:
  /// **'An assessment with this name already exists.'**
  String get assessmentDuplicateError;

  /// No description provided for @assessmentStorageError.
  ///
  /// In en, this message translates to:
  /// **'The assessment data could not be saved.'**
  String get assessmentStorageError;

  /// No description provided for @assessmentDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete assessment?'**
  String get assessmentDeleteTitle;

  /// No description provided for @assessmentDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'{assessmentName} will be permanently deleted.'**
  String assessmentDeleteMessage(String assessmentName);

  /// No description provided for @assessmentScore.
  ///
  /// In en, this message translates to:
  /// **'{score} out of {maxScore}'**
  String assessmentScore(num score, num maxScore);

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get dashboardTitle;

  /// No description provided for @activeCycleTitle.
  ///
  /// In en, this message translates to:
  /// **'Active term'**
  String get activeCycleTitle;

  /// No description provided for @activeCycleCurrentScope.
  ///
  /// In en, this message translates to:
  /// **'Summary of each student\'s subjects in their active academic term.'**
  String get activeCycleCurrentScope;

  /// No description provided for @dashboardLoadError.
  ///
  /// In en, this message translates to:
  /// **'The academic summary could not be loaded.'**
  String get dashboardLoadError;

  /// No description provided for @dashboardNoStudents.
  ///
  /// In en, this message translates to:
  /// **'Add a student to see their academic summary.'**
  String get dashboardNoStudents;

  /// No description provided for @dashboardNoSubjects.
  ///
  /// In en, this message translates to:
  /// **'This student has no subjects yet.'**
  String get dashboardNoSubjects;

  /// No description provided for @dashboardNoGrades.
  ///
  /// In en, this message translates to:
  /// **'No assessments recorded'**
  String get dashboardNoGrades;

  /// No description provided for @dashboardWeightedAverage.
  ///
  /// In en, this message translates to:
  /// **'Weighted average'**
  String get dashboardWeightedAverage;

  /// No description provided for @dashboardSimpleAverage.
  ///
  /// In en, this message translates to:
  /// **'Simple average'**
  String get dashboardSimpleAverage;

  /// No description provided for @dashboardManageSubjects.
  ///
  /// In en, this message translates to:
  /// **'Manage subjects'**
  String get dashboardManageSubjects;

  /// No description provided for @dashboardNoActiveCycle.
  ///
  /// In en, this message translates to:
  /// **'No active term'**
  String get dashboardNoActiveCycle;

  /// No description provided for @cyclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Academic terms'**
  String get cyclesTitle;

  /// No description provided for @cyclesCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Add term'**
  String get cyclesCreateAction;

  /// No description provided for @cyclesEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no terms yet. Add one to organize subjects.'**
  String get cyclesEmpty;

  /// No description provided for @cyclesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Academic terms could not be loaded.'**
  String get cyclesLoadError;

  /// No description provided for @cycleCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Add academic term'**
  String get cycleCreateTitle;

  /// No description provided for @cycleNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Term name'**
  String get cycleNameLabel;

  /// No description provided for @cycleActive.
  ///
  /// In en, this message translates to:
  /// **'Active term'**
  String get cycleActive;

  /// No description provided for @cycleDuplicateError.
  ///
  /// In en, this message translates to:
  /// **'A term with this name already exists.'**
  String get cycleDuplicateError;

  /// No description provided for @cycleInUseError.
  ///
  /// In en, this message translates to:
  /// **'A term containing subjects cannot be deleted.'**
  String get cycleInUseError;

  /// No description provided for @cycleStorageError.
  ///
  /// In en, this message translates to:
  /// **'The academic term data could not be saved.'**
  String get cycleStorageError;

  /// No description provided for @subjectCycleLabel.
  ///
  /// In en, this message translates to:
  /// **'Academic term'**
  String get subjectCycleLabel;

  /// No description provided for @subjectCycleRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Select the term this subject belongs to.'**
  String get subjectCycleRequiredError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
