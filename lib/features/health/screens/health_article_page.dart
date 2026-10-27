import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import 'package:projetmascara/core/theme/tokens/app_spacing.dart';
import 'package:projetmascara/core/widgets/sind_components.dart';
import 'package:projetmascara/features/health/providers/health_provider.dart';
import 'package:projetmascara/features/health/widgets/health_components.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class HealthArticlePage extends ConsumerWidget {
  final String articleId;
  const HealthArticlePage({super.key, required this.articleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final items = ref.watch(healthKnowledgeProvider);
    final item = items.firstWhere((i) => i.id == articleId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(isAr ? item.arabicTitle : item.title),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EvidenceLevelBadge(level: item.evidenceLevel),
                  const SizedBox(height: AppSpacing.md),

                  Text(
                    isAr ? item.arabicTitle : item.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    "${l10n.actor}: ${item.author ?? 'Inconnu'} • ${item.publicationYear ?? ''}",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  if (isAr)
                    Text(
                      l10n.contentAvailableInFrench,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  else ...[
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Tradition Section
                    _SectionHeader(
                      title: l10n.tradition_view,
                      icon: LucideIcons.book_marked,
                      color: Colors.brown,
                    ),
                    SindGlassCard(
                      color: Colors.brown.withOpacity(0.05),
                      child: Text(item.traditionalContext ?? "Non documenté."),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Research Section
                    _SectionHeader(
                      title: l10n.research_view,
                      icon: LucideIcons.microscope,
                      color: Colors.blue,
                    ),
                    SindGlassCard(
                      color: Colors.blue.withOpacity(0.05),
                      child: Text(
                        item.scientificSummary ??
                            "Aucune étude scientifique référencée pour le moment.",
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Benefits & Warnings
                    if (item.benefits.isNotEmpty) ...[
                      Text(
                        "Bienfaits mentionnés :",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ...item.benefits.map(
                        (b) => ListTile(
                          leading: const Icon(
                            LucideIcons.check,
                            color: Colors.green,
                          ),
                          title: Text(b),
                          dense: true,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    if (item.warnings.isNotEmpty) ...[
                      Text(
                        "Précautions :",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ...item.warnings.map(
                        (w) => ListTile(
                          leading: const Icon(
                            LucideIcons.triangle_alert,
                            color: Colors.orange,
                          ),
                          title: Text(w),
                          dense: true,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],

                  const SizedBox(height: AppSpacing.xl),

                  // Disclaimer
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.danger.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.circle_alert,
                          color: AppColors.danger,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            l10n.medical_disclaimer,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          context.push('/health/quiz/${item.category.name}'),
                      icon: const Icon(LucideIcons.circle_question_mark),
                      label: Text(
                        isAr
                            ? 'اختبر معلوماتك حول هذا الموضوع'
                            : 'Tester vos connaissances sur ce sujet',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
