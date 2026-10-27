import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'assessment_repository.dart';
import 'package:hive/hive.dart';
import '../data/hive_config.dart';

class HiveAssessmentRepository implements AssessmentRepository {
  Box<AssessmentRecord> _getBox() {
    return Hive.box<AssessmentRecord>(HiveConfig.assessmentResultsBox);
  }

  @override
  Future<void> saveAssessment(AssessmentRecord record) async {
    final box = _getBox();
    await box.put(record.id, record);
  }

  @override
  Future<List<AssessmentRecord>> getAssessments(String? userId) async {
    final box = _getBox();
    if (userId == null || userId == "guest") {
      return box.values
          .where((a) => a.userId == null || a.userId == "guest")
          .toList();
    }
    return box.values.where((a) => a.userId == userId).toList();
  }

  @override
  Future<void> migrateGuestAssessments(String userId) async {
    final box = _getBox();
    final guestAssessments = box.values
        .where((a) => a.userId == null || a.userId == "guest")
        .toList();

    for (var assessment in guestAssessments) {
      final updated = AssessmentRecord(
        id: assessment.id,
        userId: userId,
        answers: assessment.answers,
        safetyAnswers: assessment.safetyAnswers,
        createdAt: assessment.createdAt,
        finalMessage: assessment.finalMessage,
      );
      await box.put(updated.id, updated);
    }
  }

  @override
  Future<void> deleteAssessment(String id) async {
    final box = _getBox();
    await box.delete(id);
  }
}
