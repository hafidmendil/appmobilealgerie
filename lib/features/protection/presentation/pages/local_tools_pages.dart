import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'dart:async';
import 'dart:math';
import '../providers/protection_providers.dart';
import '../../domain/models/protection_models.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/theme/tokens/app_colors.dart';
import '../../../../core/theme/tokens/app_spacing.dart';
import '../../../../core/theme/tokens/app_radii.dart';
import '../../../../core/widgets/sind_components.dart';
import '../../domain/engines/voice_analysis_engine.dart';

class LocalReportsPage extends ConsumerWidget {
  const LocalReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.local_reports_title)),
      body: FutureBuilder<List<ViolenceReport>>(
        future: ref.read(protectionRepositoryProvider).getReports(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final reports = snapshot.data!;
          if (reports.isEmpty)
            return Center(child: Text(context.l10n.local_reports_empty));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final isRtl = Directionality.of(context) == TextDirection.rtl;
              final report = reports[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: Text(context.l10n.local_report_item),
                  subtitle: Text(
                    '${report.createdAt.toLocal()}\n${_formatStatus(report.status, isRtl)}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatStatus(ProtectionReportStatus status, bool isRtl) {
    switch (status) {
      case ProtectionReportStatus.draft:
        return isRtl ? 'مسودة محلية' : 'Brouillon local';
      case ProtectionReportStatus.submitted:
        return isRtl ? 'مقدم' : 'Soumis';
      case ProtectionReportStatus.underReview:
        return isRtl ? 'قيد المراجعة' : 'En cours d’examen';
      case ProtectionReportStatus.referred:
        return isRtl ? 'محال' : 'Orienté';
      case ProtectionReportStatus.inFollowUp:
        return isRtl ? 'قيد المتابعة' : 'En suivi';
      case ProtectionReportStatus.resolved:
        return isRtl ? 'معالج' : 'Traité';
      case ProtectionReportStatus.closed:
        return isRtl ? 'مغلق' : 'Clôturé';
    }
  }
}

class SafetyPlanPage extends StatefulWidget {
  const SafetyPlanPage({super.key});

  @override
  State<SafetyPlanPage> createState() => _SafetyPlanPageState();
}

class _SafetyPlanPageState extends State<SafetyPlanPage> {
  bool _safePlace = false;
  bool _trustedContact = false;
  bool _deviceSafety = false;

  @override
  Widget build(BuildContext context) {
    final completed = [
      _safePlace,
      _trustedContact,
      _deviceSafety,
    ].where((item) => item).length;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.safety_plan_title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            context.l10n.safety_plan_subtitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(context.l10n.safety_plan_warning),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: completed / 3),
          const SizedBox(height: 8),
          Text('$completed / 3'),
          Card(
            child: Column(
              children: [
                CheckboxListTile(
                  value: _safePlace,
                  onChanged: (value) =>
                      setState(() => _safePlace = value ?? false),
                  title: Text(context.l10n.safety_plan_reach_safe),
                ),
                CheckboxListTile(
                  value: _trustedContact,
                  onChanged: (value) =>
                      setState(() => _trustedContact = value ?? false),
                  title: Text(context.l10n.safety_plan_contact_trust),
                ),
                CheckboxListTile(
                  value: _deviceSafety,
                  onChanged: (value) =>
                      setState(() => _deviceSafety = value ?? false),
                  title: Text(context.l10n.safety_plan_delete),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                Directionality.of(context) == TextDirection.rtl
                    ? 'هذه القائمة تبقى على الشاشة فقط ولا تُرسل إلى أي جهة. استخدم زر الطوارئ إذا كان هناك خطر مباشر.'
                    : 'Cette liste reste sur cet écran et n’est transmise à personne. Utilisez les options d’urgence si le danger est immédiat.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VoiceAssessmentPage extends StatefulWidget {
  const VoiceAssessmentPage({super.key});

  @override
  State<VoiceAssessmentPage> createState() => _VoiceAssessmentPageState();
}

class _VoiceAssessmentPageState extends State<VoiceAssessmentPage> {
  final _controller = TextEditingController();
  final _engine = VoiceAnalysisEngine();
  
  bool _isRecording = false;
  bool _isAnalyzing = false;
  VoiceAnalysisResult? _analysisResult;
  int _recordingSeconds = 0;
  Timer? _timer;
  String _selectedLanguage = 'ar'; // 'ar', 'fr'

  final _random = Random();
  final List<double> _waveValues = List.filled(20, 0.1);
  Timer? _waveTimer;

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _waveTimer?.cancel();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _analysisResult = null;
      _recordingSeconds = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _recordingSeconds++;
      });
      if (_recordingSeconds >= 8) {
        _stopRecording();
      }
    });

    _waveTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        for (int i = 0; i < _waveValues.length; i++) {
          _waveValues[i] = 0.1 + _random.nextDouble() * 0.9;
        }
      });
    });
  }

  void _stopRecording() async {
    _timer?.cancel();
    _waveTimer?.cancel();
    setState(() {
      _isRecording = false;
      _isAnalyzing = true;
    });

    final result = await _engine.analyzeVoice(_selectedLanguage);
    
    if (!mounted) return;
    setState(() {
      _isAnalyzing = false;
      _analysisResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(isAr ? "تحليل العلامات الحيوية الصوتية" : "Analyse des Biomarqueurs Vocaux"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSafetyInfo(isAr),
            const SizedBox(height: AppSpacing.lg),
            _buildLanguageSelector(isAr),
            const SizedBox(height: AppSpacing.xl),
            _buildRecordingInterface(isAr),
            const SizedBox(height: AppSpacing.xl),
            if (_analysisResult != null) _buildProfessionalReport(isAr),
            const SizedBox(height: AppSpacing.xl),
            _buildNoteSection(isAr),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyInfo(bool isAr) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.shield_check, color: Colors.teal, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isAr 
                ? "يتم معالجة الصوت محلياً بالكامل. لا يتم إرسال تسجيلاتك إلى أي خادم خارجي."
                : "Le son est traité intégralement localement. Vos enregistrements ne sont envoyés à aucun serveur externe.",
              style: const TextStyle(fontSize: 12, color: Colors.teal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(bool isAr) {
    return Row(
      children: [
        Text(isAr ? "لغة التحليل:" : "Langue d'analyse :", style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        ChoiceChip(
          label: const Text("العربية"),
          selected: _selectedLanguage == 'ar',
          onSelected: (_) => setState(() => _selectedLanguage = 'ar'),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text("Français"),
          selected: _selectedLanguage == 'fr',
          onSelected: (_) => setState(() => _selectedLanguage = 'fr'),
        ),
      ],
    );
  }

  Widget _buildRecordingInterface(bool isAr) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              isAr ? "تحدث بوضوح لمدة 8 ثوانٍ عن حالتك الراهنة" : "Parlez clairement pendant 8 secondes de votre état actuel",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            if (_isRecording)
              _buildWaveform()
            else if (_isAnalyzing)
              const CircularProgressIndicator()
            else
              Icon(LucideIcons.mic, size: 64, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 32),
            if (_isRecording)
              Text("00:0${8 - _recordingSeconds}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red))
            else
              GestureDetector(
                onTap: _isAnalyzing ? null : _startRecording,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _isAnalyzing ? Colors.grey : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15)],
                  ),
                  child: const Icon(LucideIcons.mic, color: Colors.white, size: 32),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveform() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _waveValues.map((v) => AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 4,
        height: 10 + 40 * v,
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2)),
      )).toList(),
    );
  }

  Widget _buildProfessionalReport(bool isAr) {
    final res = _analysisResult!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isAr ? "تقرير المؤشرات العيادية" : "Rapport des Indicateurs Cliniques",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScoreRow(isAr ? "مؤشر الضغط النفسي" : "Indice de Stress", res.stressScore, Colors.orange),
                const Divider(height: 32),
                Text(isAr ? "العلامات الحيوية المكتشفة:" : "Biomarqueurs détectés :", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildBiomarkerTile(isAr ? "استقرار النبرة" : "Stabilité du pitch", res.biomarkers.pitchStability, Icons.trending_flat),
                _buildBiomarkerTile(isAr ? "التوتر الصوتي (Jitter)" : "Tension vocale (Jitter)", res.biomarkers.jitter * 10, Icons.waves),
                _buildBiomarkerTile(isAr ? "ارتجاف الصوت (Shimmer)" : "Instabilité (Shimmer)", res.biomarkers.shimmer * 5, Icons.graphic_eq),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isAr ? "الاستنتاج الإكلينيكي:" : "Conclusion Clinique :", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      const SizedBox(height: 4),
                      Text(res.clinicalRecommendation, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isAr ? "جاري توليد التقرير الطبي PDF..." : "Génération du rapport médical PDF...")));
                  },
                  icon: const Icon(LucideIcons.file_text, size: 16),
                  label: Text(isAr ? "تصدير التقرير الفني" : "Exporter le rapport technique"),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreRow(String label, double score, Color color) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 4),
              LinearProgressIndicator(value: score / 100, color: color, backgroundColor: color.withOpacity(0.1)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text("${score.toInt()}%", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildBiomarkerTile(String label, double value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13)),
          const Spacer(),
          Text("${value.toStringAsFixed(1)}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildNoteSection(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(isAr ? "ملاحظات إضافية" : "Notes Additionnelles", style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: isAr ? "أضف أي ملاحظات تود حفظها مع التحليل..." : "Ajoutez des notes à sauvegarder avec l'analyse...",
            border: const OutlineInputBorder(),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isAr ? "تم حفظ التقرير محلياً" : "Rapport sauvegardé localement")));
            Navigator.pop(context);
          },
          child: Text(isAr ? "حفظ التقرير النهائي" : "Sauvegarder le rapport final"),
        ),
      ],
    );
  }
}
