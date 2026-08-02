import 'dart:math' as math;

enum GradeRoundingMode { ceiling, nearest, floor }

class AcademicSettings {
  const AcademicSettings({
    required this.defaultCreditUnits,
    required this.decimalPlaces,
    required this.roundingMode,
    this.cycleSingular,
    this.cyclePlural,
    this.subjectSingular,
    this.subjectPlural,
    this.assessmentSingular,
    this.assessmentPlural,
    this.activitySingular,
    this.activityPlural,
  });

  static const defaults = AcademicSettings(
    defaultCreditUnits: 1,
    decimalPlaces: 1,
    roundingMode: GradeRoundingMode.ceiling,
  );

  final double defaultCreditUnits;
  final int decimalPlaces;
  final GradeRoundingMode roundingMode;
  final String? cycleSingular;
  final String? cyclePlural;
  final String? subjectSingular;
  final String? subjectPlural;
  final String? assessmentSingular;
  final String? assessmentPlural;
  final String? activitySingular;
  final String? activityPlural;

  double rounded(double value) {
    final factor = math.pow(10, decimalPlaces).toDouble();
    final scaled = value * factor;
    final rounded = switch (roundingMode) {
      GradeRoundingMode.ceiling => scaled.ceilToDouble(),
      GradeRoundingMode.nearest => scaled.roundToDouble(),
      GradeRoundingMode.floor => scaled.floorToDouble(),
    };
    return rounded / factor;
  }

  String format(double value) => rounded(value).toStringAsFixed(decimalPlaces);
}
