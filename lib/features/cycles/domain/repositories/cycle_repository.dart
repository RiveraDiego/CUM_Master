import '../entities/academic_cycle.dart';

abstract interface class CycleRepository {
  Future<List<AcademicCycle>> getAll(String studentId);
  Future<void> create(AcademicCycle cycle);
  Future<void> setActive(String studentId, String cycleId);
  Future<void> delete(String cycleId);
}
