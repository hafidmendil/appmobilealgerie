import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:projetmascara/core/services/sync_service.dart';
import 'package:projetmascara/core/data/remote_data_source.dart';
import 'package:projetmascara/core/models/sync_item.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';

import 'sync_service_unit_test.mocks.dart';

@GenerateMocks([AssessmentRemoteDataSource, ProfessionalRemoteDataSource])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SyncService syncService;
  late MockAssessmentRemoteDataSource mockAssessmentRemote;
  late MockProfessionalRemoteDataSource mockProfessionalRemote;

  const MethodChannel channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  setUpAll(() async {
    final mockKey = base64UrlEncode(List<int>.generate(32, (i) => i));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'read') return mockKey;
      if (methodCall.method == 'write') return null;
      return null;
    });

    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(SyncOperationAdapter().typeId)) {
      Hive.registerAdapter(SyncOperationAdapter());
    }
    if (!Hive.isAdapterRegistered(SyncItemAdapter().typeId)) {
      Hive.registerAdapter(SyncItemAdapter());
    }
  });

  setUp(() {
    mockAssessmentRemote = MockAssessmentRemoteDataSource();
    mockProfessionalRemote = MockProfessionalRemoteDataSource();
    syncService = SyncService(
      assessmentRemote: mockAssessmentRemote,
      professionalRemote: mockProfessionalRemote,
    );
  });

  test('SyncService should add item to queue', () async {
    await syncService.addToQueue(
      'assessment',
      SyncOperation.create,
      {
        'userId': 'user123',
        'answers': {'Q1': 1},
        'safetyAnswers': {'S1': false},
        'createdAt': DateTime.now().toIso8601String(),
        'finalMessage': 'Test message'
      },
    );

    final box = await Hive.openBox<SyncItem>('sync_queue');
    expect(box.length, 1);
    expect(box.values.first.type, 'assessment');
  });
}
