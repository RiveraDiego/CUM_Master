class Activity {
  Activity({
    required this.id,
    required this.assessmentId,
    required String name,
    required this.score,
    required this.maxScore,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
  }) : name = name.trim() {
    if (id.isEmpty || assessmentId.isEmpty || this.name.isEmpty) {
      throw ArgumentError('Required activity field.');
    }
    if (score < 0 || maxScore <= 0 || score > maxScore) {
      throw ArgumentError('Invalid score.');
    }
    if (weight <= 0 || weight > 100) throw ArgumentError('Invalid weight.');
  }
  final String id;
  final String assessmentId;
  final String name;
  final double score;
  final double maxScore;
  final double weight;
  final DateTime createdAt;
  final DateTime updatedAt;
  double get percentage => score / maxScore * 100;
}
