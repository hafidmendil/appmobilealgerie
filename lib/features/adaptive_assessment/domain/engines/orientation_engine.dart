import '../models/assessment_axis.dart';
import '../models/assessment_result.dart';
import 'safety_engine.dart';

class OrientationEngine {
  final SafetyEngine _safetyEngine = SafetyEngine();

  OrientationLevel determineLevel(Map<String, int?> answers, Map<AssessmentAxis, double> needs) {
    final safetyStatus = _safetyEngine.determineSafetyStatus(answers);
    
    if (safetyStatus == SafetyStatus.urgentSupport) {
      return OrientationLevel.level4;
    } else if (safetyStatus == SafetyStatus.supportRecommended) {
      return OrientationLevel.level3;
    }

    final maxNeed = needs.values.fold(0.0, (prev, curr) => curr > prev ? curr : prev);

    if (maxNeed >= 0.8) {
      return OrientationLevel.level3;
    } else if (maxNeed >= 0.5) {
      return OrientationLevel.level2;
    } else {
      return OrientationLevel.level1;
    }
  }
}
