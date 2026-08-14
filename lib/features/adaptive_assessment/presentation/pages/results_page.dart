import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/assessment_provider.dart';
import '../../domain/models/assessment_result.dart';
import '../../domain/models/assessment_axis.dart';
import '../../domain/engines/plan_7_days_engine.dart';
import '../../domain/engines/spiritual_support_engine.dart';

class ResultsPage extends ConsumerWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assessmentProvider);
    final result = state.result;

    if (result == null) return const Scaffold(body: Center(child: Text('No results')));

    // Assuming we use Arabic as primary UI language for now
    final plan = Plan7DaysEngine().generatePlan(result.axisNeeds, 'ar');
    final spiritual = SpiritualSupportEngine().getRelevantContent(result.axisNeeds);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('حصيلة سند'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEmpathyHeader(),
            const SizedBox(height: 20),
            _buildOrientationCard(result),
            const SizedBox(height: 20),
            _buildNeedsSection(result),
            const SizedBox(height: 20),
            _buildSpiritualSection(spiritual),
            const SizedBox(height: 20),
            const Text(
              'خطتك للأسبوع القادم',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 10),
            _build7DayPlan(plan),
            const SizedBox(height: 30),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpathyHeader() {
    return const Column(
      children: [
        Icon(Icons.favorite, color: Colors.redAccent, size: 40),
        SizedBox(height: 10),
        Text(
          "شكراً لثقتك بنا. نحن نقدر شجاعتك في مشاركة مشاعرك.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.blueGrey),
        ),
      ],
    );
  }

  Widget _buildOrientationCard(AssessmentResult result) {
    Color color;
    String title;
    String text;
    IconData icon;

    switch (result.orientationLevel) {
      case OrientationLevel.level4:
        color = const Color(0xFFFFE5E5);
        title = "دعم فوري مطلوب";
        text = "نحن هنا لمساعدتك. يرجى التحدث مع مختص أو شخص تثق به في أقرب وقت. سلامتك هي أولويتنا.";
        icon = Icons.warning_rounded;
        break;
      case OrientationLevel.level3:
        color = const Color(0xFFFFF4E5);
        title = "توصية باستشارة";
        text = "قد يكون من المفيد استشارة أخصائي للحصول على دعم أعمق وفهم أفضل لما تمر به.";
        icon = Icons.info_outline;
        break;
      case OrientationLevel.level2:
        color = const Color(0xFFE5F1FF);
        title = "دعم ذاتي موجه";
        text = "أنت تقوم بعمل جيد. استمر في ممارسة تمارين الوعي الذاتي واتباع النصائح المقترحة.";
        icon = Icons.self_improvement;
        break;
      case OrientationLevel.level1:
      default:
        color = const Color(0xFFE5FFEA);
        title = "وقاية وتوازن";
        text = "حالتك مستقرة. حافظ على عاداتك الإيجابية وواصل الاهتمام بصحتك النفسية بشكل دوري.";
        icon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.black87),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNeedsSection(AssessmentResult result) {
    final sortedNeeds = result.axisNeeds.entries.where((e) => e.value > 0.2).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('أهم مجالات التركيز:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...sortedNeeds.take(3).map((e) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(e.value * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              Text(_getAxisNameAr(e.key), style: const TextStyle(fontSize: 16)),
              const Icon(Icons.star, color: Colors.amber, size: 20),
            ],
          ),
        )),
      ],
    );
  }

  String _getAxisNameAr(AssessmentAxis axis) {
    switch (axis) {
      case AssessmentAxis.emotions: return "المشاعر والعواطف";
      case AssessmentAxis.stressAnxiety: return "القلق والتوتر";
      case AssessmentAxis.sleepEnergy: return "النوم والطاقة";
      case AssessmentAxis.productivity: return "التركيز والإنجاز";
      case AssessmentAxis.socialSupport: return "الدعم الاجتماعي";
      case AssessmentAxis.angerRegulation: return "التحكم في الغضب";
      case AssessmentAxis.selfConfidence: return "الثقة بالنفس";
      case AssessmentAxis.dailyPressures: return "ضغوطات الحياة";
      case AssessmentAxis.lifestyle: return "نمط الحياة";
      case AssessmentAxis.safety: return "الأمان الشخصي";
      default: return "مجال عام";
    }
  }

  Widget _buildSpiritualSection(List<dynamic> content) {
    if (content.isEmpty) return const SizedBox.shrink();
    final item = content.first;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Text("وقفة طمأنينة", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 10),
          Text(
            item.contentAr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(item.reference, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _build7DayPlan(Map<int, String> plan) {
    return Column(
      children: plan.entries.map((e) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: Colors.blue[50],
            child: Text('${e.key}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
          title: Text('اليوم ${e.key}', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(e.value),
        ),
      )).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text("العودة للرئيسية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20),
        const Text(
          "تنبيه: هذا التقييم لأغراض الدعم والإرشاد فقط ولا يمثل تشخيصاً طبياً.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
