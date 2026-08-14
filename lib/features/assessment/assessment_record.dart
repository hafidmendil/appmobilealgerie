import 'package:hive/hive.dart';
import 'package:projetmascara/features/engine/decision_engine.dart';

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
}
