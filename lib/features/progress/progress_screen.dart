import '../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';
import '../../generated/l10n/app_localizations.dart';
import 'providers/gamification_provider.dart';
import '../adaptive_assessment/presentation/providers/assessment_provider.dart';
import 'domain/models/user_stats.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final stats = ref.watch(gamificationProvider);
    final latestResult = ref.watch(latestResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.my_progress),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.trending_up),
            onPressed: () => context.push('/analytics'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProgressHeader(l10n: l10n, stats: stats),
            const SizedBox(height: AppSpacing.xl),

            if (latestResult != null) ...[
              Text(
                l10n.progressOverview,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              SindGlassCard(
                child: Column(
                  children: [
                    Text(l10n.progressDailyGoals),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/analytics'),
                      icon: const Icon(LucideIcons.search),
                      label: Text(context.l10n.auto_voir_les_analyses_dtailles),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.oliveGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],

            Text(
              l10n.weekly_goals,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            _GoalItem(title: l10n.respiration_goal, isCompleted: true),
            _GoalItem(title: l10n.spiritual_goal, isCompleted: stats.xp > 100),
            _GoalItem(
              title: l10n.progressCompanionGoal,
              isCompleted: stats.xp > 20,
            ),

            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.progressBadgesUnlocked,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            _BadgeGrid(badgeIds: stats.badgeIds),
          ],
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final dynamic stats;
  const _ProgressHeader({required this.l10n, required this.stats});

  @override
  Widget build(BuildContext context) {
    final levelLabel = _levelLabel(stats.level, l10n);
    final progress = UserStats.progressForXp(stats.xp);
    final xpToNextLevel = UserStats.xpToNextLevelFor(stats.xp);

    return SindGlassCard(
      color: AppColors.oliveGreen,
      opacity: 0.1,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.oliveGreen,
            ),
            child: const Icon(LucideIcons.medal, size: 32, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.progressLevel(stats.level, levelLabel),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.oliveGreen.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.oliveGreen,
                  ),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.progressXpToNext(xpToNextLevel),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _levelLabel(int level, AppLocalizations l10n) {
    if (level <= 1) return l10n.progress_beginner;
    if (level <= 3) return l10n.progress_explorer;
    if (level <= 6) return l10n.progress_learner;
    return l10n.progress_connoisseur;
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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.mediumRadius,
        side: BorderSide(color: Colors.grey.shade200),
      ),
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

class _BadgeGrid extends StatelessWidget {
  final List<String> badgeIds;
  const _BadgeGrid({required this.badgeIds});

  @override
  Widget build(BuildContext context) {
    final badges = [
      {
        'id': 'mood-checkin',
        'label': AppLocalizations.of(context)!.badgeMoodCheckin,
        'icon': LucideIcons.heart_pulse,
      },
      {
        'id': 'first-assessment',
        'label': AppLocalizations.of(context)!.badgeAssessment,
        'icon': LucideIcons.brain,
      },
      {
        'id': 'weekly-streak',
        'label': AppLocalizations.of(context)!.badgeStreak,
        'icon': LucideIcons.flame,
      },
      {
        'id': 'calm-breathing',
        'label': AppLocalizations.of(context)!.badgeCalm,
        'icon': LucideIcons.wind,
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.9,
      children: badges.map((badge) {
        final badgeId = badge['id'] as String;
        final isUnlocked = badgeIds.contains(badgeId);
        final icon = badge['icon'] as IconData;

        return Column(
          children: [
            Icon(
              icon,
              color: isUnlocked ? Colors.amber : Colors.grey.shade300,
              size: 30,
            ),
            const SizedBox(height: 4),
            Text(
              badge['label'] as String,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
