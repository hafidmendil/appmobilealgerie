import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:projetmascara/core/theme/tokens/app_spacing.dart';
import 'package:projetmascara/core/widgets/sind_components.dart';
import 'package:projetmascara/features/health/providers/progress_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/features/health/data/health_quiz_catalog.dart';

class HealthQuizPage extends ConsumerStatefulWidget {
  final String quizId;
  const HealthQuizPage({super.key, required this.quizId});

  @override
  ConsumerState<HealthQuizPage> createState() => _HealthQuizPageState();
}

class _HealthQuizPageState extends ConsumerState<HealthQuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final questions = HealthQuizCatalog.questionsFor(widget.quizId);
    if (_currentQuestionIndex >= questions.length) {
      return _buildResultScreen();
    }

    final question = questions[_currentQuestionIndex];

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(HealthQuizCatalog.titleFor(widget.quizId, isArabic)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.stepCounter(_currentQuestionIndex + 1, questions.length),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              isArabic ? question.textAr : question.textFr,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xl),
            ...List.generate(question.optionsFr.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: SindAnswerOption(
                  label: isArabic
                      ? question.optionsAr[index]
                      : question.optionsFr[index],
                  isSelected: false,
                  onTap: () {
                    if (index == question.correctIndex) {
                      _score += 20;
                    }
                    setState(() {
                      _currentQuestionIndex++;
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.trophy, size: 80, color: Colors.orange),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.assessmentFinished,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              isArabic ? 'النتيجة: $_score نقطة' : 'Score : $_score points',
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(healthProgressProvider.notifier)
                    .completeQuiz(widget.quizId, _score);
                Navigator.pop(context);
              },
              child: Text(l10n.finish),
            ),
          ],
        ),
      ),
    );
  }
}
