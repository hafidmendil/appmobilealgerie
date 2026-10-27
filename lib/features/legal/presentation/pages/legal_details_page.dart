import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/tokens/app_colors.dart';
import '../../../../core/theme/tokens/app_spacing.dart';
import '../../../../generated/l10n/app_localizations.dart';

class LegalDetailsPage extends ConsumerWidget {
  const LegalDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegalSection(
              context,
              title: isAr ? "الإطار القانوني الجزائري" : "Cadre Juridique Algérien",
              icon: LucideIcons.scale,
              content: isAr 
                ? "يلتزم تطبيق نيوروسينك بالتشريعات الجزائرية المتعلقة بحماية البيانات والصحة:"
                : "NeuroSync respecte les législations algériennes relatives à la protection des données et à la santé :",
              items: [
                isAr 
                  ? "القانون رقم 18-07 المتعلق بحماية الأشخاص الطبيعيين في مجال معالجة المعطيات ذات الطابع الشخصي."
                  : "Loi n° 18-07 relative à la protection des personnes physiques dans le traitement des données à caractère personnel.",
                isAr
                  ? "القانون رقم 18-11 المتعلق بالصحة، لا سيما المواد المتعلقة بالسر الطبي وحقوق المريض."
                  : "Loi n° 18-11 relative à la santé (Secret médical et droits du patient).",
                isAr
                  ? "قانون العقوبات: الالتزام الصارم بالسر المهني (المادة 301)."
                  : "Code Pénal : Respect strict du secret professionnel (Art. 301).",
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildLegalSection(
              context,
              title: l10n.dataSovereigntyTitle,
              icon: LucideIcons.shield_check,
              content: l10n.dataSovereigntyDesc,
              items: [
                isAr ? "تشفير محلي متطور (AES-256)." : "Chiffrement local avancé (AES-256).",
                isAr ? "لا يتم نقل أي بيانات دون موافقة صريحة." : "Aucun transfert sans consentement explicite.",
                isAr ? "سيادة كاملة للمستخدم على سجله." : "Souveraineté totale de l'utilisateur sur son historique.",
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildLegalSection(
              context,
              title: l10n.medical_disclaimer,
              icon: LucideIcons.triangle_alert,
              content: l10n.disclaimer_text,
            ),
            const SizedBox(height: AppSpacing.xxl),
            Center(
              child: Text(
                l10n.privacyEngagementVersion,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String content,
    List<String>? items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (items != null) ...[
            const SizedBox(height: AppSpacing.sm),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(item, style: const TextStyle(fontSize: 13))),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}
