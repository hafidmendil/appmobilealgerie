import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';
import '../adaptive_assessment/domain/engines/spiritual_support_engine.dart';
import '../adaptive_assessment/domain/models/assessment_axis.dart';

class SpiritualScreen extends ConsumerWidget {
  const SpiritualScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, we'd get needs from the assessment state
    final engine = SpiritualSupportEngine();
    final content = engine.getRelevantContent({
      AssessmentAxis.stressAnxiety: 0.5, // Mock data
    });

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        title: const Text("🤲 سند الروحي"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            Text(
              "Un moment de paix et de réflexion",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ).animate().fadeIn(),
            const SizedBox(height: AppSpacing.xl),
            
            ...content.map((item) {
              return SindGlassCard(
                color: Colors.white,
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Text(
                      item.titleAr,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepOlive,
                        fontFamily: 'NotoSansArabic',
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      item.contentAr,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.textPrimary,
                        height: 1.6,
                        fontFamily: 'NotoSansArabic',
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Divider(color: AppColors.oliveGreen, thickness: 0.5),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      item.translationFr ?? "",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      "${item.source} - ${item.reference}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
            }).toList(),
            
            const SizedBox(height: AppSpacing.xxl),
            
            SindSecondaryButton(
              label: "Fermer",
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
