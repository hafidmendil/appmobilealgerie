import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/config/app_config.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/features/professional/models/professional_profile.dart';
import 'package:projetmascara/features/health/models/health_knowledge_item.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/data/neurosync_data.dart';
import 'package:projetmascara/core/services/logger_service.dart';
import 'package:projetmascara/core/services/secure_storage_service.dart';
import 'package:projetmascara/core/services/local_care_repository.dart';
import 'package:uuid/uuid.dart';

import 'package:projetmascara/features/content/quran_library.dart';
import 'package:projetmascara/features/content/hadith_library.dart';
import 'package:projetmascara/core/models/admin/content_models.dart';

class DatabaseSeedService {
  /// Seeds educational content only by default. Demo accounts and fictional
  /// partner records are limited to explicit test/demo runs and are never
  /// created in the offline professional application.
  static Future<void> seed({bool? includeDemoData}) async {
    try {
      final usersBox = Hive.box<UserModel>(HiveConfig.usersBox);
      final profilesBox = Hive.box<ProfessionalProfile>(HiveConfig.profilesBox);
      final healthBox = Hive.box<HealthKnowledgeItem>(
        HiveConfig.healthKnowledgeBox,
      );
      final quranBox = Hive.box<QuranVerseModel>(HiveConfig.quranBox);
      final hadithBox = Hive.box<HadithModel>(HiveConfig.hadithBox);
      final shouldSeedInitialData = usersBox.isEmpty;
      final seedDemoData = includeDemoData ?? AppConfig.instance.enableDemoData;

      if (seedDemoData) {
        await _syncNeuroSyncAccounts(usersBox, profilesBox);
      }

      if (shouldSeedInitialData) {
        logger.i('Seeding database with NeuroSync content...');
        // Seed Realistic Health Knowledge
        final healthItems = [
          HealthKnowledgeItem(
            id: 'h1',
            title: 'Bienfaits du Miel en Santé Mentale',
            arabicTitle: 'فوائد العسل في الصحة النفسية',
            description:
                'Le miel est reconnu pour ses propriétés neuroprotectrices et sa capacité à réduire l\'anxiété. Des études récentes montrent son impact positif sur la plasticité neuronale.',
            category: HealthCategory.propheticMedicine,
            evidenceLevel: EvidenceLevel.academicResearch,
            benefits: [
              'Réduction du stress oxydatif',
              'Amélioration de la qualité du sommeil',
              'Soutien cognitif',
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            sourceStatus: 'VERIFIED',
          ),
          HealthKnowledgeItem(
            id: 'h2',
            title: 'La Résilience (Sabr) et Santé Mentale',
            arabicTitle: 'المرونة النفسية و الصبر',
            description:
                'Étude sur le concept de Sabr comme mécanisme d\'adaptation actif face aux crises, validé par la psychologie positive moderne.',
            category: HealthCategory.psychologicalWellbeing,
            evidenceLevel: EvidenceLevel.religiousSource,
            benefits: [
              'Renforcement psychologique',
              'Gestion émotionnelle',
              'Espérance active',
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            sourceStatus: 'VERIFIED',
          ),
        ];

        for (var item in healthItems) {
          await healthBox.put(item.id, item);
        }

        // Seed Quran and Hadith into DB
        if (quranBox.isEmpty) {
          for (var v in quranLibrary) {
            await quranBox.put(
              v.id,
              QuranVerseModel(
                id: v.id,
                surahNumber: v.surahNumber,
                verseNumber: v.verseNumber,
                textAr: v.textAr,
                textFr: v.textFr,
                theme: v.theme,
              ),
            );
          }
        }

        if (hadithBox.isEmpty) {
          for (var h in hadithLibrary) {
            await hadithBox.put(
              h.id,
              HadithModel(
                id: h.id,
                collection: h.collection,
                number: h.number,
                textAr: h.textAr,
                textFr: h.textFr,
                theme: h.theme,
              ),
            );
          }
        }

        logger.i(
          'Database seeding completed successfully with full libraries.',
        );
      }

      if (seedDemoData) {
        await _ensureDemoAccounts(usersBox, profilesBox);
        await _seedPartnerNetwork(usersBox, profilesBox);
      }
      await _syncContentLibraries(quranBox, hadithBox);
    } catch (e, stack) {
      logger.e('Failed to seed database', e, stack);
    }
  }

  static Future<void> _syncNeuroSyncAccounts(
    Box<UserModel> usersBox,
    Box<ProfessionalProfile> profilesBox,
  ) async {
    final settingsBox = Hive.box(HiveConfig.settingsBox);
    final alreadySeeded = settingsBox.get(
      'neurosync_accounts_seeded',
      defaultValue: false,
    );
    if (alreadySeeded) {
      logger.i(
        'DatabaseSeedService: NeuroSync accounts already seeded, skipping.',
      );
      return;
    }

    final uuidGen = const Uuid();
    final secureStorage = SecureStorageService();
    final passwordHash = base64UrlEncode(
      sha256.convert(utf8.encode('NeuroSync2024!')).bytes,
    );

    logger.i(
      'DatabaseSeedService: Seeding 232 NeuroSync psychologist accounts...',
    );
    for (final account in neuroSyncAccounts) {
      final userId = uuidGen.v5(Uuid.NAMESPACE_URL, account.email);
      final existing = usersBox.get(userId);
      final user = existing == null
          ? UserModel(
              id: userId,
              email: account.email,
              role: UserRole.psychologist,
              status: 'approved',
              createdAt: DateTime.now().subtract(const Duration(days: 60)),
              updatedAt: DateTime.now().subtract(const Duration(days: 60)),
              wilayaId: 'w${account.wilayaCode}',
              name: account.fullName,
              hasCompletedInitialAssessment: true,
            )
          : existing.copyWith(
              email: account.email,
              role: UserRole.psychologist,
              status: 'approved',
              wilayaId: 'w${account.wilayaCode}',
              name: account.fullName,
              hasCompletedInitialAssessment: true,
              updatedAt: DateTime.now(),
            );
      await usersBox.put(userId, user);
      await secureStorage.write(
        'pw_${account.email.toLowerCase()}',
        passwordHash,
      );

      final profile = profilesBox.get(userId);
      if (profile == null || !profile.isApproved) {
        await profilesBox.put(
          userId,
          ProfessionalProfile(
            id: userId,
            userId: userId,
            fullName: account.fullName,
            specialty: ProfessionalSpecialty.psychologist,
            description:
                "Psychologue clinicien spécialisé dans l'accompagnement des traumatismes et de la résilience à ${account.wilaya}.",
            location: account.wilaya,
            languages: const ['fr', 'ar'],
            createdAt: DateTime.now().subtract(const Duration(days: 60)),
            isApproved: true,
          ),
        );
      }
    }

    await settingsBox.put('neurosync_accounts_seeded', true);
    logger.i(
      'DatabaseSeedService: Seeding of 232 NeuroSync accounts completed.',
    );
  }

  static Future<void> _syncContentLibraries(
    Box<QuranVerseModel> quranBox,
    Box<HadithModel> hadithBox,
  ) async {
    final quranIds = quranLibrary.map((verse) => verse.id).toSet();
    for (final key in quranBox.keys.toList()) {
      if (!quranIds.contains(key.toString())) await quranBox.delete(key);
    }
    for (final verse in quranLibrary) {
      await quranBox.put(
        verse.id,
        QuranVerseModel(
          id: verse.id,
          surahNumber: verse.surahNumber,
          verseNumber: verse.verseNumber,
          textAr: verse.textAr,
          textFr: verse.textFr,
          theme: verse.theme,
          context: verse.context,
          reflection: verse.reflection,
        ),
      );
    }

    final hadithIds = hadithLibrary.map((hadith) => hadith.id).toSet();
    for (final key in hadithBox.keys.toList()) {
      if (!hadithIds.contains(key.toString())) await hadithBox.delete(key);
    }
    for (final hadith in hadithLibrary) {
      await hadithBox.put(
        hadith.id,
        HadithModel(
          id: hadith.id,
          collection: hadith.collection,
          number: hadith.number,
          textAr: hadith.textAr,
          textFr: hadith.textFr,
          theme: hadith.theme,
          source: hadith.source,
        ),
      );
    }
  }

  static Future<void> _ensureDemoAccounts(
    Box<UserModel> usersBox,
    Box<ProfessionalProfile> profilesBox,
  ) async {
    const password = 'NeuroSync2024!';
    final secureStorage = SecureStorageService();
    final passwordHash = base64UrlEncode(
      sha256.convert(utf8.encode(password)).bytes,
    );
    final uuidGen = const Uuid();

    Future<void> ensurePassword(String email) async {
      final existing = await secureStorage.read('pw_${email.toLowerCase()}');
      if (existing == null) {
        await secureStorage.write('pw_${email.toLowerCase()}', passwordHash);
      }
    }

    Future<UserModel> ensureUser({
      required String email,
      required UserRole role,
      required String status,
      required String name,
    }) async {
      UserModel? existing;
      for (final user in usersBox.values) {
        if (user.email.toLowerCase() == email.toLowerCase()) {
          existing = user;
          break;
        }
      }
      final user =
          existing ??
          UserModel(
            id: uuidGen.v5(Uuid.NAMESPACE_URL, email),
            email: email,
            role: role,
            status: status,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            wilayaId: 'w16',
            name: name,
          );
      await usersBox.put(user.id, user);
      await ensurePassword(email);
      return user;
    }

    await ensureUser(
      email: 'admin@neurosync.dz',
      role: UserRole.admin,
      status: 'active',
      name: 'Administrateur NeuroSync',
    );
    await ensureUser(
      email: 'user@example.com',
      role: UserRole.user,
      status: 'active',
      name: 'Utilisateur de démonstration',
    );
    final psychologist = await ensureUser(
      email: 'psy@example.com',
      role: UserRole.psychologist,
      status: 'approved',
      name: 'Psychologue de démonstration',
    );

    // Guard against corrupted Hive data (e.g. SyncStatus objects stored in
    // the profiles box due to a past adapter-id collision).  If iteration
    // fails we simply recreate the demo profile.
    bool profileExists = false;
    try {
      profileExists = profilesBox.values.any(
        (profile) => profile.userId == psychologist.id,
      );
    } catch (_) {
      // Box contains non-ProfessionalProfile entries – clear them out.
      logger.w('profilesBox contains corrupted entries, cleaning up...');
      final badKeys = <dynamic>[];
      for (final key in profilesBox.keys) {
        try {
          profilesBox.get(key);
        } catch (_) {
          badKeys.add(key);
        }
      }
      for (final key in badKeys) {
        await profilesBox.delete(key);
      }
    }
    if (!profileExists) {
      await profilesBox.put(
        psychologist.id,
        ProfessionalProfile(
          id: psychologist.id,
          userId: psychologist.id,
          fullName: psychologist.name ?? 'Psychologue de démonstration',
          specialty: ProfessionalSpecialty.psychologist,
          description: 'Compte professionnel de démonstration.',
          location: 'Alger',
          languages: const ['fr', 'ar'],
          createdAt: DateTime.now(),
          isApproved: true,
        ),
      );
    }
  }

  /// Demo network records make the orientation flow usable from the first
  /// launch. Each directory profile is linked to a real local professional
  /// account, but that relationship does not grant access to referrals: this
  /// version never transmits a person's data to a partner.
  static Future<void> _seedPartnerNetwork(
    Box<UserModel> usersBox,
    Box<ProfessionalProfile> profilesBox,
  ) async {
    const password = 'NeuroSync2024!';
    final passwordHash = base64UrlEncode(
      sha256.convert(utf8.encode(password)).bytes,
    );
    final secureStorage = SecureStorageService();
    final uuidGen = const Uuid();
    final repository = LocalCareRepository();
    const partners = [
      {
        'id': 'partner-alger-psychology',
        'email': 'centre.alger@neurosync.dz',
        'name': 'Centre d’écoute El Aman — Alger',
        'specialty': 'psychologist',
        'wilaya': 'w16',
        'location': 'Alger',
        'contact': 'Accueil local sur rendez-vous',
        'situations': ['vulnerability', 'actor', 'witness', 'victim'],
        'risks': ['low', 'moderate', 'high'],
      },
      {
        'id': 'partner-oran-social',
        'email': 'ecoute.oran@neurosync.dz',
        'name': 'Point d’écoute et médiation — Oran',
        'specialty': 'socialWorker',
        'wilaya': 'w31',
        'location': 'Oran',
        'contact': 'Accueil local sur rendez-vous',
        'situations': ['witness', 'victim', 'actor'],
        'risks': ['low', 'moderate', 'high'],
      },
      {
        'id': 'partner-constantine-legal',
        'email': 'orientation.constantine@neurosync.dz',
        'name': 'Orientation et droits — Constantine',
        'specialty': 'legalSupport',
        'wilaya': 'w25',
        'location': 'Constantine',
        'contact': 'Information locale sur rendez-vous',
        'situations': ['witness', 'victim'],
        'risks': ['low', 'moderate'],
      },
      {
        'id': 'partner-blida-family',
        'email': 'accompagnement.blida@neurosync.dz',
        'name': 'Accompagnement familial — Blida',
        'specialty': 'psychologist',
        'wilaya': 'w09',
        'location': 'Blida',
        'contact': 'Accueil local sur rendez-vous',
        'situations': ['actor', 'witness', 'vulnerability'],
        'risks': ['low', 'moderate'],
      },
    ];

    for (final item in partners) {
      final email = item['email']! as String;
      final userId = uuidGen.v5(Uuid.NAMESPACE_URL, email);
      final existing = usersBox.get(userId);
      final user = existing == null
          ? UserModel(
              id: userId,
              email: email,
              role: UserRole.psychologist,
              status: 'approved',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              wilayaId: item['wilaya']! as String,
              name: item['name']! as String,
              hasCompletedInitialAssessment: true,
            )
          : existing.copyWith(
              role: UserRole.psychologist,
              status: 'approved',
              wilayaId: item['wilaya']! as String,
              name: item['name']! as String,
              updatedAt: DateTime.now(),
            );
      await usersBox.put(userId, user);
      await secureStorage.write('pw_${email.toLowerCase()}', passwordHash);

      if (profilesBox.get(userId) == null) {
        await profilesBox.put(
          userId,
          ProfessionalProfile(
            id: userId,
            userId: userId,
            fullName: item['name']! as String,
            specialty: ProfessionalSpecialty.psychologist,
            description:
                'Compte partenaire local de démonstration. Il ne reçoit aucune donnée sans consentement et transmission explicite.',
            location: item['location']! as String,
            languages: const ['fr', 'ar'],
            createdAt: DateTime.now(),
            isApproved: true,
          ),
        );
      }

      await repository.savePartner(
        id: item['id']! as String,
        name: item['name']! as String,
        type: item['specialty']! as String,
        specialty: item['specialty']! as String,
        wilayaId: item['wilaya']! as String,
        contact: item['contact']! as String,
        availability: 'available',
        services: const ['orientation locale', 'information'],
        supportedSituations: List<String>.from(item['situations']! as List),
        supportedRiskLevels: List<String>.from(item['risks']! as List),
        verified: true,
        status: 'approved',
        accountUserId: userId,
        actorId: 'seed',
      );
    }
  }
}
