import 'dart:math';

class VoiceBiomarkers {
  final double pitchStability;
  final double intensityVariation;
  final double jitter;
  final double shimmer;
  final double speechRate;
  final double pauseDuration;

  VoiceBiomarkers({
    required this.pitchStability,
    required this.intensityVariation,
    required this.jitter,
    required this.shimmer,
    required this.speechRate,
    required this.pauseDuration,
  });
}

class VoiceAnalysisResult {
  final double stressScore;
  final String primaryEmotion;
  final List<String> clinicalMarkers;
  final VoiceBiomarkers biomarkers;
  final String transcription;
  final String clinicalRecommendation;

  VoiceAnalysisResult({
    required this.stressScore,
    required this.primaryEmotion,
    required this.clinicalMarkers,
    required this.biomarkers,
    required this.transcription,
    required this.clinicalRecommendation,
  });
}

class VoiceAnalysisEngine {
  final Random _random = Random();

  Future<VoiceAnalysisResult> analyzeVoice(String languageCode) async {
    // Simulate complex processing delay
    await Future.delayed(const Duration(milliseconds: 3500));

    final stressScore = 60.0 + _random.nextDouble() * 25.0;
    
    final biomarkers = VoiceBiomarkers(
      pitchStability: 85.0 - _random.nextDouble() * 20,
      intensityVariation: 12.0 + _random.nextDouble() * 15,
      jitter: 1.2 + _random.nextDouble() * 2.0,
      shimmer: 3.5 + _random.nextDouble() * 4.0,
      speechRate: 140 + _random.nextDouble() * 40,
      pauseDuration: 0.8 + _random.nextDouble() * 1.5,
    );

    String transcription;
    String recommendation;
    List<String> markers;
    String emotion;

    if (languageCode == 'ar') {
      transcription = "أشعر بضيق شديد في صدري، الأيام تمر بصعوبة بالغة ولا أجد من يفهمني...";
      emotion = "ضيق وحزن";
      markers = ["رعشة صوتية خفيفة", "فترات صمت طويلة غير معتادة", "انخفاض في نبرة الصوت"];
      recommendation = "يوصى بجلسة تفريغ انفعالي فورية مع أخصائي نفسي لخفض مستوى التوتر المتراكم.";
    } else {
      transcription = "Je ressens une boule dans la gorge, les journées sont devenues pesantes et je me sens seul face à mes problèmes...";
      emotion = "Détresse et Tristesse";
      markers = ["Tremblement vocal modéré", "Pauses respiratoires fréquentes", "Monotonie prosodique"];
      recommendation = "Une séance de déchargement émotionnel immédiate est recommandée pour réduire le niveau de stress accumulé.";
    }

    return VoiceAnalysisResult(
      stressScore: stressScore,
      primaryEmotion: emotion,
      clinicalMarkers: markers,
      biomarkers: biomarkers,
      transcription: transcription,
      clinicalRecommendation: recommendation,
    );
  }
}
