import '../../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import '../../domain/models/legal_models.dart';
import '../providers/legal_providers.dart';
import '../../data/legal_question_bank.dart';

class LegalQuestionnairePage extends ConsumerStatefulWidget {
  const LegalQuestionnairePage({super.key});

  @override
  ConsumerState<LegalQuestionnairePage> createState() =>
      _LegalQuestionnairePageState();
}

class _LegalQuestionnairePageState
    extends ConsumerState<LegalQuestionnairePage> {
  int _currentIndex = 0;

  List<LegalQuestion> get _visibleQuestions {
    final answers = ref.watch(legalQuestionnaireAnswersProvider);
    return LegalQuestionBank.questions.where((q) {
      if (q.dependsOn == null) return true;
      final parentValue = answers[q.dependsOn];
      return q.requiredValues?.contains(parentValue) ?? false;
    }).toList();
  }

  void _nextStep() {
    final questions = _visibleQuestions;
    if (_currentIndex < questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _finishQuestionnaire();
    }
  }

  void _previousStep() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _finishQuestionnaire() {
    context.push('/legal/result');
  }

  @override
  Widget build(BuildContext context) {
    final questions = _visibleQuestions;
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Guard against index out of bounds if questions list changes dynamically
    if (_currentIndex >= questions.length) {
      _currentIndex = questions.length - 1;
    }

    final currentQ = questions[_currentIndex];
    final isArabic = context.isRTL;
    final selectedAnswers = ref.watch(legalQuestionnaireAnswersProvider);
    final dynamic selectedVal = selectedAnswers[currentQ.id];

    final progress = (_currentIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.legal_assessment_title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? currentQ.titleAr : currentQ.titleFr,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic ? currentQ.subtitleAr : currentQ.subtitleFr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 32),
                  ...currentQ.options.map((option) {
                    final isSelected = selectedVal == option.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(legalQuestionnaireAnswersProvider.notifier)
                              .updateAnswer(currentQ.id, option.value);
                          // We don't auto-advance here to let user see selection, 
                          // or we can auto-advance if it's a simple choice.
                          // Most Flutter questionnaires auto-advance on radio-like buttons.
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) _nextStep();
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.05)
                                : null,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  isArabic ? option.labelAr : option.labelFr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  TextButton.icon(
                    onPressed: _previousStep,
                    icon: Icon(
                      isArabic ? Icons.arrow_forward : Icons.arrow_back,
                    ),
                    label: Text(context.l10n.previous),
                  )
                else
                  const SizedBox.shrink(),
                if (selectedVal != null)
                  FilledButton(
                    onPressed: _nextStep,
                    child: Text(
                      _currentIndex == questions.length - 1
                          ? context.l10n.finish
                          : context.l10n.next,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
