import 'academic_settings.dart';

abstract interface class AcademicSettingsRepository {
  Future<AcademicSettings> get();
  Future<void> save(AcademicSettings settings);
  Future<void> applyDefaultCreditUnitsToAllSubjects(double value);
}
