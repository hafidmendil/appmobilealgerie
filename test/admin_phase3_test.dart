import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/services/admin/mock_admin_service.dart';
import 'package:projetmascara/core/services/admin/mock_security_log_service.dart';
import 'package:projetmascara/core/models/admin/security_log.dart';
import 'package:projetmascara/core/config/app_config.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAdminService adminService;
  late MockSecurityLogService logService;

  const MethodChannel channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  setUpAll(() async {
    final mockKey = base64UrlEncode(List<int>.generate(32, (i) => i));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'read') return mockKey;
      if (methodCall.method == 'write') return null;
      return null;
    });

    AppConfig.init(env: Environment.dev);
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    Hive.registerAdapter(UserRoleAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(SecurityLogAdapter());
  });

  setUp(() {
    adminService = MockAdminService();
    logService = MockSecurityLogService();
  });

  tearDown(() async {
    // We can't easily clear specific boxes without opening them again, 
    // but setUpAll uses a fresh temp dir for each run.
  });

  test('AdminRepository should return global statistics', () async {
    final stats = await adminService.getGlobalStatistics();
    expect(stats, contains('totalUsers'));
    expect(stats, contains('totalAssessments'));
  });

  test('SecurityLogRepository should persist and retrieve logs', () async {
    final log = SecurityLog(
      id: '1',
      actorId: 'admin1',
      actorRole: 'admin',
      action: 'test_action',
      timestamp: DateTime.now(),
      status: 'success',
    );

    await logService.logEvent(log);
    final logs = await logService.getLogs();
    
    expect(logs.length, 1);
    expect(logs.first.action, 'test_action');
  });

  test('AdminService should filter professionals correctly', () async {
    final pros = await adminService.getProfessionals();
    expect(pros, isA<List<UserModel>>());
  });
}
