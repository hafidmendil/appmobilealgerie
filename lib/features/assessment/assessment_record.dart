import 'package:hive/hive.dart';

part 'assessment_record.g.dart';

@HiveType(typeId: 2)
class AssessmentRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? userId; // Null if guest

  @HiveField(2)
  final Map<String, int> answers;

  @HiveField(3)
  final Map<String, bool> safetyAnswers;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String syncStatus; // pending, syncing, synced, failed

  @HiveField(6)
  final String? finalMessage;

  AssessmentRecord({
    required this.id,
    this.userId,
    required this.answers,
    required this.safetyAnswers,
    required this.createdAt,
    this.syncStatus = 'pending',
    this.finalMessage,
  });

  bool get isHighRisk {
    // If any safety trigger is true (e.g. self-harm thoughts)
    return safetyAnswers.values.any((v) => v == true);
  }

  double get depressionSeverity {
    int total = 0;
    int count = 0;
    answers.forEach((key, value) {
      if (key.startsWith('dep')) {
        total += value;
        count++;
      }
    });
    return count > 0 ? (total / count) : 0.0;
  }
}
