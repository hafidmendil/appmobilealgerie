import '../../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import '../providers/legal_providers.dart';

class LegalHubPage extends ConsumerWidget {
  const LegalHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final isGuest = user == null || user.role == UserRole.guest;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final articles = ref.watch(legalArticlesProvider);
    final categories = ref.watch(legalCategoriesProvider);
    final procedures = ref.watch(legalProceduresProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.auto_module_dorientation_juridique),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (user?.role == UserRole.admin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined),
              tooltip: context.l10n.administration,
              onPressed: () => context.push('/admin/legal'),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Anonymous Mode Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      isGuest
                          ? Icons.no_accounts
                          : Icons.verified_user_outlined,
                      color: Colors.blue.shade700,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isGuest
                                ? context.l10n.legal_anonymous_mode
                                : context.l10n.legal_user_protected,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isGuest
                                ? context.l10n.legal_guest_desc
                                : context.l10n.legal_user_desc,
                            style: const TextStyle(fontSize: 12, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Main Call to Action: Start Orientation Questionnaire
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.primary,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push('/legal/questionnaire'),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.quiz,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.legal_start_questionnaire,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.l10n.legal_questionnaire_desc,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // References remain indicative until an institution's legal review.
              Text(
                context.l10n.legal_ref_indicative,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.legal_ref_notice,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),

              const SizedBox(height: 14),

              // Categories Grid / List
              Text(
                context.l10n.legal_categories_label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Container(
                      width: 220,
                      margin: const EdgeInsets.only(right: 12),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isArabic ? cat.titleAr : cat.titleFr,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic ? cat.titleFr : cat.titleAr,
                                textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Validated Articles List
              Text(
                context.l10n.legal_articles_label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              ...articles.map(
                (article) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.12),
                      child: Icon(
                        Icons.gavel,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      isArabic ? article.referenceAr : article.reference,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      isArabic ? article.titreAr : article.titre,
                      style: const TextStyle(fontSize: 13),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              child: Text(
                                '${context.l10n.legal_explanation_prefix}${isArabic ? article.explicationSimplifieeAr : article.explicationSimplifiee}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  '${context.l10n.legal_status_prefix}${article.statutValidation.name}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${context.l10n.legal_version_prefix}${article.version}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Procedures List
              Text(
                context.l10n.legal_procedures_label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              ...procedures.map(
                (proc) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      proc.isEmergency ? Icons.warning_amber : Icons.verified,
                      color: proc.isEmergency ? Colors.red : Colors.green,
                    ),
                    title: Text(
                      isArabic ? proc.titleAr : proc.titleFr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      isArabic ? proc.descriptionAr : proc.descriptionFr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
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
}
