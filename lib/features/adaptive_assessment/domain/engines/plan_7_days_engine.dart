import '../../../../generated/l10n/app_localizations.dart';
import '../models/assessment_axis.dart';

class Plan7DaysEngine {
  Map<int, String> generatePlan(
    Map<AssessmentAxis, double> needs,
    AppLocalizations l10n,
  ) {
    if (needs.isEmpty) return _getDefaultPlan(l10n);

    final sortedAxis = needs.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final primary = sortedAxis.first.key;

    return {
      1: _getTask(1, primary, l10n),
      2: _getTask(2, primary, l10n),
      3: _getTask(3, primary, l10n),
      4: _getTask(4, primary, l10n),
      5: _getTask(5, primary, l10n),
      6: _getTask(6, primary, l10n),
      7: _getTask(7, primary, l10n),
    };
  }

  Map<int, String> _getDefaultPlan(AppLocalizations l10n) {
    return {
      1: l10n.default_task_1,
      2: l10n.default_task_2,
      3: l10n.default_task_3,
      4: l10n.default_task_4,
      5: l10n.default_task_5,
      6: l10n.default_task_6,
      7: l10n.default_task_7,
    };
  }

  String _getTask(int day, AssessmentAxis axis, AppLocalizations l10n) {
    switch (axis) {
      case AssessmentAxis.stressAnxiety:
        return _getStressTask(day, l10n);
      case AssessmentAxis.selfConfidence:
        return _getConfidenceTask(day, l10n);
      default:
        return _getGeneralTask(day, l10n);
    }
  }

  String _getStressTask(int day, AppLocalizations l10n) {
    switch (day) {
      case 1:
        return l10n.stress_task_1;
      case 2:
        return l10n.stress_task_2;
      case 3:
        return l10n.stress_task_3;
      case 4:
        return l10n.stress_task_4;
      case 5:
        return l10n.stress_task_5;
      case 6:
        return l10n.stress_task_6;
      case 7:
        return l10n.stress_task_7;
      default:
        return "";
    }
  }

  String _getConfidenceTask(int day, AppLocalizations l10n) {
    switch (day) {
      case 1:
        return l10n.confidence_task_1;
      case 2:
        return l10n.confidence_task_2;
      case 3:
        return l10n.confidence_task_3;
      case 4:
        return l10n.confidence_task_4;
      case 5:
        return l10n.confidence_task_5;
      case 6:
        return l10n.confidence_task_6;
      case 7:
        return l10n.confidence_task_7;
      default:
        return "";
    }
  }

  String _getGeneralTask(int day, AppLocalizations l10n) {
    switch (day) {
      case 1:
        return l10n.general_task_1;
      case 2:
        return l10n.general_task_2;
      case 3:
        return l10n.general_task_3;
      case 4:
        return l10n.general_task_4;
      case 5:
        return l10n.general_task_5;
      case 6:
        return l10n.general_task_6;
      case 7:
        return l10n.general_task_7;
      default:
        return "";
    }
  }
}
