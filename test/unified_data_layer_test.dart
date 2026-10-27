import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:projetmascara/core/config/app_config.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/data/local_database.dart';
import 'package:projetmascara/core/data/local_repository.dart';
import 'package:projetmascara/core/data/migration/database_migration_service.dart';
import 'package:projetmascara/core/data/sync/conflict_resolver.dart';
import 'package:projetmascara/core/data/sync/sync_queue_service.dart';
import 'package:projetmascara/core/models/sync_item.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';

class SampleRepo extends BaseHiveRepository<AssessmentRecord> {
  SampleRepo() : super(HiveConfig.assessmentResultsBox);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Map<String, String> mockSecureStorage = {};
  late Directory tempDir;

  setUpAll(() async {
    AppConfig.init(env: Environment.dev);
    tempDir = await Directory.systemTemp.createTemp('hive_unified_data_test');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'getApplicationDocumentsDirectory') {
              return tempDir.path;
            }
            return null;
          },
        );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'write') {
              final Map<dynamic, dynamic> args = methodCall.arguments;
              mockSecureStorage[args['key']] = args['value'];
              return null;
            } else if (methodCall.method == 'read') {
              final Map<dynamic, dynamic> args = methodCall.arguments;
              return mockSecureStorage[args['key']];
            } else if (methodCall.method == 'delete') {
              final Map<dynamic, dynamic> args = methodCall.arguments;
              mockSecureStorage.remove(args['key']);
              return null;
            }
            return null;
          },
        );

    await HiveConfig.init();
  });

  tearDownAll(() async {
    await Hive.close();
    try {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    } catch (_) {}
  });

  group('Unified Data Layer Tests', () {
    test(
      'LocalDatabase and BaseHiveRepository offline CRUD operations',
      () async {
        final repo = SampleRepo();
        final record = AssessmentRecord(
          id: 'test_assessment_1',
          userId: 'user_123',
          answers: {'dep1': 2, 'dep2': 3},
          safetyAnswers: {'self_harm': false},
          createdAt: DateTime.now(),
          finalMessage: 'Test result message',
        );

        await repo.save(record.id, record);

        final fetched = repo.get(record.id);
        expect(fetched, isNotNull);
        expect(fetched!.id, equals('test_assessment_1'));
        expect(fetched.userId, equals('user_123'));
        expect(fetched.depressionSeverity, equals(2.5));

        final allRecords = repo.getAll();
        expect(allRecords.any((r) => r.id == 'test_assessment_1'), isTrue);
      },
    );

    test(
      'SyncItem creation and SyncQueueService idempotent enqueuing',
      () async {
        final syncService = SyncQueueService();

        final item1 = SyncItem(
          id: 'sync_1',
          type: 'assessment',
          operation: SyncOperation.create,
          payload: {'id': 'test_assessment_1'},
          createdAt: DateTime.now(),
          userId: 'user_123',
          entityId: 'test_assessment_1',
          priority: 2,
        );

        await syncService.enqueue(item1);

        final queue = syncService.getQueue();
        expect(queue.any((i) => i.entityId == 'test_assessment_1'), isTrue);

        // Enqueue duplicate entity for same operation (idempotency check)
        final item2 = SyncItem(
          id: 'sync_2',
          type: 'assessment',
          operation: SyncOperation.create,
          payload: {'id': 'test_assessment_1', 'updatedField': 'value'},
          createdAt: DateTime.now(),
          userId: 'user_123',
          entityId: 'test_assessment_1',
          priority: 2,
        );

        await syncService.enqueue(item2);

        final updatedQueue = syncService.getQueue();
        final matchingItems = updatedQueue
            .where((i) => i.entityId == 'test_assessment_1')
            .toList();
        expect(matchingItems.length, equals(1));
        expect(matchingItems.first.payload['updatedField'], equals('value'));
        expect(matchingItems.first.version, equals(2));
      },
    );

    test(
      'ConflictResolver handles timestamps and sensitive entity policies',
      () {
        const resolver = ConflictResolver();

        final localPayload = {'score': 10, 'updatedAt': '2026-08-27T10:00:00Z'};
        final remotePayload = {
          'score': 15,
          'updatedAt': '2026-08-27T09:00:00Z',
        };

        // 1. LastWriteWins (Local is newer)
        final result1 = resolver.resolvePayload(
          localPayload: localPayload,
          remotePayload: remotePayload,
          localUpdatedAt: DateTime.parse('2026-08-27T10:00:00Z'),
          remoteUpdatedAt: DateTime.parse('2026-08-27T09:00:00Z'),
        );

        expect(result1.wasConflict, isTrue);
        expect(result1.resolvedData['score'], equals(10));

        // 2. Sensitive Entity Policy (Flags manual review without overwriting)
        final sensitiveResult = resolver.resolvePayload(
          localPayload: localPayload,
          remotePayload: remotePayload,
          localUpdatedAt: DateTime.parse('2026-08-27T10:00:00Z'),
          remoteUpdatedAt: DateTime.parse('2026-08-27T09:00:00Z'),
          isSensitiveEntity: true,
        );

        expect(sensitiveResult.wasConflict, isTrue);
        expect(sensitiveResult.resolvedData['_conflictFlag'], isTrue);
        expect(
          sensitiveResult.resolvedData['_remoteState'],
          equals(remotePayload),
        );
      },
    );

    test(
      'DatabaseMigrationService runs version upgrade and Guest -> User migration',
      () async {
        final migrationService = DatabaseMigrationService();

        // Run Schema Migrations
        await migrationService.runMigrations();

        final settingsBox = Hive.box(HiveConfig.settingsBox);
        expect(
          settingsBox.get(DatabaseMigrationService.versionKey),
          equals(DatabaseMigrationService.currentDatabaseVersion),
        );

        // Save a Guest Assessment Record
        final repo = SampleRepo();
        final guestRecord = AssessmentRecord(
          id: 'guest_assessment_99',
          userId: 'guest',
          answers: {'dep1': 1},
          safetyAnswers: {'self_harm': false},
          createdAt: DateTime.now(),
        );
        await repo.save(guestRecord.id, guestRecord);

        // Perform Guest -> Registered User Migration
        final syncQueue = SyncQueueService();
        final migratedCount = await migrationService.migrateGuestDataToUser(
          guestId: 'guest',
          registeredUserId: 'user_newly_registered_456',
          syncQueue: syncQueue,
        );

        expect(migratedCount, greaterThanOrEqualTo(1));

        final updatedRecord = repo.get('guest_assessment_99');
        expect(updatedRecord, isNotNull);
        expect(updatedRecord!.userId, equals('user_newly_registered_456'));
      },
    );
  });
}
