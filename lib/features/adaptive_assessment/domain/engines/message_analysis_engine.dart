class MessageAnalysisEngine {
  final Map<String, List<String>> _keywords = {
    'stress': ['stress', 'قلق', 'ضغط', 'توتر', 'مقلق', 'زعاف'],
    'solitude': ['seul', 'isolement', 'وحدة', 'وحدي', 'وحدانية', 'منعزل'],
    'fatigue': ['fatigue', 'épuisé', 'تعب', 'عياء', 'فشل', 'عيان', 'مرقدتش'],
    'colère': ['colère', 'énerve', 'غضب', 'زعاف', 'غضبان', 'منرفزي', 'نضرب'],
    'confiance': ['confiance', 'douter', 'ثقة', 'شاك', 'ناقص', 'مانسواش'],
    'tristesse': ['triste', 'pleurer', 'حزن', 'بكى', 'دموع', 'قلبي معمر'],
    'anxiété': ['anxieux', 'peur', 'خوف', 'رهبة', 'وسواس', 'خايف'],
    'travail': ['travail', 'boulot', 'études', 'خدمة', 'قراية', 'ليكول'],
    'famille': [
      'famille',
      'parents',
      'عائلة',
      'والدين',
      'دارنا',
      'بابا',
      'ماما',
    ],
    'santé': ['santé', 'malade', 'مرض', 'صحة', 'طبيب', 'وجع'],
  };

  List<String> analyzeThemes(String text) {
    if (text.isEmpty) return [];

    final themes = <String>[];
    final lowerText = text.toLowerCase();

    _keywords.forEach((theme, words) {
      for (var word in words) {
        if (lowerText.contains(word.toLowerCase())) {
          themes.add(theme);
          break;
        }
      }
    });

    return themes;
  }

  /// Determines dominant emotions based on intensity of keywords (future expansion)
  Map<String, double> getEmotionScores(String text) {
    // Basic implementation for now
    final themes = analyzeThemes(text);
    final scores = <String, double>{};
    for (var theme in themes) {
      scores[theme] = 1.0;
    }
    return scores;
  }
}
