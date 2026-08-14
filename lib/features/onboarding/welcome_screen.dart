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
        title: "Bienvenue dans سند (SIND)",
        description: "Votre compagnon pour comprendre vos émotions et trouver la sérénité au quotidien.",
        icon: LucideIcons.heart_handshake,
        color: AppColors.oliveGreen,
      ),
      _OnboardingStep(
        title: "Une écoute profonde",
        description: "Plus qu'un simple test, NeuroSync explore vos dimensions émotionnelles, sociales et spirituelles.",
        icon: LucideIcons.waves,
        color: AppColors.skyBlue,
      ),
      _OnboardingStep(
        title: "Des conseils sur mesure",
        description: "Recevez des recommandations personnalisées, des micro-actions et des ressources inspirantes.",
        icon: LucideIcons.sparkles,
        color: AppColors.softOlive,
      ),
      _OnboardingStep(
        title: "Confidentialité absolue",
        description: "Vos données restent sur votre appareil. Vous avancez en toute sécurité et anonymat.",
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
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: onboardingSteps.length,
                    itemBuilder: (context, index) {
                      final step = onboardingSteps[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: AppSpacing.xxl),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.xxl),
                              decoration: BoxDecoration(
                                color: step.color.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: step.color.withOpacity(0.2), width: 2),
                              ),
                              child: Icon(step.icon, size: 100, color: step.color),
                            ).animate(key: ValueKey(index)).scale(duration: 800.ms, curve: Curves.easeOutBack).fadeIn(),
                            const SizedBox(height: AppSpacing.xxl * 1.5),
                            Text(
                              step.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ).animate(key: ValueKey("t_$index")).fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              step.description,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ).animate(key: ValueKey("d_$index")).fadeIn(delay: 400.ms),
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
                        color: _currentPage == index ? onboardingSteps[index].color : AppColors.textMuted.withOpacity(0.2),
                        borderRadius: AppRadii.pillRadius,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xxl),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: _currentPage == onboardingSteps.length - 1
                      ? Column(
                          children: [
                            SindPrimaryButton(
                              label: l10n.continueAsGuest,
                              onPressed: () => context.push('/guest/intro'),
                            ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                            const SizedBox(height: AppSpacing.md),
                            TextButton(
                              onPressed: () => context.push('/login'),
                              child: Text(
                                l10n.login,
                                style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
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
