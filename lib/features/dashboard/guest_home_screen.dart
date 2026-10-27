import '../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';
import '../adaptive_assessment/presentation/providers/assessment_provider.dart';

class GuestHomeScreen extends ConsumerWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.warmBeige,
            actions: [
              const _LanguageSwitcher(),
              IconButton(
                onPressed: () => context.push('/login'),
                icon: const Icon(LucideIcons.circle_user),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.guestTitle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.softOlive.withOpacity(0.2),
                      AppColors.warmBeige,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: const Icon(
                    LucideIcons.leaf,
                    size: 60,
                    color: AppColors.oliveGreen,
                  ).animate().scale().fadeIn(),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  l10n.welcomeGuest,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn().slideX(),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.guestSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: AppSpacing.xl),

                _FeatureCard(
                  title: l10n.assessment,
                  description: l10n.assessmentDesc,
                  icon: LucideIcons.clipboard_check,
                  color: AppColors.oliveGreen,
                  onTap: () {
                    ref.read(assessmentProvider.notifier).startSession("guest");
                    context.push('/assessment');
                  },
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

                _FeatureCard(
                  title: l10n.resources,
                  description: l10n.resourcesDesc,
                  icon: LucideIcons.book_open,
                  color: AppColors.skyBlue,
                  onTap: () => context.push('/resources'),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),

                _FeatureCard(
                  title: l10n.history,
                  description: l10n.noAssessmentsYet,
                  icon: LucideIcons.history,
                  color: AppColors.deepOlive,
                  onTap: () => context.push('/history'),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppSpacing.xl),
                _DailyAdviceCard(l10n: l10n).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: AppSpacing.xxl),

                TextButton(
                  onPressed: () => context.push('/privacy'),
                  child: Text(
                    l10n.privacyPolicy,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      shape: RoundedRectangleBorder(borderRadius: AppRadii.largeRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.largeRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: AppRadii.mediumRadius,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevron_right,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyAdviceCard extends StatelessWidget {
  final AppLocalizations l10n;
  const _DailyAdviceCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return SindGlassCard(
      color: AppColors.oliveGreen,
      opacity: 0.05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.sparkles,
                color: AppColors.oliveGreen,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.adviceTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.oliveGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.dailyAdvice, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _LanguageSwitcher extends ConsumerWidget {
  const _LanguageSwitcher();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return PopupMenuButton<Locale>(
      icon: const Icon(LucideIcons.languages, color: AppColors.textPrimary),
      onSelected: (locale) =>
          ref.read(localeProvider.notifier).setLocale(locale),
      itemBuilder: (context) => [
        PopupMenuItem(value: const Locale('fr'), child: Text(context.l10n.auto_franais)),
        PopupMenuItem(value: const Locale('ar'), child: Text(context.l10n.auto_auto_text_0)),
      ],
    );
  }
}
