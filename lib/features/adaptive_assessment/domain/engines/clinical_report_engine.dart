import '../../../../generated/l10n/app_localizations.dart';
import '../models/assessment_axis.dart';
import '../models/assessment_result.dart';

class ClinicalReportEngine {
  String generateSynthesis(AssessmentResult result, AppLocalizations l10n) {
    final needs = result.axisNeeds;
    final buffer = StringBuffer();

    // 1. General Opening
    buffer.write(l10n.synthesis_prefix);

    // 2. Expert Profiles
    final highEmotions = (needs[AssessmentAxis.emotions] ?? 0.0) > 0.7;
    final highStress = (needs[AssessmentAxis.stressAnxiety] ?? 0.0) > 0.7;
    final lowConfidence = (needs[AssessmentAxis.selfConfidence] ?? 0.0) > 0.7;

    if (highEmotions && highStress) {
      buffer.write("L’analyse met en évidence une dysrégulation affective majeure corrélée à une charge allostatique critique. ");
    }
    
    if (lowConfidence) {
      buffer.write("On observe un biais d'auto-dépréciation impactant le sentiment d'auto-efficacité. ");
    }

    // 3. Axis Specific Observations
    final sortedAxes = needs.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    int addedCount = 0;
    for (var entry in sortedAxes) {
      if (entry.value < 0.4 || addedCount >= 2) continue;

      final observation = _getAxisObservation(entry.key, entry.value, l10n);
      if (observation != null) {
        buffer.write("$observation ");
        addedCount++;
      }
    }

    // 4. Closing / Strength
    final goodConfidence =
        (needs[AssessmentAxis.selfConfidence] ?? 0.0) <
        0.3; // Low need means high confidence
    if (goodConfidence) {
      buffer.write(l10n.synthesis_good_confidence);
    } else {
      buffer.write(l10n.synthesis_need_strategies);
    }

    return buffer.toString();
  }

  String? _getAxisObservation(
    AssessmentAxis axis,
    double value,
    AppLocalizations l10n,
  ) {
    if (value > 0.8) {
      switch (axis) {
        case AssessmentAxis.emotions:
          return l10n.synthesis_high_emotions;
        case AssessmentAxis.stressAnxiety:
          return l10n.synthesis_high_anxiety;
        case AssessmentAxis.socialSupport:
          return l10n.synthesis_high_isolation;
        default:
          return null;
      }
    } else if (value > 0.5) {
      switch (axis) {
        case AssessmentAxis.sleepEnergy:
          return l10n.synthesis_unstable_sleep;
        case AssessmentAxis.angerRegulation:
          return l10n.synthesis_impulse_control;
        default:
          return null;
      }
    }
    return null;
  }
}
