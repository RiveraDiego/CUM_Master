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

  /// No description provided for @drawerTagline.
  ///
  /// In en, this message translates to:
  /// **'Your academic progress'**
  String get drawerTagline;

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

  /// No description provided for @studentNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Student name'**
  String get studentNameLabel;

  /// No description provided for @studentNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Diego, Ana, or My account'**
  String get studentNameHint;

  /// No description provided for @optionalFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optionalFieldLabel;

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

  /// No description provided for @dashboardStudentFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter by student'**
  String get dashboardStudentFilterLabel;

  /// No description provided for @dashboardAllStudents.
  ///
  /// In en, this message translates to:
  /// **'All students'**
  String get dashboardAllStudents;

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

  /// No description provided for @subjectCreditUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Credit units'**
  String get subjectCreditUnitsLabel;

  /// No description provided for @subjectCreditUnitsError.
  ///
  /// In en, this message translates to:
  /// **'Enter credit units greater than zero.'**
  String get subjectCreditUnitsError;

  /// No description provided for @subjectHistoricalGradeLabel.
  ///
  /// In en, this message translates to:
  /// **'Historical final grade (optional)'**
  String get subjectHistoricalGradeLabel;

  /// No description provided for @subjectHistoricalGradeHelp.
  ///
  /// In en, this message translates to:
  /// **'When entered, it takes priority over assessment calculations.'**
  String get subjectHistoricalGradeHelp;

  /// No description provided for @subjectHistoricalGradeError.
  ///
  /// In en, this message translates to:
  /// **'The grade must be between 0 and 10.'**
  String get subjectHistoricalGradeError;

  /// No description provided for @activitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activitiesTitle;

  /// No description provided for @activitiesCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Add activity'**
  String get activitiesCreateAction;

  /// No description provided for @activitiesEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no activities. The manual assessment grade will be used.'**
  String get activitiesEmpty;

  /// No description provided for @activitiesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Activities could not be loaded.'**
  String get activitiesLoadError;

  /// No description provided for @activityCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Add activity'**
  String get activityCreateTitle;

  /// No description provided for @activityEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit activity'**
  String get activityEditTitle;

  /// No description provided for @activityNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity name'**
  String get activityNameLabel;

  /// No description provided for @activityRequiredError.
  ///
  /// In en, this message translates to:
  /// **'The name is required.'**
  String get activityRequiredError;

  /// No description provided for @activityWeightTotal.
  ///
  /// In en, this message translates to:
  /// **'Total weight: {weight}%'**
  String activityWeightTotal(num weight);

  /// No description provided for @activityCalculationReady.
  ///
  /// In en, this message translates to:
  /// **'The assessment grade will be calculated from these activities.'**
  String get activityCalculationReady;

  /// No description provided for @activityCalculationIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Complete exactly 100% to calculate the assessment.'**
  String get activityCalculationIncomplete;

  /// No description provided for @cycleEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename term'**
  String get cycleEditTitle;

  /// No description provided for @cyclesManageAction.
  ///
  /// In en, this message translates to:
  /// **'Manage terms'**
  String get cyclesManageAction;

  /// No description provided for @cycleCreateInlineAction.
  ///
  /// In en, this message translates to:
  /// **'Create new term'**
  String get cycleCreateInlineAction;

  /// No description provided for @subjectsCycleFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Academic term to view'**
  String get subjectsCycleFilterLabel;

  /// No description provided for @subjectsEmptyForCycle.
  ///
  /// In en, this message translates to:
  /// **'This term does not have any subjects yet.'**
  String get subjectsEmptyForCycle;

  /// No description provided for @cycleActivateAction.
  ///
  /// In en, this message translates to:
  /// **'Set as active term'**
  String get cycleActivateAction;

  /// No description provided for @cycleRenameAction.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get cycleRenameAction;

  /// No description provided for @cycleCurrentState.
  ///
  /// In en, this message translates to:
  /// **'This is the current term'**
  String get cycleCurrentState;

  /// No description provided for @cycleNotCurrentState.
  ///
  /// In en, this message translates to:
  /// **'This is not the current term'**
  String get cycleNotCurrentState;

  /// No description provided for @dashboardNoCurrentCycleMessage.
  ///
  /// In en, this message translates to:
  /// **'You have not set a current term. Activate one to see its subjects and grades here.'**
  String get dashboardNoCurrentCycleMessage;

  /// No description provided for @dashboardChooseCurrentCycle.
  ///
  /// In en, this message translates to:
  /// **'Choose current term'**
  String get dashboardChooseCurrentCycle;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupTitle;

  /// No description provided for @backupExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export all my data'**
  String get backupExportTitle;

  /// No description provided for @backupExportDescription.
  ///
  /// In en, this message translates to:
  /// **'Creates a file you can save or share.'**
  String get backupExportDescription;

  /// No description provided for @backupImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import a backup'**
  String get backupImportTitle;

  /// No description provided for @backupImportDescription.
  ///
  /// In en, this message translates to:
  /// **'Restores students, terms, subjects and grades from a file.'**
  String get backupImportDescription;

  /// No description provided for @backupImportConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Import a backup?'**
  String get backupImportConfirmTitle;

  /// No description provided for @backupImportConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Current data on this device will be replaced. This action cannot be undone.'**
  String get backupImportConfirmMessage;

  /// No description provided for @backupChooseFileAction.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get backupChooseFileAction;

  /// No description provided for @backupImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'The backup was imported successfully.'**
  String get backupImportSuccess;

  /// No description provided for @backupInvalidFileError.
  ///
  /// In en, this message translates to:
  /// **'This file is not a valid CUM Master backup.'**
  String get backupInvalidFileError;

  /// No description provided for @backupImportError.
  ///
  /// In en, this message translates to:
  /// **'The backup could not be imported.'**
  String get backupImportError;

  /// No description provided for @backupExportError.
  ///
  /// In en, this message translates to:
  /// **'The backup could not be created.'**
  String get backupExportError;

  /// No description provided for @dashboardCycleSelectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Displayed term'**
  String get dashboardCycleSelectorLabel;

  /// No description provided for @dashboardCurrentCycleShort.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get dashboardCurrentCycleShort;

  /// No description provided for @dashboardShowCurrentCycle.
  ///
  /// In en, this message translates to:
  /// **'View current'**
  String get dashboardShowCurrentCycle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'App theme'**
  String get settingsThemeLabel;

  /// No description provided for @settingsThemeHelp.
  ///
  /// In en, this message translates to:
  /// **'Follow your phone appearance or choose a fixed theme.'**
  String get settingsThemeHelp;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'Use device theme'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Settings could not be loaded.'**
  String get settingsLoadError;

  /// No description provided for @settingsCalculationTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculations and defaults'**
  String get settingsCalculationTitle;

  /// No description provided for @settingsDefaultUvLabel.
  ///
  /// In en, this message translates to:
  /// **'Default credit units'**
  String get settingsDefaultUvLabel;

  /// No description provided for @settingsDefaultUvHelp.
  ///
  /// In en, this message translates to:
  /// **'Used when creating a new subject.'**
  String get settingsDefaultUvHelp;

  /// No description provided for @settingsDecimalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Displayed decimals'**
  String get settingsDecimalsLabel;

  /// No description provided for @settingsDecimalsValue.
  ///
  /// In en, this message translates to:
  /// **'{count} decimal places'**
  String settingsDecimalsValue(int count);

  /// No description provided for @settingsRoundingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rounding method'**
  String get settingsRoundingLabel;

  /// No description provided for @settingsRoundingCeiling.
  ///
  /// In en, this message translates to:
  /// **'Round up'**
  String get settingsRoundingCeiling;

  /// No description provided for @settingsRoundingNearest.
  ///
  /// In en, this message translates to:
  /// **'Nearest value'**
  String get settingsRoundingNearest;

  /// No description provided for @settingsRoundingFloor.
  ///
  /// In en, this message translates to:
  /// **'Round down'**
  String get settingsRoundingFloor;

  /// No description provided for @settingsApplyUvAction.
  ///
  /// In en, this message translates to:
  /// **'Apply these units to existing subjects'**
  String get settingsApplyUvAction;

  /// No description provided for @settingsApplyUvTitle.
  ///
  /// In en, this message translates to:
  /// **'Update every subject?'**
  String get settingsApplyUvTitle;

  /// No description provided for @settingsApplyUvMessage.
  ///
  /// In en, this message translates to:
  /// **'Every subject will use {value} credit units. Grades will not change.'**
  String settingsApplyUvMessage(String value);

  /// No description provided for @settingsApplyAction.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get settingsApplyAction;

  /// No description provided for @settingsUvApplied.
  ///
  /// In en, this message translates to:
  /// **'Credit units were updated successfully.'**
  String get settingsUvApplied;

  /// No description provided for @settingsTerminologyTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminology'**
  String get settingsTerminologyTitle;

  /// No description provided for @settingsTerminologyHelp.
  ///
  /// In en, this message translates to:
  /// **'Leave fields empty to use the language defaults.'**
  String get settingsTerminologyHelp;

  /// No description provided for @settingsCycleTerm.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get settingsCycleTerm;

  /// No description provided for @settingsSubjectTerm.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get settingsSubjectTerm;

  /// No description provided for @settingsAssessmentTerm.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get settingsAssessmentTerm;

  /// No description provided for @settingsActivityTerm.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get settingsActivityTerm;

  /// No description provided for @settingsSingularLabel.
  ///
  /// In en, this message translates to:
  /// **'singular'**
  String get settingsSingularLabel;

  /// No description provided for @settingsPluralLabel.
  ///
  /// In en, this message translates to:
  /// **'plural'**
  String get settingsPluralLabel;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved.'**
  String get settingsSaved;

  /// No description provided for @tutorialTitle.
  ///
  /// In en, this message translates to:
  /// **'How to use CUM Master'**
  String get tutorialTitle;

  /// No description provided for @tutorialMenuAction.
  ///
  /// In en, this message translates to:
  /// **'View tutorial'**
  String get tutorialMenuAction;

  /// No description provided for @tutorialSkipAction.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tutorialSkipAction;

  /// No description provided for @tutorialPreviousAction.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get tutorialPreviousAction;

  /// No description provided for @tutorialNextAction.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutorialNextAction;

  /// No description provided for @tutorialFinishAction.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get tutorialFinishAction;

  /// No description provided for @tutorialStepPosition.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String tutorialStepPosition(int current, int total);

  /// No description provided for @tutorialWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your academic history in one place'**
  String get tutorialWelcomeTitle;

  /// No description provided for @tutorialWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'CUM Master works without an account and stores everything on this device. Organize terms, subjects and grades using your university\'s structure.'**
  String get tutorialWelcomeDescription;

  /// No description provided for @tutorialStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with a student'**
  String get tutorialStudentsTitle;

  /// No description provided for @tutorialStudentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a student using their student card number and optional university. You can manage several students without authentication.'**
  String get tutorialStudentsDescription;

  /// No description provided for @tutorialCyclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Organize subjects by term'**
  String get tutorialCyclesTitle;

  /// No description provided for @tutorialCyclesDescription.
  ///
  /// In en, this message translates to:
  /// **'Create historical terms and mark only the one you are attending as current. Then add each subject to its term and assign its credit units.'**
  String get tutorialCyclesDescription;

  /// No description provided for @tutorialGradesTitle.
  ///
  /// In en, this message translates to:
  /// **'Record only the detail you need'**
  String get tutorialGradesTitle;

  /// No description provided for @tutorialGradesDescription.
  ///
  /// In en, this message translates to:
  /// **'You can enter each assessment grade directly. For more precision, add activities and weights; the assessment is calculated when they total 100%.'**
  String get tutorialGradesDescription;

  /// No description provided for @tutorialDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Review averages and CUM'**
  String get tutorialDashboardTitle;

  /// No description provided for @tutorialDashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'The dashboard shows subjects for the selected term. Browse historical terms, return to the current one and review the general credit-weighted CUM.'**
  String get tutorialDashboardDescription;

  /// No description provided for @tutorialBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Configure and protect your data'**
  String get tutorialBackupTitle;

  /// No description provided for @tutorialBackupDescription.
  ///
  /// In en, this message translates to:
  /// **'Academic settings control credit units, decimals, rounding and terminology. Export regular backups so you can restore them on another phone.'**
  String get tutorialBackupDescription;

  /// No description provided for @assessmentManualGrade.
  ///
  /// In en, this message translates to:
  /// **'Manual grade (no activities)'**
  String get assessmentManualGrade;

  /// No description provided for @assessmentCalculatedGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade calculated from activities'**
  String get assessmentCalculatedGrade;

  /// No description provided for @dashboardGeneralCum.
  ///
  /// In en, this message translates to:
  /// **'Overall historical GPA: {cum}'**
  String dashboardGeneralCum(String cum);
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
