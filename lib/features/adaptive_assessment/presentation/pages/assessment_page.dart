import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/tokens/app_colors.dart';
import '../../../../core/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/sind_components.dart';
import '../../../../core/auth/auth_provider.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../providers/assessment_provider.dart';
import '../widgets/question_card.dart';
import 'results_page.dart';

class AssessmentPage extends ConsumerStatefulWidget {
  final int? initialConcern;

  const AssessmentPage({super.key, this.initialConcern});

  @override
  ConsumerState<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends ConsumerState<AssessmentPage> {
  @override
  void initState() {
    super.initState();
    // Auto-start session if it's null (e.g. direct deep link or state loss)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(assessmentProvider);
      // The situation selector explicitly chose the anger/conflict path.  A
      // guest introduction may already have prepared a generic session, so
      // restart it here to preserve that explicit routing choice.
      if (widget.initialConcern != null ||
          (state.session == null && !state.isLoading)) {
        final user = ref.read(currentUserProvider);
        ref
            .read(assessmentProvider.notifier)
            .startSession(
              user?.id ?? "guest",
              initialConcern: widget.initialConcern,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assessmentProvider);
    final l10n = AppLocalizations.of(context)!;

    if (state.result != null) {
      return const ResultsPage();
    }

    if (state.isLoading || state.currentQuestion == null) {
      return Scaffold(
        backgroundColor: AppColors.warmBeige,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.oliveGreen),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.encouragementMessageShort),
              const SizedBox(height: AppSpacing.xxl),
              TextButton(
                onPressed: () => context.go('/'),
                child: Text(l10n.quitAssessment),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = state.currentQuestion!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.assessment_app_bar_title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SindProgressBar(
              value: (state.session?.questionIds.length ?? 0) / 15,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFDF7F2), AppColors.warmBeige],
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
                      l10n.stepCounter(
                        state.session?.questionIds.length ?? 0,
                        15,
                      ),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: 400.ms,
                    child: QuestionCard(
                      key: ValueKey(currentQuestion.id),
                      question: currentQuestion,
                      onAnswer: (value) {
                        ref
                            .read(assessmentProvider.notifier)
                            .answerQuestion(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextButton(
                  onPressed: () => context.go('/'),
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
}
