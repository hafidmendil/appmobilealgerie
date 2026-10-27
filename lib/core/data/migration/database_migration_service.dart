import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/data/local_database.dart';
import 'package:projetmascara/core/data/sync/sync_queue_service.dart';
import 'package:projetmascara/core/models/sync_item.dart';
import 'package:projetmascara/core/services/logger_service.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';

class DatabaseMigrationService {
  static const int currentDatabaseVersion = 4;
  static const String versionKey = 'schema_db_version';

  final LocalDatabase db;

  DatabaseMigrationService({LocalDatabase? database})
    : db = database ?? LocalDatabase.instance;

  Box get _settingsBox => db.getBox(HiveConfig.settingsBox);

  /// Executes database schema migrations sequentially if necessary.
  Future<void> runMigrations() async {
    final storedVersion = _settingsBox.get(versionKey, defaultValue: 1) as int;

    logger.i(
      'Database Migration Check: Current Stored Version = $storedVersion, Target Version = $currentDatabaseVersion',
    );

    if (storedVersion >= currentDatabaseVersion) {
      logger.i('Database schema is up to date.');
      return;
    }

    try {
      if (storedVersion < 2) {
        await _migrateToV2();
      }
      if (storedVersion < 3) {
        await _migrateToV3();
      }
      if (storedVersion < 4) {
        await _migrateToV4();
      }

      await _settingsBox.put(versionKey, currentDatabaseVersion);
      logger.i(
        'Successfully upgraded database schema to version $currentDatabaseVersion',
      );
    } catch (e, st) {
      logger.e('Database migration failed: $e. Executing fallback...', e, st);
      await _executeFallback(storedVersion);
    }
  }

  /// Migration step to version 2: Normalizes sync fields and default values.
  Future<void> _migrateToV2() async {
    logger.i('Executing DB Migration V1 -> V2...');

    // 1. Normalize assessment records
    if (Hive.isBoxOpen(HiveConfig.assessmentResultsBox)) {
      final box = db.getBox<AssessmentRecord>(HiveConfig.assessmentResultsBox);
      for (final key in box.keys) {
        final record = box.get(key);
        if (record != null) {
          // Validate record integrity
          if (record.id.isEmpty) continue;
          await box.put(key, record);
        }
      }
    }

    logger.i('DB Migration V1 -> V2 completed successfully');
  }

  /// V3 reserves unique Hive adapter ids for professional profiles and user
  /// progression. Existing records are left intact; the previously duplicated
  /// ids only prevented reliable writes and must not trigger data deletion.
  Future<void> _migrateToV3() async {
    logger.i('Executing DB Migration V2 -> V3 (unique Hive adapter ids)...');
  }

  /// V4 introduces local account-security flags and an encrypted box for the
  /// institutional approval register. Hive adapter fields are backward
  /// compatible, so no user record is rewritten here.
  Future<void> _migrateToV4() async {
    logger.i('Executing DB Migration V3 -> V4 (local governance controls)...');
  }

  /// Fallback strategy in case migration encounters an unrecoverable exception.
  Future<void> _executeFallback(int previousVersion) async {
    logger.w(
      'Migration fallback activated. Preserving previous version $previousVersion',
    );
    await _settingsBox.put(versionKey, previousVersion);
  }

  /// Migrates local Guest data to a newly registered / logged-in user account.
  /// (Prompt Section 9 compliance)
  Future<int> migrateGuestDataToUser({
    required String guestId,
    required String registeredUserId,
    SyncQueueService? syncQueue,
  }) async {
    logger.i(
      'Starting Guest -> Registered User data migration (guestId: $guestId -> userId: $registeredUserId)',
    );

    int migratedCount = 0;

    // 1. Migrate Assessment Records
    if (Hive.isBoxOpen(HiveConfig.assessmentResultsBox)) {
      final box = db.getBox<AssessmentRecord>(HiveConfig.assessmentResultsBox);
      for (final key in box.keys) {
        final record = box.get(key);
        if (record != null &&
            (record.userId == null ||
                record.userId == guestId ||
                record.userId == 'guest')) {
          final updatedRecord = AssessmentRecord(
            id: record.id,
            userId: registeredUserId,
            answers: record.answers,
            safetyAnswers: record.safetyAnswers,
            createdAt: record.createdAt,
            syncStatus: 'pending',
            finalMessage: record.finalMessage,
          );
          await box.put(key, updatedRecord);
          migratedCount++;

          // Enqueue for cloud sync under new account
          if (syncQueue != null) {
            await syncQueue.enqueue(
              SyncItem(
                id: 'sync_migrated_${record.id}',
                type: 'assessment',
                operation: SyncOperation.create,
                payload: {
                  'id': record.id,
                  'userId': registeredUserId,
                  'answers': record.answers,
                  'safetyAnswers': record.safetyAnswers,
                  'createdAt': record.createdAt.toIso8601String(),
                },
                createdAt: DateTime.now(),
                userId: registeredUserId,
                entityId: record.id,
                priority: 2,
              ),
            );
          }
        }
      }
    }

    // 2. Migrate Protection Reports
    if (Hive.isBoxOpen(HiveConfig.protectionReportsBox)) {
      final box = db.getBox<dynamic>(HiveConfig.protectionReportsBox);
      for (final key in box.keys) {
        final map = box.get(key);
        if (map is Map &&
            (map['userId'] == null ||
                map['userId'] == guestId ||
                map['userId'] == 'guest')) {
          final updated = Map<String, dynamic>.from(map);
          updated['userId'] = registeredUserId;
          updated['updatedAt'] = DateTime.now().toIso8601String();
          await box.put(key, updated);
          migratedCount++;

          if (syncQueue != null) {
            await syncQueue.enqueue(
              SyncItem(
                id: 'sync_migrated_report_${updated['id']}',
                type: 'violence_report',
                operation: SyncOperation.create,
                payload: updated,
                createdAt: DateTime.now(),
                userId: registeredUserId,
                entityId: updated['id'] as String?,
                priority: 3,
              ),
            );
          }
        }
      }
    }

    logger.i(
      'Guest data migration completed: $migratedCount items transferred to user $registeredUserId',
    );
    return migratedCount;
  }
}
