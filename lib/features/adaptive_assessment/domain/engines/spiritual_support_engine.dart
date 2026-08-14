import '../models/spiritual_content.dart';
import '../models/assessment_axis.dart';

class SpiritualSupportEngine {
  static const List<SpiritualContent> _content = [
    SpiritualContent(
      id: "S001",
      category: SpiritualCategory.patience,
      titleAr: "الصبر عند الشدائد",
      contentAr: "يَا أَيُّهَا الَّذِينَ آمَنُوا اسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ ۚ إِنَّ اللَّهَ مَعَ الصَّابِرِينَ",
      translationFr: "Ô vous qui croyez ! Cherchez secours dans l'endurance et la prière. Car Allah est avec ceux qui sont endurants.",
      source: "القرآن الكريم",
      reference: "سورة البقرة، الآية 153",
      verified: true,
    ),
    SpiritualContent(
      id: "S002",
      category: SpiritualCategory.hope,
      titleAr: "الأمل واليسر",
      contentAr: "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا * إِنَّ مَعَ الْعُسْرِ يُسْرًا",
      translationFr: "À côté de la difficulté est, certes, une facilité. À côté de la difficulté est, certes, une facilité.",
      source: "القرآن الكريم",
      reference: "سورة الشرح، الآيات 5-6",
      verified: true,
    ),
    SpiritualContent(
      id: "S003",
      category: SpiritualCategory.tawakkul,
      titleAr: "التوكل على الله",
      contentAr: "وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ",
      translationFr: "Et quiconque place sa confiance en Allah, Il lui suffit.",
      source: "القرآن الكريم",
      reference: "سورة الطلاق، الآية 3",
      verified: true,
    ),
    SpiritualContent(
      id: "S004",
      category: SpiritualCategory.tranquility,
      titleAr: "طمأنينة القلب",
      contentAr: "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
      translationFr: "N'est-ce point par l'évocation d'Allah que les cœurs se tranquillisent ?",
      source: "القرآن الكريم",
      reference: "سورة الرعد، الآية 28",
      verified: true,
    ),
  ];

  List<SpiritualContent> getRelevantContent(Map<AssessmentAxis, double> needs) {
    // Basic logic: return content based on priority axes
    final sortedAxes = needs.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    if (sortedAxes.isEmpty || sortedAxes.first.value < 0.3) {
      return [_content.firstWhere((c) => c.category == SpiritualCategory.tranquility)];
    }

    final topAxis = sortedAxes.first.key;
    
    switch (topAxis) {
      case AssessmentAxis.stressAnxiety:
        return _content.where((c) => c.category == SpiritualCategory.tranquility || c.category == SpiritualCategory.tawakkul).toList();
      case AssessmentAxis.dailyPressures:
        return _content.where((c) => c.category == SpiritualCategory.patience).toList();
      case AssessmentAxis.emotions:
        return _content.where((c) => c.category == SpiritualCategory.hope).toList();
      default:
        return [_content.first];
    }
  }
}
