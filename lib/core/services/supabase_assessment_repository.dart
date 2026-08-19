import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'assessment_repository.dart';
import '../data/remote_data_source.dart';
import 'package:hive/hive.dart';
import '../data/hive_config.dart';
import 'sync_service.dart';
import '../models/sync_item.dart';

class SupabaseAssessmentRepository implements AssessmentRepository {
  final AssessmentRemoteDataSource _remoteDataSource;
  final SyncService _syncService;
  static const String _boxName = 'assessments';

  SupabaseAssessmentRepository(this._remoteDataSource, this._syncService);

  Future<Box<AssessmentRecord>> _getBox() async {
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    return await Hive.openBox<AssessmentRecord>(_boxName, encryptionCipher: encryptionCipher);
  }

  @override
  Future<void> saveAssessment(AssessmentRecord record) async {
    final box = await _getBox();
    await box.put(record.id, record);

    // Add to sync queue for background synchronization
    await _syncService.addToQueue(
      'assessment',
      SyncOperation.create,
      {
        'id': record.id,
        'userId': record.userId,
        'answers': record.answers,
        'safetyAnswers': record.safetyAnswers,
        'createdAt': record.createdAt.toIso8601String(),
        'finalMessage': record.finalMessage,
      },
    );
  }

  @override
  Future<List<AssessmentRecord>> getAssessments(String? userId) async {
    if (userId == null) {
      final box = await _getBox();
      return box.values.where((a) => a.userId == null).toList();
    }
    
    try {
      // Try fetching from remote first if online
      final remoteData = await _remoteDataSource.fetchAssessments(userId);
      
      // Update local cache
      final box = await _getBox();
      for (var item in remoteData) {
        await box.put(item.id, item);
      }
      
      return remoteData;
    } catch (e) {
      // Fallback to local cache if offline
      final box = await _getBox();
      return box.values.where((a) => a.userId == userId).toList();
    }
  }

  @override
  Future<void> migrateGuestAssessments(String userId) async {
    final box = await _getBox();
    final guestAssessments = box.values.where((a) => a.userId == null).toList();
    
    for (var assessment in guestAssessments) {
      final updated = AssessmentRecord(
        id: assessment.id,
        userId: userId,
        answers: assessment.answers,
        safetyAnswers: assessment.safetyAnswers,
        createdAt: assessment.createdAt,
        finalMessage: assessment.finalMessage,
      );
      await saveAssessment(updated);
      await box.delete(assessment.id);
    }
  }
  
  @override
  Future<void> deleteAssessment(String id) async {
    final box = await _getBox();
    await box.delete(id);
    // In a full implementation, we would also add a delete operation to the sync queue
  }
}
