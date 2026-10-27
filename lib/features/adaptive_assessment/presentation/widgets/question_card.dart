import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/theme/tokens/app_colors.dart';
import '../../../../core/theme/tokens/app_spacing.dart';
import '../../../../core/theme/tokens/app_radii.dart';
import '../../../../core/widgets/sind_components.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../domain/models/assessment_question.dart';

import '../../domain/models/assessment_axis.dart';

class QuestionCard extends StatelessWidget {
  final AssessmentQuestion question;
  final Function(int?) onAnswer;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (question.safetyLevel != SafetyLevel.none) ...[
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withAlpha(25),
                    borderRadius: AppRadii.pillRadius,
                    border: Border.all(
                      color: AppColors.danger.withAlpha(76),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.triangle_alert,
                        color: AppColors.danger,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        l10n.redFlagWarning,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            SindGlassCard(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getAxisIcon(question.axis),
                        color: AppColors.oliveGreen,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.clinical_question_label,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isRtl ? question.textAr : question.textFr,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  ...question.options.map(
                    (option) => _buildOptionButton(context, option),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAxisIcon(AssessmentAxis axis) {
    switch (axis) {
      case AssessmentAxis.emotions:
        return LucideIcons.heart;
      case AssessmentAxis.stressAnxiety:
        return LucideIcons.wind;
      case AssessmentAxis.sleepEnergy:
        return LucideIcons.moon;
      case AssessmentAxis.productivity:
        return LucideIcons.briefcase;
      case AssessmentAxis.socialSupport:
        return LucideIcons.users;
      case AssessmentAxis.selfConfidence:
        return LucideIcons.sparkles;
      default:
        return LucideIcons.brain;
    }
  }

  Widget _buildOptionButton(BuildContext context, AssessmentOption option) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final String label = isRtl ? option.textAr : option.textFr;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: SindAnswerOption(
        label: label,
        isSelected:
            false, // In adaptive engine, we move to next question immediately
        isSafetyTrigger: option.isSafetyTrigger,
        onTap: () => onAnswer(option.value),
      ),
    );
  }
}
