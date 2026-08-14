import '../assessment/assessment_models.dart';
import '../content/quran_library.dart';
import '../content/hadith_library.dart';
import '../content/hikma_library.dart';
import '../content/resource_library.dart';
import 'free_text_analysis_model.dart';
import 'decision_engine.dart';

class SynthesisResult {
  final String introduction;
  final List<QuestionModule> priorityDomains;
  final List<DeclaredState> identifiedStates;
  final List<PsychologicalResource> recommendedResources;
  final List<MicroAction> suggestedActions;
  final List<QuranVerse> spiritualVerses;
  final List<Hadith> spiritualHadiths;
  final List<Hikma> relevantHikam;
  final bool needsProfessionalOrientation;
  final bool isAlreadyFollowed;

  SynthesisResult({
    required this.introduction,
    required this.priorityDomains,
    required this.identifiedStates,
    this.recommendedResources = const [],
    this.suggestedActions = const [],
    this.spiritualVerses = const [],
    this.spiritualHadiths = const [],
    this.relevantHikam = const [],
    this.needsProfessionalOrientation = false,
    this.isAlreadyFollowed = false,
  });
}

class PersonalizedRecommendationEngine {
  static SynthesisResult generate(
    OrientationResult baseResult,
    FreeTextAnalysis analysis,
    Map<String, int> answers,
  ) {
    // 1. Identify Priority Domains (Merge Question Scores + Text Analysis)
    final priorityDomains = <QuestionModule>{};
    baseResult.moduleScores.forEach((domain, score) {
      if (score >= 4) priorityDomains.add(domain);
    });
    priorityDomains.addAll(analysis.identifiedDomains);

    // 2. Filter Resources (Limit to 3)
    final resources = psychologicalResources
        .where((r) => priorityDomains.contains(r.domain))
        .take(3)
        .toList();

    // 3. Filter Spiritual Content (If enabled)
    final verses = <QuranVerse>[];
    final hadiths = <Hadith>[];
    if (analysis.spiritualPreference) {
      verses.addAll(quranLibrary
          .where((v) => v.associatedDomains.any((d) => priorityDomains.contains(d)))
          .take(2));
      
      hadiths.addAll(hadithLibrary
          .where((h) => h.associatedDomains.any((d) => priorityDomains.contains(d)))
          .take(2));
    }

    // 4. Filter Hikam (Take 1)
    final hikam = hikmaLibrary
        .where((h) => h.associatedDomains.any((d) => priorityDomains.contains(d)) || 
                      h.associatedStates.any((s) => analysis.identifiedStates.contains(s)))
        .take(1)
        .toList();

    // 5. Professional Orientation logic
    bool needsPro = baseResult.level.index >= OrientationLevel.level2.index || 
                    analysis.identifiedStates.contains(DeclaredState.needOrientation);
    
    bool alreadyFollowed = analysis.identifiedStates.contains(DeclaredState.alreadyFollowed);

    // 6. Intro Message
    String intro = _generateIntro(analysis.identifiedStates, analysis.identifiedDomains);

    return SynthesisResult(
      introduction: intro,
      priorityDomains: priorityDomains.toList(),
      identifiedStates: analysis.identifiedStates,
      recommendedResources: resources,
      spiritualVerses: verses,
      spiritualHadiths: hadiths,
      relevantHikam: hikam,
      needsProfessionalOrientation: needsPro,
      isAlreadyFollowed: alreadyFollowed,
    );
  }

  static String _generateIntro(List<DeclaredState> states, List<QuestionModule> domains) {
    if (states.isEmpty && domains.isEmpty) {
      return "Merci d'avoir partagé vos ressentis. Voici quelques ressources générales pour votre bien-être.";
    }
    
    String msg = "Vous avez indiqué rencontrer actuellement des préoccupations liées à ";
    final parts = <String>[];
    if (states.contains(DeclaredState.academicDifficulty)) parts.add("vos études");
    if (states.contains(DeclaredState.stress)) parts.add("votre niveau de stress");
    if (states.contains(DeclaredState.isolated)) parts.add("un sentiment de solitude");
    if (states.contains(DeclaredState.familyConflict)) parts.add("votre environnement familial");
    
    if (parts.isEmpty) return "Merci pour votre partage. Nous avons identifié certains points sur lesquels nous pouvons vous accompagner.";
    
    return msg + parts.join(", ") + ". Nous allons vous proposer quelques pistes qui peuvent vous aider à mieux comprendre cette période.";
  }
}
