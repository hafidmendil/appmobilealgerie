import '../models/protection_models.dart';
import '../../data/protection_question_bank.dart';
import 'red_flag_engine.dart';

class ProtectionQuestion {
  final String id;
  final String textFr;
  final String textAr;
  final int priority;
  final Set<ViolenceType> categories;
  final String? dependsOn;
  final bool isRedFlagCandidate;

  const ProtectionQuestion({
    required this.id,
    required this.textFr,
    required this.textAr,
    required this.priority,
    this.categories = const {},
    this.dependsOn,
    this.isRedFlagCandidate = false,
  });
}

class AdaptiveProtectionQuestionEngine {
  final RedFlagEngine redFlagEngine;

  const AdaptiveProtectionQuestionEngine({
    this.redFlagEngine = const RedFlagEngine(),
  });

  ProtectionQuestion? next({
    required Set<ViolenceType> categories,
    required Map<String, AnswerValue> answers,
  }) {
    // 1. Critical Interruption Logic
    if (redFlagEngine.hasCriticalRedFlag(answers)) {
      return null;
    }

    // 2. Filter candidates based on: Not asked AND (Universal OR Category match)
    final candidates = ProtectionQuestionBank.questions.where((question) {
      if (answers.containsKey(question.id)) return false;
      if (question.categories.isEmpty) return true;
      return question.categories.any((c) => categories.contains(c));
    }).toList();

    if (candidates.isEmpty) return null;

    // 3. Dynamic Scoring Logic
    final scores = <String, double>{};
    for (var q in candidates) {
      double score = q.priority.toDouble();
      
      // Category Relevance Boost
      if (q.categories.any((c) => categories.contains(c))) {
        score += 200;
      }

      // Red Flag Candidate Boost (Safety first)
      if (q.isRedFlagCandidate) {
        score += 150;
      }

      scores[q.id] = score;
    }

    // 4. Sort and return the most relevant question
    candidates.sort((a, b) => (scores[b.id] ?? 0).compareTo(scores[a.id] ?? 0));

    return candidates.first;
  }
}

