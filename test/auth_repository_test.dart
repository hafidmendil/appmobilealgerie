import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/services/mock_auth_service.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/config/app_config.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final Map<String, String> values = {};

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'read':
        return values[methodCall.arguments['key']];
      case 'write':
        values[methodCall.arguments['key']] = methodCall.arguments['value'];
        return null;
      case 'delete':
        values.remove(methodCall.arguments['key']);
        return null;
      case 'deleteAll':
        values.clear();
        return null;
      case 'readAll':
        return values;
      default:
        return null;
    }
  });

  late MockAuthService authService;
  final tempDir = Directory.systemTemp.createTempSync();

  setUpAll(() async {
    Hive.init(tempDir.path);
    Hive.registerAdapter(UserRoleAdapter());
    Hive.registerAdapter(UserModelAdapter());
    AppConfig.init(env: Environment.dev);
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  setUp(() {
    authService = MockAuthService();
  });

  group('MockAuthService Tests', () {
    test('Login should return a user and update stream', () async {
      // First register, because MockAuthService now checks users_box
      await authService.register(
        email: 'test@user.com',
        password: 'password',
        role: UserRole.user,
      );

      final user = await authService.login('test@user.com', 'password');
      expect(user.email, equals('test@user.com'));
      expect(user.role, equals(UserRole.user));

      final currentUser = await authService.getCurrentUser();
      expect(currentUser?.id, equals(user.id));
    });

    test('Login with admin email should return admin role', () async {
      await authService.register(
        email: 'admin@test.com',
        password: 'password',
        role: UserRole.admin,
      );

      final user = await authService.login('admin@test.com', 'password');
      expect(user.role, equals(UserRole.admin));
    });

    test('Logout should clear current user', () async {
      // Register then Login
      await authService.register(
        email: 'logout@test.com',
        password: 'password',
        role: UserRole.user,
      );
      await authService.login('logout@test.com', 'password');

      await authService.logout();
      final currentUser = await authService.getCurrentUser();
      expect(currentUser, isNull);
    });
  });
}
