enum ScenarioDimension {
  conflictManagement,
  helpSeeking,
  safeAvoidance,
  communication,
  escalation,
}

class InteractiveScenario {
  final String id;
  final String textFr;
  final String textAr;
  final List<ScenarioOption> options;

  const InteractiveScenario({
    required this.id,
    required this.textFr,
    required this.textAr,
    required this.options,
  });
}

class ScenarioOption {
  final String textFr;
  final String textAr;
  final Set<ScenarioDimension> dimensions;

  const ScenarioOption({
    required this.textFr,
    required this.textAr,
    required this.dimensions,
  });
}

class InteractiveScenarioEngine {
  static const scenarios = <InteractiveScenario>[
    InteractiveScenario(
      id: 'provocation',
      textFr:
          'Une personne vous provoque verbalement devant plusieurs personnes. Que feriez-vous ?',
      textAr: 'يستفزك شخص لفظيًا أمام عدة أشخاص. ماذا ستفعل؟',
      options: [
        ScenarioOption(
          textFr: 'M’éloigner et chercher une personne de confiance',
          textAr: 'أبتعد وأبحث عن شخص أثق به',
          dimensions: {
            ScenarioDimension.safeAvoidance,
            ScenarioDimension.helpSeeking,
          },
        ),
        ScenarioOption(
          textFr: 'Répondre calmement et poser une limite',
          textAr: 'أجيب بهدوء وأضع حدًا',
          dimensions: {ScenarioDimension.communication},
        ),
        ScenarioOption(
          textFr: 'Répondre en criant ou en menaçant',
          textAr: 'أجيب بالصراخ أو بالتهديد',
          dimensions: {ScenarioDimension.escalation},
        ),
      ],
    ),
  ];
}

enum BreathingPhase { inhale, pause, exhale, finished }

class BreathingState {
  final BreathingPhase phase;
  final int cycle;
  final bool paused;

  const BreathingState({
    this.phase = BreathingPhase.inhale,
    this.cycle = 1,
    this.paused = false,
  });
}

class VoiceAssessmentState {
  final bool permissionGranted;
  final bool recording;
  final String? filePath;

  const VoiceAssessmentState({
    this.permissionGranted = false,
    this.recording = false,
    this.filePath,
  });
}
