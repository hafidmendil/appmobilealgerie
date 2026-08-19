import 'package:hive/hive.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/services/logger_service.dart';
import 'package:uuid/uuid.dart';

class DatabaseSeedService {
  static Future<void> seed() async {
    try {
      final encryptionCipher = await HiveConfig.getEncryptionCipher();

      final usersBox = await Hive.openBox<UserModel>(
        'users_box',
        encryptionCipher: encryptionCipher,
      );

      if (usersBox.isEmpty) {
        logger.i('Seeding database with initial data...');

        // 1. Seed Users
        final uuidGen = Uuid();

        final adminId = uuidGen.v4();
        final psyId = uuidGen.v4();
        final patientId = uuidGen.v4();
        final pendingPsyId = uuidGen.v4();

        final admin = UserModel(
          id: adminId,
          email: 'admin@neurosync.com',
          role: UserRole.admin,
          status: 'active',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now().subtract(const Duration(days: 30)),
          wilayaId: 'w16',
          prefSpiritual: true,
          hasCompletedInitialAssessment: true,
          name: 'Administrateur SIND',
        );

        final psy = UserModel(
          id: psyId,
          email: 'psy@neurosync.com',
          role: UserRole.psychologist,
          status: 'approved',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          updatedAt: DateTime.now().subtract(const Duration(days: 20)),
          wilayaId: 'w31',
          prefSpiritual: true,
          hasCompletedInitialAssessment: true,
          name: 'Dr. Expert',
        );

        final patient = UserModel(
          id: patientId,
          email: 'patient@neurosync.com',
          role: UserRole.user,
          status: 'active',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          updatedAt: DateTime.now().subtract(const Duration(days: 10)),
          wilayaId: 'w16',
          prefSpiritual: true,
          hasCompletedInitialAssessment: true,
          name: 'Utilisateur Test',
        );

        final pendingPsy = UserModel(
          id: pendingPsyId,
          email: 'new_psy@neurosync.com',
          role: UserRole.psychologist,
          status: 'pending',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          wilayaId: 'w25',
          prefSpiritual: false,
          hasCompletedInitialAssessment: false,
          name: 'Candidat Psy',
        );

        await usersBox.put(admin.id, admin);
        await usersBox.put(psy.id, psy);
        await usersBox.put(patient.id, patient);
        await usersBox.put(pendingPsy.id, pendingPsy);

        // 2. Seed Access Request
        final requestsBox = await Hive.openBox<AccessRequest>(
          'access_requests',
          encryptionCipher: encryptionCipher,
        );
        final request = AccessRequest(
          id: uuidGen.v4(),
          userId: patientId,
          professionalId: psyId,
          status: AccessRequestStatus.pending,
          createdAt: DateTime.now(),
          message: "Demande de suivi pour stress élevé.",
        );
        await requestsBox.put(request.id, request);

        logger.i('Database seeding completed successfully.');
      } else {
        logger.i('Database already contains data, skipping seed.');
      }
    } catch (e, stack) {
      logger.e('Failed to seed database', e, stack);
    }
  }
}
