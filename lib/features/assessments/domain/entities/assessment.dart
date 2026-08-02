class Assessment {
  Assessment({
    required String id,
    required String subjectId,
    required String name,
    required this.score,
    required this.maxScore,
    this.weight,
    required this.createdAt,
    required this.updatedAt,
  }) : id = _required(id, 'id'),
       subjectId = _required(subjectId, 'subjectId'),
       name = _required(name, 'name') {
    if (!score.isFinite ||
        !maxScore.isFinite ||
        score < 0 ||
        maxScore <= 0 ||
        score > maxScore) {
      throw ArgumentError('Score must be between zero and maxScore.');
    }
    if (weight != null &&
        (!weight!.isFinite || weight! <= 0 || weight! > 100)) {
      throw ArgumentError.value(weight, 'weight');
    }
    if (!createdAt.isUtc || !updatedAt.isUtc || updatedAt.isBefore(createdAt)) {
      throw ArgumentError('Dates must be valid UTC values.');
    }
  }

  final String id;
  final String subjectId;
  final String name;
  final double score;
  final double maxScore;
  final double? weight;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get percentage => score / maxScore * 100;

  Assessment copyWith({
    required String name,
    required double score,
    required double maxScore,
    double? weight,
    required DateTime updatedAt,
  }) => Assessment(
    id: id,
    subjectId: subjectId,
    name: name,
    score: score,
    maxScore: maxScore,
    weight: weight,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static String _required(String value, String field) {
    final normalized = value.trim();
    if (normalized.isEmpty) throw ArgumentError.value(value, field);
    return normalized;
  }
}
