import 'package:hive/hive.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/core/services/assessment_repository.dart';
import 'package:projetmascara/core/data/hive_config.dart';

class MockAssessmentRepository implements AssessmentRepository {
  static const String _boxName = 'assessments';

  Future<Box<AssessmentRecord>> _getBox() async {
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    return await Hive.openBox<AssessmentRecord>(_boxName, encryptionCipher: encryptionCipher);
  }

  @override
  Future<List<AssessmentRecord>> getAssessments(String? userId) async {
    final box = await _getBox();
    return box.values.where((r) => r.userId == userId).toList();
  }

  @override
  Future<void> saveAssessment(AssessmentRecord record) async {
    final box = await _getBox();
    await box.put(record.id, record);
    
    // Simulate immediate sync if online and user is logged in
    if (record.userId != null) {
      await syncAssessments(record.userId!);
    }
  }

  @override
  Future<void> syncAssessments(String userId) async {
    final box = await _getBox();
    final unsynced = box.values.where((r) => r.userId == userId && r.syncStatus != 'synced');
    
    for (var record in unsynced) {
      await Future.delayed(const Duration(milliseconds: 200));
      final updated = AssessmentRecord(
        id: record.id,
        userId: record.userId,
        answers: record.answers,
        safetyAnswers: record.safetyAnswers,
        createdAt: record.createdAt,
        syncStatus: 'synced',
      );
      await box.put(record.id, updated);
    }
  }

  @override
  Future<void> migrateGuestAssessments(String userId) async {
    final box = await _getBox();
    final guestRecords = box.values.where((r) => r.userId == null).toList();
    
    for (var record in guestRecords) {
      final migrated = AssessmentRecord(
        id: record.id,
        userId: userId,
        answers: record.answers,
        safetyAnswers: record.safetyAnswers,
        createdAt: record.createdAt,
        syncStatus: 'pending',
      );
      await box.put(record.id, migrated);
    }
    
    if (guestRecords.isNotEmpty) {
      await syncAssessments(userId);
    }
  }
}
