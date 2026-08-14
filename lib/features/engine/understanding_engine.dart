import '../assessment/assessment_models.dart';
import 'free_text_analysis_model.dart';

class UnderstandingEngine {
  /// Analyzes free text to identify themes and states.
  /// In a production app, this would use NLP. Here we implement a structured keyword-based engine
  /// that respects the "Declared by User" principle.
  static FreeTextAnalysis analyze(String text, {bool spiritualEnabled = false, String? wilaya}) {
    final normalized = text.toLowerCase();
    final domains = <QuestionModule>{};
    final states = <DeclaredState>{};
    final concerns = <String>[];
    bool safety = false;

    // 1. Keyword Mapping (French & Arabic samples)
    
    // Stress / Overload
    if (_containsAny(normalized, ['stress', 'pression', 'chargé', 'surcharge', 'ضغوط', 'قلق', 'إرهاق', 'overload', 'burnout'])) {
      domains.add(QuestionModule.stress);
      states.add(DeclaredState.stress);
      states.add(DeclaredState.overload);
    }

    // Academic / Studies
    if (_containsAny(normalized, ['études', 'université', 'examen', 'réussir', 'دراسة', 'جامعة', 'امتحان', 'revision', 'bac', 'master', 'professeur'])) {
      domains.add(QuestionModule.dailyPressures);
      states.add(DeclaredState.academicDifficulty);
      concerns.add('academic_pressure');
    }

    // Social / Loneliness
    if (_containsAny(normalized, ['seul', 'solitude', 'isolement', 'personne', 'وحيد', 'عزلة', 'lonely', 'isolated'])) {
      domains.add(QuestionModule.social);
      states.add(DeclaredState.isolated);
      concerns.add('social_isolation');
    }

    // Family
    if (_containsAny(normalized, ['famille', 'parents', 'maison', 'conflit', 'عائلة', 'والدين', 'صراع', 'dispute', 'problème familial'])) {
      domains.add(QuestionModule.relationship);
      states.add(DeclaredState.familyConflict);
    }

    // Health / Medical
    if (_containsAny(normalized, ['malade', 'maladie', 'traitement', 'médecin', 'médicament', 'مريض', 'مرض', 'علاج'])) {
      states.add(DeclaredState.medicalCondition);
    }

    // Motivation / Meaning
    if (_containsAny(normalized, ['sens', 'pourquoi', 'foi', 'dieu', 'allah', 'إيمان', 'معنى', 'motivation', 'envie', 'fatigue', 'espoir', 'désespoir'])) {
      domains.add(QuestionModule.spiritual);
      states.add(DeclaredState.seekingMeaning);
      states.add(DeclaredState.lackOfMotivation);
    }

    // Already followed
    if (_containsAny(normalized, ['déjà suivi', 'mon psy', 'mon médecin', 'أتابع', 'طبيبي'])) {
      states.add(DeclaredState.alreadyFollowed);
    }

    // Safety / Urgency
    if (_containsAny(normalized, ['mourir', 'finir', 'plus rien', 'urgence', 'موت', 'انتحار', 'طوارئ'])) {
      safety = true;
      states.add(DeclaredState.urgentSituation);
    }

    return FreeTextAnalysis(
      identifiedDomains: domains.toList(),
      identifiedStates: states.toList(),
      identifiedConcerns: concerns,
      spiritualPreference: spiritualEnabled,
      wilaya: wilaya,
      safetyFlag: safety,
      rawText: text,
      analyzedAt: DateTime.now(),
    );
  }

  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }
}
