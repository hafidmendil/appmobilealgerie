import '../../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import '../../domain/models/legal_models.dart';
import '../providers/legal_providers.dart';

class LegalResultPage extends ConsumerWidget {
  const LegalResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientationResult = ref.watch(currentLegalOrientationResultProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (orientationResult == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.auto_orientation_juridique)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gavel_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                context.l10n.legal_result_none,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => context.go('/legal/questionnaire'),
                icon: const Icon(Icons.assignment),
                label: Text(context.l10n.auto_commencer_questionnaire),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.auto_orientation_juridique),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: context.l10n.legal_result_save_tooltip,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.legal_result_save_success),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mandatory Legal Disclaimer Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade700, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.gavel, color: Colors.amber.shade800, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.legal_result_disclaimer_title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.amber.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isArabic
                                ? orientationResult.disclaimerAr
                                : orientationResult.disclaimerFr,
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: const TextStyle(fontSize: 13, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section 1: Faits Déclarés
              _buildSectionCard(
                titleFr: '1. Faits déclarés',
                titleAr: 'الوقائع المصرح بها',
                isArabic: isArabic,
                icon: Icons.fact_check_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      (isArabic
                              ? orientationResult.declaredFactsSummaryAr
                              : orientationResult.declaredFactsSummary)
                          .map(
                            (fact) => Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.arrow_right,
                                    color: AppColors.primary,
                                  ),
                                  Expanded(
                                    child: Text(
                                      fact,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Section 2: Catégories Juridiques Concernées
              _buildSectionCard(
                titleFr: '2. Catégories juridiques potentiellement concernées',
                titleAr: 'الفئات القانونية المحتملة',
                isArabic: isArabic,
                icon: Icons.category_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic
                                ? orientationResult.qualificationIndicativeAr
                                : orientationResult.qualificationIndicativeFr,
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...orientationResult.candidateCategories.map(
                      (cat) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: Icon(
                            Icons.folder_special,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          isArabic ? cat.titleAr : cat.titleFr,
                          textDirection: isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          isArabic ? cat.descriptionAr : cat.descriptionFr,
                          textDirection: isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildSectionCard(
                titleFr: '3. Textes juridiques correspondants & Explication',
                titleAr: 'النصوص القانونية المعتمدة والشرح الميسر',
                isArabic: isArabic,
                icon: Icons.menu_book_outlined,
                child: Column(
                  children: orientationResult.applicableArticles.map((article) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Chip(
                                label: Text(
                                  isArabic
                                      ? article.referenceAr
                                      : article.reference,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: AppColors.primary,
                                padding: EdgeInsets.zero,
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${isArabic ? "معتمد" : "Validé"}: ${article.version}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isArabic ? article.titreAr : article.titre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            context.l10n.legal_result_facts_official_label,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            isArabic ? article.texteAr : article.texte,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.l10n
                                            .legal_result_facts_explanation_label,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Text(
                                        isArabic
                                            ? article.explicationSimplifieeAr
                                            : article.explicationSimplifiee,
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Section 5: Démarches Possibles
              _buildSectionCard(
                titleFr: '4. Démarches possibles conseillées',
                titleAr: 'الخيارات الإجرائية المتاحة',
                isArabic: isArabic,
                icon: Icons.alt_route,
                child: Column(
                  children: orientationResult.recommendedProcedures.map((proc) {
                    return ExpansionTile(
                      leading: Icon(
                        proc.isEmergency
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline,
                        color: proc.isEmergency
                            ? Colors.red
                            : AppColors.primary,
                      ),
                      title: Text(
                        isArabic ? proc.titleAr : proc.titleFr,
                        textDirection: isArabic
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic
                                    ? proc.descriptionAr
                                    : proc.descriptionFr,
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.l10n.legal_result_steps_label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              ...(isArabic ? proc.stepsAr : proc.stepsFr).map(
                                (step) => Text(
                                  '• $step',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              if (proc.helplines.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone_in_talk,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${context.l10n.legal_result_helplines_label} ${proc.helplines.join(" / ")}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Section 6 & 7: Organismes & Assistance Professionnelle
              _buildSectionCard(
                titleFr:
                    '5. Organismes compétents & Assistance professionnelle',
                titleAr: 'الهيئات المختصة والدعم المهني',
                isArabic: isArabic,
                icon: Icons.account_balance_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.legal_result_organizations_label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...(isArabic
                            ? orientationResult.competentOrganizationsAr
                            : orientationResult.competentOrganizations)
                        .map(
                          (org) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.business,
                                  size: 18,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    org,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    const Divider(height: 24),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple.withOpacity(0.15),
                        child: const Icon(
                          Icons.gavel,
                          color: Colors.purple,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        context.l10n.legal_result_legal_help_btn,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        context.l10n.legal_result_legal_help_subtitle,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.push('/professional-search');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Button to Prepare Signalement & Consent Center
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Initialize Report Draft & Consent workflow
                    ref
                        .read(reportDraftStateProvider.notifier)
                        .initializeDraft(
                          declaredFacts: {
                            for (var item
                                in orientationResult.declaredFactsSummary)
                              'fait': item,
                          },
                          summaryText:
                              'Orientation juridique basée sur ${orientationResult.candidateCategories.length} catégories et ${orientationResult.applicableArticles.length} textes juridiques validés.',
                          recipient: const ReportRecipient(
                            id: 'recip_procureur',
                            name:
                                'Procureur de la République / Services de Sécurité',
                            type: 'procureur',
                            contactInfo: 'Tribunal territorialement compétent',
                          ),
                        );

                    ref
                        .read(consentStateProvider.notifier)
                        .prepareConsent(
                          dataTypes: [
                            'Faits déclarés',
                            'Catégorie juridique indicative',
                            'Date du signalement',
                          ],
                          purpose:
                              'Préparation et orientation d\'un signalement juridique sécurisé',
                          recipientInstitution:
                              'Autorités judiciaires / Forces de sécurité compétentes',
                          transmittedFields: [
                            'Résumé des faits',
                            'Catégorie juridique',
                            'Date approximative',
                          ],
                          actionToBePerformed:
                              'Génération d\'un dossier de signalement local et transmission après confirmation',
                          retentionPeriod:
                              'Conservé localement jusqu\'à décision utilisateur',
                        );

                    context.push('/legal/consent');
                  },
                  icon: const Icon(Icons.assignment_turned_in, size: 22),
                  label: Text(
                    context.l10n.legal_result_prepare_report_btn,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String titleFr,
    required String titleAr,
    required bool isArabic,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? titleAr : titleFr,
                        textDirection: isArabic
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}
