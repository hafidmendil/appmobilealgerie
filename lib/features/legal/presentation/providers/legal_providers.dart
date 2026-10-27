import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/legal_repository.dart';
import '../../domain/engines/legal_orientation_engine.dart';
import '../../domain/engines/procedure_recommendation_engine.dart';
import '../../domain/models/legal_models.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';

final legalRepositoryProvider = Provider<HiveLegalRepository>((ref) {
  final repo = HiveLegalRepository();
  repo.initSeedDataIfNeeded();
  return repo;
});

final legalCategoriesProvider = Provider<List<LegalCategory>>((ref) {
  final repo = ref.watch(legalRepositoryProvider);
  return repo.getCategories();
});

final legalArticlesProvider = Provider<List<LegalArticle>>((ref) {
  final repo = ref.watch(legalRepositoryProvider);
  return repo.getArticles();
});

final legalProceduresProvider = Provider<List<LegalProcedure>>((ref) {
  final repo = ref.watch(legalRepositoryProvider);
  return repo.getProcedures();
});

final legalSourcesProvider = Provider<List<LegalSource>>((ref) {
  final repo = ref.watch(legalRepositoryProvider);
  return repo.getSources();
});

final legalVersionsProvider = Provider<List<LegalVersion>>((ref) {
  final repo = ref.watch(legalRepositoryProvider);
  return repo.getVersions();
});

final legalOrientationEngineProvider = Provider<LegalOrientationEngine>((ref) {
  return LegalOrientationEngine(
    procedureEngine: ProcedureRecommendationEngine(),
  );
});

// Questionnaire state notifier
class QuestionnaireNotifier extends StateNotifier<Map<String, dynamic>> {
  QuestionnaireNotifier() : super({});

  void updateAnswer(String key, dynamic value) {
    state = {...state, key: value};
  }

  void reset() {
    state = {};
  }
}

final legalQuestionnaireAnswersProvider =
    StateNotifierProvider<QuestionnaireNotifier, Map<String, dynamic>>((ref) {
      return QuestionnaireNotifier();
    });

// Computed Legal Orientation Result
final currentLegalOrientationResultProvider = Provider<LegalOrientationResult?>(
  (ref) {
    final answers = ref.watch(legalQuestionnaireAnswersProvider);
    if (answers.isEmpty) return null;

    final engine = ref.watch(legalOrientationEngineProvider);
    final categories = ref.watch(legalCategoriesProvider);
    final articles = ref.watch(legalArticlesProvider);
    final procedures = ref.watch(legalProceduresProvider);

    return engine.evaluate(
      userAnswers: answers,
      allCategories: categories,
      allArticles: articles,
      allProcedures: procedures,
    );
  },
);

// Consent Record Notifier
class ConsentNotifier extends StateNotifier<ConsentRecord?> {
  final Ref ref;

  ConsentNotifier(this.ref) : super(null);

  void prepareConsent({
    required List<String> dataTypes,
    required String purpose,
    required String recipientInstitution,
    required List<String> transmittedFields,
    required String actionToBePerformed,
    String retentionPeriod = '12 mois',
    String? assessmentId,
    String? reportId,
  }) {
    final authState = ref.read(authStateProvider);
    final userId = authState.value?.id;

    final consent = ConsentRecord(
      id: 'consent_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      assessmentId: assessmentId,
      reportId: reportId,
      dataTypes: dataTypes,
      purpose: purpose,
      recipientInstitution: recipientInstitution,
      transmittedFields: transmittedFields,
      retentionPeriod: retentionPeriod,
      actionToBePerformed: actionToBePerformed,
      grantedAt: DateTime.now(),
      consentVersion: '1.0-DZ',
      checksum: 'sha256_${DateTime.now().microsecondsSinceEpoch}',
    );

    state = consent;
  }

  Future<bool> confirmConsent() async {
    if (state == null) return false;
    final repo = ref.read(legalRepositoryProvider);
    await repo.saveConsent(state!);
    return true;
  }

  void clear() {
    state = null;
  }
}

final consentStateProvider =
    StateNotifierProvider<ConsentNotifier, ConsentRecord?>((ref) {
      return ConsentNotifier(ref);
    });

// Report Draft Notifier
class ReportDraftNotifier extends StateNotifier<ReportDraft?> {
  final Ref ref;

  ReportDraftNotifier(this.ref) : super(null);

  void initializeDraft({
    required Map<String, String> declaredFacts,
    required String summaryText,
    required ReportRecipient recipient,
    String? assessmentId,
  }) {
    final authState = ref.read(authStateProvider);
    final userId = authState.value?.id;

    final draft = ReportDraft(
      id: 'report_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      assessmentId: assessmentId,
      declaredFacts: declaredFacts,
      summaryText: summaryText,
      recipient: recipient,
      attachments: const [],
      status: LegalReportStatus.draft,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    state = draft;
  }

  void updateSummary(String newSummary) {
    if (state == null) return;
    state = state!.copyWith(summaryText: newSummary, updatedAt: DateTime.now());
  }

  void updateRecipient(ReportRecipient newRecipient) {
    if (state == null) return;
    state = state!.copyWith(recipient: newRecipient, updatedAt: DateTime.now());
  }

  void addAttachment(ReportAttachment attachment) {
    if (state == null) return;
    final updated = List<ReportAttachment>.from(state!.attachments)
      ..add(attachment);
    state = state!.copyWith(attachments: updated, updatedAt: DateTime.now());
  }

  void removeAttachment(String attachmentId) {
    if (state == null) return;
    final updated = state!.attachments
        .where((a) => a.id != attachmentId)
        .toList();
    state = state!.copyWith(attachments: updated, updatedAt: DateTime.now());
  }

  Future<void> confirmAndSave(String consentId) async {
    if (state == null) return;
    final confirmed = state!.copyWith(
      status: LegalReportStatus.userConfirmed,
      consentId: consentId,
      updatedAt: DateTime.now(),
    );
    state = confirmed;
    final repo = ref.read(legalRepositoryProvider);
    await repo.saveReportDraft(confirmed);
  }
}

final reportDraftStateProvider =
    StateNotifierProvider<ReportDraftNotifier, ReportDraft?>((ref) {
      return ReportDraftNotifier(ref);
    });
