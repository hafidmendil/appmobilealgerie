import '../models/assessment_axis.dart';
import '../models/assessment_result.dart';
import 'safety_engine.dart';

class OrientationEngine {
  final SafetyEngine _safetyEngine = SafetyEngine();

  OrientationLevel determineLevel(
    Map<String, int?> answers,
    Map<AssessmentAxis, double> needs,
  ) {
    // 1. Safety overrides everything
    final safetyStatus = _safetyEngine.determineSafetyStatus(answers);

    if (safetyStatus == SafetyStatus.urgentSupport) {
      return OrientationLevel.level4;
    } else if (safetyStatus == SafetyStatus.supportRecommended) {
      return OrientationLevel.level3;
    }

    // 2. Multidimensional Clinical Analysis
    // We look at the severity (max need) and the scope (how many axes are affected)
    final highNeedAxes = needs.entries.where((e) => e.value >= 0.7).toList();
    final moderateNeedAxes = needs.entries
        .where((e) => e.value >= 0.4 && e.value < 0.7)
        .toList();

    // Critical threshold: if any axis is extremely high
    final maxNeed = needs.values.fold(
      0.0,
      (prev, curr) => curr > prev ? curr : prev,
    );

    if (maxNeed >= 0.85 || highNeedAxes.length >= 2) {
      return OrientationLevel.level3; // Professional support highly recommended
    }

    if (maxNeed >= 0.55 ||
        highNeedAxes.length == 1 ||
        moderateNeedAxes.length >= 3) {
      return OrientationLevel.level2; // Consultation advised
    }

    if (maxNeed >= 0.25 || moderateNeedAxes.isNotEmpty) {
      return OrientationLevel.level1; // Self-care and monitoring
    }

    return OrientationLevel.level0; // Stable
  }

  List<String> getJustifications(
    Map<AssessmentAxis, double> needs,
    OrientationLevel level,
  ) {
    final justifications = <String>[];

    needs.forEach((axis, value) {
      if (value >= 0.7) {
        justifications.add('high_need_${axis.name}');
      } else if (value >= 0.4) {
        justifications.add('moderate_need_${axis.name}');
      }
    });

    return justifications;
  }
}
