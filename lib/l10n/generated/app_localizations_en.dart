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
  String get drawerTagline => 'Your academic progress';

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
  String get studentNameLabel => 'Student name';

  @override
  String get studentNameHint => 'E.g. Diego, Ana, or My account';

  @override
  String get optionalFieldLabel => 'Optional';

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

  @override
  String get subjectsTitle => 'Subjects';

  @override
  String get subjectsCreateAction => 'Add subject';

  @override
  String get subjectsEmptyDescription =>
      'This student has no subjects yet. Add the first one to start organizing grades.';

  @override
  String get subjectsLoadError => 'Subjects could not be loaded.';

  @override
  String get subjectCreateTitle => 'Add subject';

  @override
  String get subjectEditTitle => 'Edit subject';

  @override
  String get subjectNameLabel => 'Subject name';

  @override
  String get subjectNameRequiredError => 'The subject name is required.';

  @override
  String get subjectCodeLabel => 'Code (optional)';

  @override
  String get subjectCodeNotSpecified => 'No code';

  @override
  String get subjectDuplicateError =>
      'A subject with this name already exists for the student.';

  @override
  String get subjectMoreActions => 'More subject actions';

  @override
  String get subjectDeleteTitle => 'Delete subject?';

  @override
  String subjectDeleteMessage(String subjectName) {
    return 'The subject $subjectName will be permanently deleted.';
  }

  @override
  String get subjectDeleted => 'Subject deleted.';

  @override
  String get subjectNotFoundError => 'This subject no longer exists.';

  @override
  String get subjectStorageError =>
      'The subject data could not be saved. Try again.';

  @override
  String get assessmentsTitle => 'Assessments and grades';

  @override
  String get assessmentsCreateAction => 'Add assessment';

  @override
  String get assessmentsEmptyDescription =>
      'This subject has no assessments yet. Add the first grade.';

  @override
  String get assessmentsLoadError => 'Assessments could not be loaded.';

  @override
  String get assessmentCreateTitle => 'Add assessment';

  @override
  String get assessmentEditTitle => 'Edit assessment';

  @override
  String get assessmentNameLabel => 'Assessment name';

  @override
  String get assessmentNameRequiredError => 'The name is required.';

  @override
  String get assessmentScoreLabel => 'Score obtained';

  @override
  String get assessmentMaxScoreLabel => 'Maximum score';

  @override
  String get assessmentWeightLabel => 'Weight % (optional)';

  @override
  String get assessmentNumberError =>
      'Enter a number equal to or greater than zero.';

  @override
  String get assessmentPositiveError => 'Enter a number greater than zero.';

  @override
  String get assessmentScoreRangeError =>
      'The obtained score cannot exceed the maximum score.';

  @override
  String get assessmentWeightError => 'The weight must be between 0 and 100.';

  @override
  String get assessmentDuplicateError =>
      'An assessment with this name already exists.';

  @override
  String get assessmentStorageError =>
      'The assessment data could not be saved.';

  @override
  String get assessmentDeleteTitle => 'Delete assessment?';

  @override
  String assessmentDeleteMessage(String assessmentName) {
    return '$assessmentName will be permanently deleted.';
  }

  @override
  String assessmentScore(num score, num maxScore) {
    return '$score out of $maxScore';
  }

  @override
  String get dashboardTitle => 'Home';

  @override
  String get dashboardStudentFilterLabel => 'Filter by student';

  @override
  String get dashboardAllStudents => 'All students';

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get statisticsLoadError => 'Statistics could not be calculated.';

  @override
  String get statisticsNoStudents =>
      'Add a student to start building their academic history.';

  @override
  String get statisticsNoCycles => 'This student does not have any terms yet.';

  @override
  String get statisticsEvolutionTitle => 'Average evolution by term';

  @override
  String statisticsCycleSubjects(int graded, int total) {
    return '$graded of $total subjects graded';
  }

  @override
  String statisticsAverageValue(String value) {
    return 'Avg. $value';
  }

  @override
  String statisticsCumValue(String value) {
    return 'GPA $value';
  }

  @override
  String get dashboardLoadError => 'The academic summary could not be loaded.';

  @override
  String get dashboardNoStudents =>
      'Add a student to see their academic summary.';

  @override
  String get dashboardNoSubjects => 'This student has no subjects yet.';

  @override
  String get dashboardNoGrades => 'No assessments recorded';

  @override
  String get dashboardWeightedAverage => 'Weighted average';

  @override
  String get dashboardSimpleAverage => 'Simple average';

  @override
  String get dashboardManageSubjects => 'Manage subjects';

  @override
  String get dashboardNoActiveCycle => 'No active term';

  @override
  String get cyclesTitle => 'Academic terms';

  @override
  String get cyclesCreateAction => 'Add term';

  @override
  String get cyclesEmpty =>
      'There are no terms yet. Add one to organize subjects.';

  @override
  String get cyclesLoadError => 'Academic terms could not be loaded.';

  @override
  String get cycleCreateTitle => 'Add academic term';

  @override
  String get cycleNameLabel => 'Term name';

  @override
  String get cycleActive => 'Active term';

  @override
  String get cycleDuplicateError => 'A term with this name already exists.';

  @override
  String get cycleInUseError => 'A term containing subjects cannot be deleted.';

  @override
  String get cycleStorageError => 'The academic term data could not be saved.';

  @override
  String get subjectCycleLabel => 'Academic term';

  @override
  String get subjectCycleRequiredError =>
      'Select the term this subject belongs to.';

  @override
  String get subjectCreditUnitsLabel => 'Credit units';

  @override
  String get subjectCreditUnitsError => 'Enter credit units greater than zero.';

  @override
  String get subjectHistoricalGradeLabel => 'Historical final grade (optional)';

  @override
  String get subjectHistoricalGradeHelp =>
      'When entered, it takes priority over assessment calculations.';

  @override
  String get subjectHistoricalGradeError =>
      'The grade must be between 0 and 10.';

  @override
  String get activitiesTitle => 'Activities';

  @override
  String get activitiesCreateAction => 'Add activity';

  @override
  String get activitiesEmpty =>
      'There are no activities. The manual assessment grade will be used.';

  @override
  String get activitiesLoadError => 'Activities could not be loaded.';

  @override
  String get activityCreateTitle => 'Add activity';

  @override
  String get activityEditTitle => 'Edit activity';

  @override
  String get activityNameLabel => 'Activity name';

  @override
  String get activityRequiredError => 'The name is required.';

  @override
  String activityWeightTotal(num weight) {
    return 'Total weight: $weight%';
  }

  @override
  String get activityCalculationReady =>
      'The assessment grade will be calculated from these activities.';

  @override
  String get activityCalculationIncomplete =>
      'Complete exactly 100% to calculate the assessment.';

  @override
  String get cycleEditTitle => 'Rename term';

  @override
  String get cyclesManageAction => 'Manage terms';

  @override
  String get cycleCreateInlineAction => 'Create new term';

  @override
  String get subjectsCycleFilterLabel => 'Academic term to view';

  @override
  String get subjectsEmptyForCycle =>
      'This term does not have any subjects yet.';

  @override
  String get cycleActivateAction => 'Set as active term';

  @override
  String get cycleRenameAction => 'Rename';

  @override
  String get cycleCurrentState => 'This is the current term';

  @override
  String get cycleNotCurrentState => 'This is not the current term';

  @override
  String get dashboardNoCurrentCycleMessage =>
      'You have not set a current term. Activate one to see its subjects and grades here.';

  @override
  String get dashboardChooseCurrentCycle => 'Choose current term';

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupExportTitle => 'Export all my data';

  @override
  String get backupExportDescription => 'Creates a file you can save or share.';

  @override
  String get backupImportTitle => 'Import a backup';

  @override
  String get backupImportDescription =>
      'Restores students, terms, subjects and grades from a file.';

  @override
  String get backupImportConfirmTitle => 'Import a backup?';

  @override
  String get backupImportConfirmMessage =>
      'Current data on this device will be replaced. This action cannot be undone.';

  @override
  String get backupChooseFileAction => 'Choose file';

  @override
  String get backupImportSuccess => 'The backup was imported successfully.';

  @override
  String get backupInvalidFileError =>
      'This file is not a valid CUM Master backup.';

  @override
  String get backupImportError => 'The backup could not be imported.';

  @override
  String get backupExportError => 'The backup could not be created.';

  @override
  String get dashboardCycleSelectorLabel => 'Displayed term';

  @override
  String get dashboardCurrentCycleShort => 'Current';

  @override
  String get dashboardShowCurrentCycle => 'View current';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsThemeLabel => 'App theme';

  @override
  String get settingsThemeHelp =>
      'Follow your phone appearance or choose a fixed theme.';

  @override
  String get settingsThemeSystem => 'Use device theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLoadError => 'Settings could not be loaded.';

  @override
  String get settingsCalculationTitle => 'Calculations and defaults';

  @override
  String get settingsDefaultUvLabel => 'Default credit units';

  @override
  String get settingsDefaultUvHelp => 'Used when creating a new subject.';

  @override
  String get settingsDecimalsLabel => 'Displayed decimals';

  @override
  String settingsDecimalsValue(int count) {
    return '$count decimal places';
  }

  @override
  String get settingsRoundingLabel => 'Rounding method';

  @override
  String get settingsRoundingCeiling => 'Always round up';

  @override
  String get settingsRoundingNearest => 'Standard (5 or more rounds up)';

  @override
  String get settingsRoundingFloor => 'Round down';

  @override
  String get settingsApplyUvAction => 'Apply these units to existing subjects';

  @override
  String get settingsApplyUvTitle => 'Update every subject?';

  @override
  String settingsApplyUvMessage(String value) {
    return 'Every subject will use $value credit units. Grades will not change.';
  }

  @override
  String get settingsApplyAction => 'Apply';

  @override
  String get settingsUvApplied => 'Credit units were updated successfully.';

  @override
  String get settingsTerminologyTitle => 'Terminology';

  @override
  String get settingsTerminologyHelp =>
      'Leave fields empty to use the language defaults.';

  @override
  String get settingsCycleTerm => 'Term';

  @override
  String get settingsSubjectTerm => 'Subject';

  @override
  String get settingsAssessmentTerm => 'Assessment';

  @override
  String get settingsActivityTerm => 'Activity';

  @override
  String get settingsSingularLabel => 'singular';

  @override
  String get settingsPluralLabel => 'plural';

  @override
  String get settingsSaved => 'Settings saved.';

  @override
  String get tutorialTitle => 'How to use CUM Master';

  @override
  String get tutorialMenuAction => 'View tutorial';

  @override
  String get tutorialSkipAction => 'Skip';

  @override
  String get tutorialPreviousAction => 'Previous';

  @override
  String get tutorialNextAction => 'Next';

  @override
  String get tutorialFinishAction => 'Get started';

  @override
  String tutorialStepPosition(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get tutorialWelcomeTitle => 'Your academic history in one place';

  @override
  String get tutorialWelcomeDescription =>
      'CUM Master works without an account and stores everything on this device. Organize terms, subjects and grades using your university\'s structure.';

  @override
  String get tutorialStudentsTitle => 'Start with a student';

  @override
  String get tutorialStudentsDescription =>
      'Create a student using their student card number and optional university. You can manage several students without authentication.';

  @override
  String get tutorialCyclesTitle => 'Organize subjects by term';

  @override
  String get tutorialCyclesDescription =>
      'Create historical terms and mark only the one you are attending as current. Then add each subject to its term and assign its credit units.';

  @override
  String get tutorialGradesTitle => 'Record only the detail you need';

  @override
  String get tutorialGradesDescription =>
      'You can enter each assessment grade directly. For more precision, add activities and weights; the assessment is calculated when they total 100%.';

  @override
  String get tutorialDashboardTitle => 'Review averages and CUM';

  @override
  String get tutorialDashboardDescription =>
      'The dashboard shows subjects for the selected term. Browse historical terms, return to the current one and review the general credit-weighted CUM.';

  @override
  String get tutorialBackupTitle => 'Configure and protect your data';

  @override
  String get tutorialBackupDescription =>
      'Academic settings control credit units, decimals, rounding and terminology. Export regular backups so you can restore them on another phone.';

  @override
  String get assessmentManualGrade => 'Manual grade (no activities)';

  @override
  String get assessmentCalculatedGrade => 'Grade calculated from activities';

  @override
  String dashboardGeneralCum(String cum) {
    return 'Overall historical GPA: $cum';
  }

  @override
  String get setupTitle => 'Complete initial setup';

  @override
  String get setupStudentStep => 'Student created';

  @override
  String get setupCurrentCycleStep => 'Current term selected';

  @override
  String get setupFirstSubjectStep => 'First subject added';

  @override
  String get setupFirstAssessmentStep => 'First assessment recorded';

  @override
  String get setupCreateCycleAction => 'Create first term';

  @override
  String get setupCreateSubjectAction => 'Add first subject';

  @override
  String get setupCreateAssessmentAction => 'Add first assessment';

  @override
  String get setupDismissAction => 'Hide guide';

  @override
  String get academicLocationLabel => 'You are in';
}
