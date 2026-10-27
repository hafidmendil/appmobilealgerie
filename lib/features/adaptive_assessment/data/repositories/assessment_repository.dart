import '../../domain/models/assessment_result.dart';
import '../../../../core/services/hive_assessment_repository.dart';
import '../../../assessment/assessment_record.dart';

class AssessmentRepository {
  final HiveAssessmentRepository _recordsRepository =
      HiveAssessmentRepository();

  Future<void> init() async {
    // The shared Hive box is opened by HiveConfig during application startup.
  }

  Future<void> saveResult(
    AssessmentResult result, {
    required String userId,
    required Map<String, int?> answers,
    Map<String, bool> safetyAnswers = const {},
  }) async {
    await _recordsRepository.saveAssessment(
      AssessmentRecord(
        id: result.sessionId,
        userId: userId,
        answers: {
          for (final entry in answers.entries)
            if (entry.value != null) entry.key: entry.value!,
        },
        safetyAnswers: safetyAnswers,
        createdAt: result.createdAt,
        finalMessage: result.userFreeMessage,
      ),
    );
  }

  Future<void> clearHistory() async {
    // History is shared with the admin and professional views.
    final records = await _recordsRepository.getAssessments(null);
    for (final record in records) {
      await _recordsRepository.deleteAssessment(record.id);
    }
  }
}
