import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/localization/l10n_helper.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';
import 'assessment_models.dart';
import 'assessment_state.dart';

class AssessmentScreen extends ConsumerStatefulWidget {
  const AssessmentScreen({super.key});

  @override
  ConsumerState<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends ConsumerState<AssessmentScreen> {
  final TextEditingController _finalMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(assessmentProvider);
    final notifier = ref.read(assessmentProvider.notifier);

    if (state.isCompleted || state.result != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/results');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentQuestion = state.currentQuestion;
    
    // Final Message logic: after 15 questions or when engine is done
    if (state.path.length >= 15 && !state.answers.containsKey('final_message_done')) {
       return _FinalMessagePage(
         controller: _finalMessageController,
         onContinue: (message) {
           notifier.setFinalMessage(message);
           notifier.setAnswer('final_message_done', 1);
           notifier.nextStep();
         },
         onSkip: () {
           notifier.setFinalMessage("");
           notifier.setAnswer('final_message_done', 1);
           notifier.nextStep();
         },
       );
    }

    if (currentQuestion == null) {
       return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("SIND"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SindProgressBar(
              value: state.progress,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _getModuleColor(currentQuestion.module).withOpacity(0.05),
              AppColors.warmBeige,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.stepCounter(state.path.length, 15),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
                    ),
                    if (currentQuestion.whyKey != null)
                      IconButton(
                        icon: const Icon(LucideIcons.circle_question_mark, size: 22, color: AppColors.textMuted),
                        onPressed: () => _showWhyDialog(context, l10n, currentQuestion.whyKey!),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: 500.ms,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey(currentQuestion.id),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (currentQuestion.isSafety) ...[
                                Center(child: _SafetyBadge(l10n: l10n)),
                                const SizedBox(height: AppSpacing.lg),
                              ],
                              SindGlassCard(
                                padding: const EdgeInsets.all(AppSpacing.xl),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.translate(currentQuestion.textKey),
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xxl),
                                    ...currentQuestion.options.map((opt) {
                                      final isSelected = state.answers[currentQuestion.id] == opt.value;
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                        child: SindAnswerOption(
                                          label: l10n.translate(opt.textKey),
                                          isSelected: isSelected,
                                          isSafetyTrigger: opt.isSafetyTrigger,
                                          onTap: () {
                                             notifier.setAnswer(currentQuestion.id, opt.value);
                                             // Auto-advance for better flow if not the first time
                                             Future.delayed(300.ms, () => _handleNext(context));
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    if (state.path.length > 1)
                      Expanded(
                        child: SindSecondaryButton(
                          label: l10n.previous,
                          onPressed: () => notifier.prevStep(),
                        ),
                      ),
                    if (state.path.length > 1) const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: SindPrimaryButton(
                        label: l10n.next,
                        onPressed: state.answers.containsKey(currentQuestion.id)
                            ? () => _handleNext(context)
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () {
                     notifier.reset();
                     context.go('/');
                  },
                  child: Text(
                    l10n.quitAssessment, 
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNext(BuildContext context) {
    final state = ref.read(assessmentProvider);
    final notifier = ref.read(assessmentProvider.notifier);
    
    if (state.path.length == 5 || state.path.length == 10) {
       _showEncouragement(context);
    }
    notifier.nextStep();
  }

  Color _getModuleColor(QuestionModule module) {
    switch (module) {
      case QuestionModule.stress: return AppColors.skyBlue;
      case QuestionModule.emotions: return AppColors.danger;
      case QuestionModule.spiritual: return AppColors.softOlive;
      case QuestionModule.safety: return AppColors.danger;
      default: return AppColors.oliveGreen;
    }
  }

  void _showWhyDialog(BuildContext context, AppLocalizations l10n, String whyKey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(LucideIcons.info, color: AppColors.info),
            const SizedBox(width: AppSpacing.sm),
            Text(l10n.explanation),
          ],
        ),
        content: Text(l10n.translate(whyKey)),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.largeRadius),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
        ],
      ),
    );
  }

  void _showEncouragement(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.encouragementMessage),
        duration: 2.seconds,
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.oliveGreen,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mediumRadius),
      ),
    );
  }
}

class _SafetyBadge extends StatelessWidget {
  final AppLocalizations l10n;
  const _SafetyBadge({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: AppRadii.pillRadius,
        border: Border.all(color: AppColors.danger.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.triangle_alert, color: AppColors.danger, size: 16),
          const SizedBox(width: AppSpacing.xs),
          Text(
            l10n.redFlagWarning,
            style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FinalMessagePage extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onContinue;
  final VoidCallback onSkip;

  const _FinalMessagePage({
    required this.controller,
    required this.onContinue,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.feather, size: 80, color: AppColors.oliveGreen)
                  .animate().fadeIn(duration: 1.seconds).scale(delay: 200.ms),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.finalMessageTitle,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.finalMessageSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary, height: 1.5),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: AppSpacing.xxl * 1.5),
              SindGlassCard(
                padding: EdgeInsets.zero,
                child: TextField(
                  controller: controller,
                  maxLines: 5,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: l10n.finalMessageHint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(AppSpacing.xl),
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
              const SizedBox(height: AppSpacing.xxl),
              SindPrimaryButton(
                label: l10n.continueLabel,
                onPressed: () => onContinue(controller.text),
              ).animate().fadeIn(delay: 1.seconds),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: onSkip,
                child: Text(l10n.skip, style: const TextStyle(color: AppColors.textMuted)),
              ).animate().fadeIn(delay: 1200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
