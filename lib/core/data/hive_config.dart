import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/services/secure_storage_service.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/features/professional/models/session_request_model.dart';
import 'package:projetmascara/core/services/logger_service.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/core/models/sync_item.dart';
import 'package:projetmascara/features/professional/models/professional_profile.dart';
import 'package:projetmascara/core/models/admin/security_log.dart';
import 'package:projetmascara/features/wellness/models/confidence_entry.dart';
import 'package:projetmascara/features/health/models/health_knowledge_item.dart';
import 'package:projetmascara/features/health/models/health_learning_progress.dart';
import 'package:projetmascara/features/progress/domain/models/user_stats.dart';
import 'package:projetmascara/features/team/models/project_member.dart';
import 'package:projetmascara/features/messaging/models/message_model.dart';
import 'package:projetmascara/features/professional/models/chat_message_adapter.dart';
import 'package:projetmascara/core/models/admin/content_models.dart';

class HiveConfig {
  static const String _encryptionKey = 'hive_encryption_key';

  // Existing Box names preserved
  static const String usersBox = 'users_box';
  static const String quranBox = 'quran_box';
  static const String hadithBox = 'hadith_box';
  static const String assessmentResultsBox = 'assessments';
  static const String accessRequestsBox = 'access_requests';
  static const String syncQueueBox = 'sync_queue';
  static const String profilesBox = 'professional_profiles';
  static const String sessionRequestsBox = 'session_requests';
  static const String securityLogsBox = 'security_logs';
  static const String wilayasBox = 'wilayas';
  static const String settingsBox = 'settings';
  static const String userStatsBox = 'user_stats_box';
  static const String authBox = 'auth_box';
  static const String assessmentDraftBox = 'assessment_draft';
  static const String confidenceBox = 'confidence_box';
  static const String healthKnowledgeBox = 'health_knowledge_box';
  static const String healthProgressBox = 'health_progress_box';
  static const String teamMembersBox = 'team_members_box';
  static const String messagesBox = 'messages_box';
  static const String protectionReportsBox = 'reports_box';
  static const String protectionRiskAssessmentsBox = 'risk_assessments_box';
  static const String protectionReferralsBox = 'referrals_box';
  static const String protectionSafetyPlansBox = 'safety_plans_box';
  static const String protectionAuditBox = 'protection_audit_box';
  static const String protectionSettingsBox = 'protection_settings_box';
  static const String voiceNotesBox = 'voice_notes_box';
  static const String institutionalControlsBox = 'institutional_controls_box';

  // Standardized & Normalized New Feature Boxes (Prompt Section 3)
  static const String violenceCasesBox = 'violence_cases';
  static const String violenceAssessmentsBox = 'violence_assessments';
  static const String riskAssessmentsBox = 'risk_assessments';
  static const String specialistBox = 'specialists';
  static const String partnerBox = 'partners';
  static const String referralBox = 'referrals';
  static const String legalArticlesBox = 'legal_articles';
  static const String legalAssessmentsBox = 'legal_assessments';
  static const String consentBox = 'user_consents';
  static const String reportsBox = 'reports';
  static const String notificationsBox = 'notifications';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    _registerAdapters();

    // Open Essential & Feature Boxes
    await _openBoxes();

