import 'package:flutter_riverpod/flutter_riverpod.dart';

final academicDataRevisionProvider =
    NotifierProvider<AcademicDataRevision, int>(AcademicDataRevision.new);

class AcademicDataRevision extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}
