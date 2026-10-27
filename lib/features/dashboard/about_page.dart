import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../generated/l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        title: Text(l10n.about_label),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Hero(
              tag: 'app_logo',
              child: Icon(LucideIcons.brain_circuit, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              "NeuroSync 4.0",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              l10n.app_version + ": 1.0.0",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            
            _buildInfoCard(
              context,
              title: isAr ? "المهمة والرؤية" : "Mission et Vision",
              content: isAr
                ? "نيوروسينك هي منصة رائدة تهدف إلى تحويل الرعاية النفسية في الجزائر. نؤمن بأن الكشف المبكر والوقاية هما مفتاح المجتمع السليم. مهمتنا هي توفير أدوات تشخيصية علمية في متناول الجميع مع احترام الخصوصية التامة."
                : "NeuroSync est une plateforme pionnière visant à transformer les soins psychologiques en Algérie. Nous pensons que le repérage précoce et la prévention sont les clés d'une société saine. Notre mission est de fournir des outils diagnostiques scientifiques accessibles à tous.",
            ),
            const SizedBox(height: AppSpacing.md),

            _buildInfoCard(
              context,
              title: isAr ? "الهيئة العلمية" : "Équipe Scientifique",
              content: isAr
                ? "يتم تطوير المحتوى السريري من قبل نخبة من الأساتذة والأخصائيين النفسانيين الجزائريين، مع مراعاة الخصائص السوسيو-ثقافية واللغوية (الدارجة) للمجتمع الجزائري."
                : "Le contenu clinique est développé par une élite de professeurs et psychologues algériens, en tenant compte des spécificités socio-culturelles et linguistiques (Darja) de la société algérienne.",
            ),
            const SizedBox(height: AppSpacing.md),

            _buildInfoCard(
              context,
              title: isAr ? "التكنولوجيا والبيانات" : "Technologie et Données",
              items: [
                isAr ? "معالجة صوتية محلية (On-Device AI)." : "IA vocale embarquée (On-Device AI).",
                isAr ? "تشفير عسكري للبيانات (AES-256)." : "Chiffrement de grade militaire (AES-256).",
                isAr ? "الامتثال للقانون 18-07 الجزائري." : "Conformité à la loi 18-07 algérienne.",
              ],
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Partner Section
            Text(
              isAr ? "بدعم من" : "Avec le soutien de",
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildPartnerLogo(LucideIcons.university, isAr ? "جامعة جزائرية" : "Université Algérienne"),
                _buildPartnerLogo(LucideIcons.hospital, isAr ? "مراكز مختصة" : "Centres Spécialisés"),
              ],
            ),
            
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerLogo(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, String? content, List<String>? items}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (content != null) Text(content, style: const TextStyle(height: 1.5)),
          if (items != null) ...items.map((item) => Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.circle_check, size: 16, color: AppColors.oliveGreen),
                const SizedBox(width: 8),
                Expanded(child: Text(item, style: const TextStyle(fontSize: 14))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
