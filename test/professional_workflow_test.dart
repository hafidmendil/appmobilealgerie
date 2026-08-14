import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/core/services/mock_professional_service.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:hive/hive.dart';
import 'package:projetmascara/core/config/app_config.dart';

void _registerAdapters() {
  try {
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(UserModelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(AccessRequestStatusAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(AccessRequestAdapter());
    if (!Hive.isAdapterRegistered(8)) Hive.registerAdapter(UserRoleAdapter());
  } catch (_) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockProfessionalService service;
  final tempDir = Directory.systemTemp.createTempSync('hive_test');

  setUpAll(() {
    AppConfig.init(env: Environment.dev);
  });

  setUp(() async {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
    tempDir.createSync(recursive: true);
    Hive.init(tempDir.path);
    
    _registerAdapters();

    service = MockProfessionalService();
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Professional Workflow Tests', () {
    test('AccessRequest lifecycle: send, respond, and authorization', () async {
      const psychologistId = 'psy1';
      const patientId = 'pat1';

      // 1. Initial state: No patients authorized
      var patients = await service.getAuthorizedPatients(psychologistId);
      expect(patients, isEmpty);

      // 2. Send request
      await service.sendRequest(userId: patientId, professionalId: psychologistId);
      var requests = await service.getRequestsForPsychologist(psychologistId);
      expect(requests.length, 1);
      expect(requests.first.status, AccessRequestStatus.pending);

      // Still no authorized patients
      patients = await service.getAuthorizedPatients(psychologistId);
      expect(patients, isEmpty);

      // 3. Accept request
      await service.respondToRequest(requests.first.id, AccessRequestStatus.accepted);
      
      // Setup mock patient in users box
      final userBox = await Hive.openBox<UserModel>('users');
      final patient = UserModel(
        id: patientId,
        email: 'patient@test.com',
        role: UserRole.user,
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await userBox.put(patientId, patient);

      // Now patient should be authorized
      patients = await service.getAuthorizedPatients(psychologistId);
      expect(patients.length, 1);
      expect(patients.first.id, patientId);

      // Check specific patient access
      final fetchedPatient = await service.getPatientById(psychologistId, patientId);
      expect(fetchedPatient, isNotNull);
      expect(fetchedPatient!.email, 'patient@test.com');

      // 4. Revoke/Reject
      await service.respondToRequest(requests.first.id, AccessRequestStatus.rejected);
      patients = await service.getAuthorizedPatients(psychologistId);
      expect(patients, isEmpty);
      
      final deniedPatient = await service.getPatientById(psychologistId, patientId);
      expect(deniedPatient, isNull);
    });

    group('Security Guards', () {
      test('Psychologist cannot see non-authorized patients', () async {
        const psychologistId = 'psy1';
        const strangerId = 'stranger1';
        
        final userBox = await Hive.openBox<UserModel>('users');
        await userBox.put(strangerId, UserModel(
          id: strangerId,
          email: 'stranger@test.com',
          role: UserRole.user,
          status: 'active',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));

        final patient = await service.getPatientById(psychologistId, strangerId);
        expect(patient, isNull);
      });
    });
  });
}
