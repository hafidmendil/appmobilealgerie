class AssessmentRecord {
  final String id;
  final String userId;
  final DateTime date;
  final Map<String, int?> answers;
  final Map<String, double> scores;
  final Map<String, double> domains;
  final String riskLevel;
  final List<String> recommendations;
  final Map<String, dynamic> engineTrace;

  const AssessmentRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.answers,
    required this.scores,
    this.domains = const {},
    this.riskLevel = 'stable',
    this.recommendations = const [],
    this.engineTrace = const {},
  });

  bool get isNonDiagnostic => true;
}
