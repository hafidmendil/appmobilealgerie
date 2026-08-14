import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';
import '../../generated/l10n/app_localizations.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ma Progression"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProgressHeader(),
            const SizedBox(height: AppSpacing.xl),
            _SectionTitle(title: "Évolution du Bien-être"),
            const SizedBox(height: AppSpacing.md),
            _PlaceholderChart(),
            const SizedBox(height: AppSpacing.xl),
            _SectionTitle(title: "Objectifs de la semaine"),
            const SizedBox(height: AppSpacing.md),
            _GoalItem(title: "3 séances de respiration", isCompleted: true),
            _GoalItem(title: "Lire un verset inspirant par jour", isCompleted: false),
            _GoalItem(title: "Appeler un proche", isCompleted: false),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SindGlassCard(
      color: AppColors.oliveGreen,
      opacity: 0.1,
      child: Row(
        children: [
          const Icon(LucideIcons.medal, size: 48, color: AppColors.oliveGreen),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Niveau 4 - Explorateur", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: AppColors.oliveGreen.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation(AppColors.oliveGreen),
                ),
                const SizedBox(height: 4),
                const Text("450 pts avant le prochain niveau", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.textMuted.withOpacity(0.05),
        borderRadius: AppRadii.largeRadius,
        border: Border.all(color: AppColors.textMuted.withOpacity(0.1)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.trending_up, color: AppColors.textMuted.withOpacity(0.3), size: 48),
            const SizedBox(height: AppSpacing.md),
            const Text("Graphique d'évolution à venir", style: TextStyle(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _GoalItem extends StatelessWidget {
  final String title;
  final bool isCompleted;

  const _GoalItem({required this.title, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          isCompleted ? LucideIcons.circle_check : LucideIcons.circle,
          color: isCompleted ? AppColors.success : AppColors.textMuted,
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? AppColors.textMuted : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
