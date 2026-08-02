import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewedCycleIds extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => const {};

  void select(String studentId, String cycleId) {
    state = {...state, studentId: cycleId};
  }

  void clear(String studentId) {
    if (!state.containsKey(studentId)) return;
    final updated = {...state}..remove(studentId);
    state = updated;
  }
}

final viewedCycleIdsProvider =
    NotifierProvider<ViewedCycleIds, Map<String, String>>(ViewedCycleIds.new);
