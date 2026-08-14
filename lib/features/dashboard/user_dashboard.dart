import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/widgets/sind_components.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../generated/l10n/app_localizations.dart';

class UserDashboard extends ConsumerWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final userName = user != null ? user.email.split('@').first : "Visiteur";

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              title: Text(
                "${l10n.greeting} $userName 👋",
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
            ),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.user),
                onPressed: () => context.push('/profile'),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Card
                  _HeroCard(l10n: l10n).animate().fadeIn().slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Daily Check-in
                  Text(
                    l10n.how_feel_today,
                    style: theme.textTheme.titleLarge,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: AppSpacing.md),
                  _DailyCheckIn(l10n: l10n).animate().fadeIn(delay: 300.ms),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Quick Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.quickActions,
                        style: theme.textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () => context.push('/history'),
                        child: Text(l10n.viewAll),
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: AppSpacing.md),
                  _QuickActionsGrid(l10n: l10n).animate().fadeIn(delay: 500.ms),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Advice of the day
                  SindGlassCard(
                    color: AppColors.softBlue,
                    child: Row(
                      children: [
                        const Icon(LucideIcons.sparkles, color: AppColors.info, size: 32),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.adviceTitle, style: theme.textTheme.titleMedium),
                              const SizedBox(height: 4),
                              Text(l10n.dailyAdvice, style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                  
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

class _HeroCard extends StatelessWidget {
  final AppLocalizations l10n;
  const _HeroCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.oliveGreen, AppColors.deepOlive],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadii.largeRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.oliveGreen.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.heart, color: Colors.white, size: 32),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.take_minutes_for_you,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () => context.push('/assessment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.oliveGreen,
              minimumSize: const Size(180, 48),
            ),
            child: Text(l10n.startAssessment),
          ),
        ],
      ),
    );
  }
}

class _DailyCheckIn extends StatelessWidget {
  final AppLocalizations l10n;
  const _DailyCheckIn({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'icon': '🙂', 'label': l10n.mood_ok},
      {'icon': '😐', 'label': l10n.mood_neutral},
      {'icon': '😟', 'label': l10n.mood_difficult},
      {'icon': '😣', 'label': l10n.mood_very_difficult},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: moods.map((mood) {
        return Expanded(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadii.mediumRadius,
                  border: Border.all(color: AppColors.textMuted.withOpacity(0.1)),
                ),
                child: Text(mood['icon']!, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                mood['label']!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final AppLocalizations l10n;
  const _QuickActionsGrid({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.4,
      children: [
        _QuickActionCard(
          title: l10n.action_assess,
          icon: LucideIcons.brain,
          color: AppColors.oliveGreen,
          onTap: () => context.push('/assessment'),
        ),
        _QuickActionCard(
          title: l10n.action_calm,
          icon: LucideIcons.wind,
          color: AppColors.skyBlue,
          onTap: () => context.push('/breathing'),
        ),
        _QuickActionCard(
          title: l10n.action_confidence,
          icon: LucideIcons.sparkles,
          color: AppColors.softOlive,
          onTap: () => context.push('/confidence'),
        ),
        _QuickActionCard(
          title: l10n.action_support,
          icon: LucideIcons.heart_handshake,
          color: AppColors.info,
          onTap: () => context.push('/spiritual'),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SindGlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.largeRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
