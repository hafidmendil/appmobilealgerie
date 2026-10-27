import '../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/localization/locale_provider.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final onboardingSteps = [
      _OnboardingStep(
        title: l10n.welcomeMessage,
        description: l10n.guestSubtitle,
        icon: LucideIcons.heart_handshake,
        color: AppColors.oliveGreen,
      ),
      _OnboardingStep(
        title: l10n.assessment,
        description: l10n.assessmentDesc,
        icon: LucideIcons.waves,
        color: AppColors.skyBlue,
      ),
      _OnboardingStep(
        title: l10n.adviceTitle,
        description: l10n.dailyAdvice,
        icon: LucideIcons.sparkles,
        color: AppColors.softOlive,
      ),
      _OnboardingStep(
        title: l10n.anonymityTitle,
        description: l10n.anonymityDesc,
        icon: LucideIcons.shield_check,
        color: AppColors.success,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background,
                    onboardingSteps[_currentPage].color.withOpacity(0.05),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

          // Language Switcher
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [const _LanguageSwitcher()],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: onboardingSteps.length,
                    itemBuilder: (context, index) {
                      final step = onboardingSteps[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxl,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: AppSpacing.xxl),
                            Container(
                                  padding: const EdgeInsets.all(AppSpacing.xxl),
                                  decoration: BoxDecoration(
                                    color: step.color.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: step.color.withOpacity(0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    step.icon,
                                    size: 100,
                                    color: step.color,
                                  ),
                                )
                                .animate(key: ValueKey(index))
                                .scale(
                                  duration: 800.ms,
                                  curve: Curves.easeOutBack,
                                )
                                .fadeIn(),
                            const SizedBox(height: AppSpacing.xxl * 1.5),
                            Text(
                                  step.title,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                )
                                .animate(key: ValueKey("t_$index"))
                                .fadeIn(delay: 200.ms)
                                .slideY(begin: 0.1, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                                  step.description,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        height: 1.5,
                                      ),
                                )
                                .animate(key: ValueKey("d_$index"))
                                .fadeIn(delay: 400.ms),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Pagination dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingSteps.length,
                    (index) => AnimatedContainer(
                      duration: 400.ms,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: _currentPage == index ? 32 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? onboardingSteps[index].color
                            : AppColors.textMuted.withOpacity(0.2),
                        borderRadius: AppRadii.pillRadius,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                  ),
                  child: _currentPage == onboardingSteps.length - 1
                      ? Column(
                          children: [
                            SindPrimaryButton(
                              label: l10n.continueAsGuest,
                              onPressed: () => context.go('/guest/intro'),
                            ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.md),
                            SindSecondaryButton(
                              label: l10n.register_button,
                              onPressed: () => context.push('/register'),
                            ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.md),
                            TextButton(
                              onPressed: () => context.push('/login'),
                              child: Text(
                                l10n.login,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push('/setup-admin'),
                              child: Text(
                                l10n.offlineAdminSetup,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SindPrimaryButton(
                          label: l10n.next,
                          onPressed: () => _pageController.nextPage(
                            duration: 500.ms,
                            curve: Curves.easeInOutCubic,
                          ),
                        ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
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
        PopupMenuItem(
          value: const Locale('fr'),
          child: Text(context.l10n.auto_franais),
        ),
        PopupMenuItem(
          value: const Locale('ar'),
          child: Text(context.l10n.auto_auto_text_0),
        ),
      ],
    );
  }
}
