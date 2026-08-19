import '../assessment/assessment_record.dart';

enum TrendDirection {
  improving,
  stable,
  deteriorating,
  fluctuating
}

class TrendAnalysis {
  final TrendDirection overallTrend;
  final List<String> worseningDomains;
  final List<String> improvingDomains;
  final String message;

  TrendAnalysis({
    required this.overallTrend,
    required this.worseningDomains,
    required this.improvingDomains,
    required this.message,
  });
}

class RiskTrendEngine {
  static TrendAnalysis analyze(List<AssessmentRecord> history) {
    if (history.length < 2) {
      return TrendAnalysis(
        overallTrend: TrendDirection.stable,
        worseningDomains: [],
        improvingDomains: [],
        message: "Pas assez de données pour établir une tendance.",
      );
    }

    // Sort by date ascending
    final sorted = history..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final latest = sorted.last;
    final previous = sorted[sorted.length - 2];

    final latestTotal = latest.answers.values.fold(0, (sum, v) => sum + v);
    final prevTotal = previous.answers.values.fold(0, (sum, v) => sum + v);

    final worsening = <String>[];
    final improving = <String>[];

    // Compare specific domains if available (simplified check)
    latest.answers.forEach((qId, val) {
      if (previous.answers.containsKey(qId)) {
        if (val > previous.answers[qId]! + 1) worsening.add(qId);
        if (val < previous.answers[qId]! - 1) improving.add(qId);
      }
    });

    TrendDirection direction;
    String msg;

    if (latestTotal > prevTotal + 5) {
      direction = TrendDirection.deteriorating;
      msg = "Nous avons remarqué une augmentation de certains indicateurs de stress. Prenez soin de vous.";
    } else if (latestTotal < prevTotal - 5) {
      direction = TrendDirection.improving;
      msg = "Vos indicateurs montrent une tendance positive. Continuez vos efforts.";
    } else {
      direction = TrendDirection.stable;
      msg = "Votre état semble stable sur les dernières sessions.";
    }

    return TrendAnalysis(
      overallTrend: direction,
      worseningDomains: worsening,
      improvingDomains: improving,
      message: msg,
    );
  }
}