    logger.i('Hive initialized successfully with unified data layer boxes');
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(UserRoleAdapter().typeId)) {
      Hive.registerAdapter(UserRoleAdapter());
    }
    if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(AccessRequestStatusAdapter().typeId)) {
      Hive.registerAdapter(AccessRequestStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(AccessRequestAdapter().typeId)) {
      Hive.registerAdapter(AccessRequestAdapter());
    }
    if (!Hive.isAdapterRegistered(SyncOperationAdapter().typeId)) {
      Hive.registerAdapter(SyncOperationAdapter());
    }
    if (!Hive.isAdapterRegistered(SyncStatusAdapter().typeId)) {
      Hive.registerAdapter(SyncStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(SyncItemAdapter().typeId)) {
      Hive.registerAdapter(SyncItemAdapter());
    }
    if (!Hive.isAdapterRegistered(ProfessionalProfileAdapter().typeId)) {
      Hive.registerAdapter(ProfessionalProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(QuranVerseModelAdapter().typeId)) {
      Hive.registerAdapter(QuranVerseModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HadithModelAdapter().typeId)) {
      Hive.registerAdapter(HadithModelAdapter());
    }
    if (!Hive.isAdapterRegistered(SecurityLogAdapter().typeId)) {
      Hive.registerAdapter(SecurityLogAdapter());
    }
    if (!Hive.isAdapterRegistered(ProfessionalSpecialtyAdapter().typeId)) {
      Hive.registerAdapter(ProfessionalSpecialtyAdapter());
    }
    if (!Hive.isAdapterRegistered(ConfidenceEntryAdapter().typeId)) {
      Hive.registerAdapter(ConfidenceEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(EvidenceLevelAdapter().typeId)) {
      Hive.registerAdapter(EvidenceLevelAdapter());
    }
    if (!Hive.isAdapterRegistered(HealthCategoryAdapter().typeId)) {
      Hive.registerAdapter(HealthCategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(HealthKnowledgeItemAdapter().typeId)) {
      Hive.registerAdapter(HealthKnowledgeItemAdapter());
    }
    if (!Hive.isAdapterRegistered(LearningLevelAdapter().typeId)) {
      Hive.registerAdapter(LearningLevelAdapter());
    }
    if (!Hive.isAdapterRegistered(HealthLearningProgressAdapter().typeId)) {
      Hive.registerAdapter(HealthLearningProgressAdapter());
    }
    if (!Hive.isAdapterRegistered(AssessmentRecordAdapter().typeId)) {
      Hive.registerAdapter(AssessmentRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(SessionRequestStatusAdapter().typeId)) {
      Hive.registerAdapter(SessionRequestStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(SessionRequestModelAdapter().typeId)) {
      Hive.registerAdapter(SessionRequestModelAdapter());
    }
    if (!Hive.isAdapterRegistered(ProjectMemberAdapter().typeId)) {
      Hive.registerAdapter(ProjectMemberAdapter());
    }
    if (!Hive.isAdapterRegistered(UserStatsAdapter().typeId)) {
      Hive.registerAdapter(UserStatsAdapter());
    }
    // Messaging adapters
    if (!Hive.isAdapterRegistered(200)) {
      Hive.registerAdapter(MessageModelAdapter());
    }
    if (!Hive.isAdapterRegistered(201)) {
      Hive.registerAdapter(ChatMessageAdapter());
    }
  }

  static Future<void> _openBoxes() async {
    final cipher = await getEncryptionCipher();

    await Hive.openBox<UserModel>(usersBox, encryptionCipher: cipher);
    await Hive.openBox<MessageModel>(messagesBox, encryptionCipher: cipher);
    await Hive.openBox<AssessmentRecord>(
      assessmentResultsBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<AccessRequest>(
      accessRequestsBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<SyncItem>(syncQueueBox, encryptionCipher: cipher);
    await Hive.openBox<ProfessionalProfile>(
      profilesBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<SessionRequestModel>(
      sessionRequestsBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<SecurityLog>(securityLogsBox, encryptionCipher: cipher);
    await Hive.openBox(wilayasBox);
    await Hive.openBox(settingsBox);
    await Hive.openBox<UserStats>(userStatsBox, encryptionCipher: cipher);
    await Hive.openBox(authBox, encryptionCipher: cipher);
    await Hive.openBox(assessmentDraftBox, encryptionCipher: cipher);
    await Hive.openBox<ConfidenceEntry>(
      confidenceBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<HealthKnowledgeItem>(
      healthKnowledgeBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<HealthLearningProgress>(
      healthProgressBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<ProjectMember>(teamMembersBox, encryptionCipher: cipher);
    await Hive.openBox<QuranVerseModel>(quranBox, encryptionCipher: cipher);
    await Hive.openBox<HadithModel>(hadithBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(protectionReportsBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(
      protectionRiskAssessmentsBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<dynamic>(
      protectionReferralsBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<dynamic>(
      protectionSafetyPlansBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<dynamic>(protectionAuditBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(
      protectionSettingsBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<dynamic>(voiceNotesBox, encryptionCipher: cipher);

    // Open Standardized Feature Boxes
    await Hive.openBox<dynamic>(violenceCasesBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(
      violenceAssessmentsBox,
      encryptionCipher: cipher,
    );
    await Hive.openBox<dynamic>(riskAssessmentsBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(specialistBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(partnerBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(referralBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(legalArticlesBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(legalAssessmentsBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(consentBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(reportsBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(notificationsBox, encryptionCipher: cipher);
    await Hive.openBox<dynamic>(
      institutionalControlsBox,
      encryptionCipher: cipher,
    );
  }

  static Future<void> deleteAllData() async {
    try {
      await Hive.deleteFromDisk();
      await init(); // Re-initialize after deletion
      logger.i('All local data deleted successfully');
    } catch (e) {
      logger.e('Error deleting all local data: $e');
      rethrow;
    }
  }

  static Future<HiveCipher?> getEncryptionCipher() async {
    final secureStorage = SecureStorageService();
    String? key = await secureStorage.read(_encryptionKey);

    if (key == null) {
      final newKey = Hive.generateSecureKey();
      await secureStorage.write(_encryptionKey, base64UrlEncode(newKey));
      key = base64UrlEncode(newKey);
      logger.i('Generated new encryption key for Hive');
    }

    return HiveAesCipher(base64Url.decode(key));
  }
}
