import '../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/widgets/sind_components.dart';
import '../adaptive_assessment/domain/engines/spiritual_support_engine.dart';
import '../adaptive_assessment/presentation/providers/assessment_provider.dart';

class SpiritualScreen extends ConsumerWidget {
  const SpiritualScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assessmentProvider);
    final engine = SpiritualSupportEngine();
    final l10n = AppLocalizations.of(context)!;

    final axisNeeds = state.result?.axisNeeds ?? {};
    final content = engine.getRelevantContent(axisNeeds, l10n);

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(title: Text(context.l10n.auto_dimension_spirituelle)),
      body: content.isEmpty
          ? Center(
              child: Text(context.l10n.auto_aucun_contenu_disponible_pour),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: content.length,
              itemBuilder: (context, index) {
                final item = content[index];
                return SindGlassCard(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.titleAr,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deepOlive,
                                ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            item.contentAr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          if (item.translationFr != null) ...[
                            const Divider(height: AppSpacing.xl),
                            Text(
                              item.translationFr!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.md),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${item.source} - ${item.reference}",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(delay: (index * 100).ms)
                    .slideY(begin: 0.1, end: 0);
              },
            ),
    );
  }
}
