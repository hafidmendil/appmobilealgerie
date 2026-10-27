import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:projetmascara/core/config/app_config.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/data/database_seed_service.dart';
import 'package:projetmascara/core/services/auth_repository_impl.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/services/hive_professional_repository.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/features/professional/models/session_request_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Map<String, String> mockSecureStorage = {};
  late Directory tempDir;

  setUpAll(() async {
    // Initialize AppConfig
    AppConfig.init(env: Environment.dev, enableDemoData: true);

    // Setup Temp directory for Hive
    tempDir = await Directory.systemTemp.createTemp('hive_test');

    // Setup Mock for PathProvider
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

    // Setup Mock for FlutterSecureStorage
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
            } else if (methodCall.method == 'deleteAll') {
              mockSecureStorage.clear();
              return null;
            }
            return null;
          },
        );

    // Register Adapters and open boxes using HiveConfig
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

  test('Seed and Login Test for Psychologist Account', () async {
    // Seed
    await DatabaseSeedService.seed(includeDemoData: true);

    final usersBox = Hive.box<UserModel>(HiveConfig.usersBox);
    print('--- Users in box: ${usersBox.length} ---');

    final email = 'dr.daoud.29@neurosync.dz';
    final password = 'NeuroSync2024!';

    final authRepo = HiveAuthRepository();
    final user = await authRepo.login(email, password);
    expect(user.email, email);
    expect(user.role, UserRole.psychologist);
    expect(user.status, 'approved');
  });

  test('offline seed does not create demo identities', () async {
    await Hive.box<UserModel>(HiveConfig.usersBox).clear();
    await Hive.box(HiveConfig.settingsBox).clear();

    await DatabaseSeedService.seed(includeDemoData: false);

    expect(Hive.box<UserModel>(HiveConfig.usersBox), isEmpty);
    await expectLater(
      HiveAuthRepository().register(
        email: 'utilisateur@institution.dz',
        password: 'MotDePasseUtilisateur!2026',
        role: UserRole.user,
      ),
      throwsStateError,
    );
  });

  test('first offline administrator can only be initialized once', () async {
    final authRepo = HiveAuthRepository();
    final administrator = await authRepo.initializeOfflineAdministrator(
      email: 'responsable@institution.dz',
      password: 'MotDePasseLocal!2026',
    );

    expect(administrator.role, UserRole.admin);
    expect(administrator.status, 'active');
    await expectLater(
      authRepo.initializeOfflineAdministrator(
        email: 'second@institution.dz',
        password: 'AutreMotDePasse!2026',
      ),
      throwsStateError,
    );
  });

  test('A suspended account is denied authentication', () async {
    await DatabaseSeedService.seed(includeDemoData: true);
    final usersBox = Hive.box<UserModel>(HiveConfig.usersBox);
    final existing = usersBox.values.firstWhere(
      (user) => user.email == 'user@example.com',
    );
    await usersBox.put(existing.id, existing.copyWith(status: 'suspended'));

    final authRepo = HiveAuthRepository();
    await expectLater(
      authRepo.login('user@example.com', 'NeuroSync2024!'),
      throwsException,
    );
  });

  test('a session request remains a local draft without creating access', () async {
    final sessions = Hive.box<SessionRequestModel>(
      HiveConfig.sessionRequestsBox,
    );
    final accessRequests = Hive.box<AccessRequest>(
      HiveConfig.accessRequestsBox,
    );
    await sessions.clear();
    await accessRequests.clear();

    final request = SessionRequestModel(
      id: 81001,
      userId: 31001,
      professionalId: 17,
      wilayaId: 29,
      requestedDate: DateTime(2026, 10, 1),
      consentGiven: true,
    );

    await HiveProfessionalRepository().submitSessionRequest(request);

    expect(sessions.get(request.id), isNotNull);
    expect(accessRequests.values, isEmpty);

    await HiveProfessionalRepository().updateSessionStatus(
      request.id,
      SessionRequestStatus.ACCEPTED,
    );
    expect(accessRequests.values, isEmpty);
  });
}
