import 'package:flutter/material.dart';
import '../../domain/models/assessment_question.dart';

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

    return Card(
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isRtl ? question.textAr : question.textFr,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (isRtl && question.textDarja != null)
              Text(
                question.textDarja!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 30),
            ...question.options.map((option) => _buildOptionButton(context, option)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, AssessmentOption option) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final String text = isRtl ? (option.textDarja ?? option.textAr) : option.textFr;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
            ),
            backgroundColor: option.value == null 
                ? Theme.of(context).colorScheme.surfaceVariant 
                : Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            elevation: 2,
          ),
          onPressed: () => onAnswer(option.value),
          child: Text(
            text, 
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
