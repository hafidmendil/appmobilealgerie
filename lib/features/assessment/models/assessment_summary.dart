class AssessmentSummary {
  final String id;
  final String userId;
  final DateTime date;
  final Map<String, double> domains;
  final String riskLevel;
  final List<String> recommendations;

  const AssessmentSummary({
    required this.id,
    required this.userId,
    required this.date,
    required this.domains,
    required this.riskLevel,
    required this.recommendations,
  });
}
