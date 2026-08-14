import 'dart:math';
import 'package:projetmascara/features/assessment/assessment_models.dart';
import 'package:projetmascara/features/engine/decision_engine.dart';

class AdaptiveAssessmentEngine {
  final List<Question> questionBank;

  AdaptiveAssessmentEngine({required this.questionBank});

  /// Decides the next question based on the current state of the session.
  Question? getNextQuestion(Map<String, int> answers) {
    // 1. Check for urgent safety signals first
    if (_isSafetyTriggered(answers)) {
      return null;
    }

    // Minimum Exploration Rule: Ensure at least 8 questions are asked to feel "professional"
    // unless an urgent safety trigger happened.
    final answeredCount = answers.length;

    // 2. Identify already answered questions
    final answeredIds = answers.keys.toSet();

    // 3. Filter available questions
    final availableQuestions = questionBank.where((q) {
      if (answeredIds.contains(q.id)) return false;

      if (q.condition != null) {
        final moduleScores = _calculateModuleScores(answers);
        if (!q.condition!.evaluate(answers, moduleScores)) {
          return false;
        }
      }

      return true;
    }).toList();

    if (availableQuestions.isEmpty) return null;

    // Logic for ending the assessment
    // If we have answered at least 15 questions, and scores are low, we can stop.
    if (answeredCount >= 15) {
       final totalScore = answers.values.fold(0, (sum, val) => sum + val);
       if (totalScore < 10) return null; // Early exit for healthy profiles only after 15 q
    }
    
    // Safety exit: if answeredCount >= 25, we MUST stop to avoid fatigue
    if (answeredCount >= 25) return null;

    // 4. Calculate dynamic priorities
    final priorities = <String, int>{};
    for (final q in availableQuestions) {
      int priority = q.basePriority;

      // Apply follow-up rules
      for (final rule in _getActiveFollowUpRules(answers)) {
        if (rule.targetQuestionId == q.id) {
          priority += rule.priorityBoost;
        }
      }
      
      // Boost priority of modules that have high scores
      final moduleScores = _calculateModuleScores(answers);
      if (moduleScores.containsKey(q.module)) {
        priority += (moduleScores[q.module] ?? 0) * 15; // Increased boost factor
      }
      
      // Diversity rule: boost modules that HAVEN'T been explored yet to ensure breadth
      final exploredModules = answers.keys.map((id) {
         try {
           return questionBank.firstWhere((q) => q.id == id).module;
         } catch(_) {
           return QuestionModule.general;
         }
      }).toSet();
      
      if (!exploredModules.contains(q.module)) {
         priority += 30; // Boost unexplored modules for professional breadth
      }

      priorities[q.id] = priority;
    }

    // 5. Select the question with the highest priority
    availableQuestions.sort((a, b) {
      final pA = priorities[a.id] ?? 0;
      final pB = priorities[b.id] ?? 0;
      if (pA != pB) return pB.compareTo(pA); // Descending priority
      return a.id.compareTo(b.id); // Deterministic fallback
    });

    return availableQuestions.first;
  }

  bool _isSafetyTriggered(Map<String, int> answers) {
    for (final entry in answers.entries) {
      final question = questionBank.firstWhere((q) => q.id == entry.key);
      final option = question.options.firstWhere((o) => o.value == entry.value, 
          orElse: () => Option(textKey: '', value: -1));
      if (option.isSafetyTrigger) return true;
    }
    return false;
  }

  Map<QuestionModule, int> _calculateModuleScores(Map<String, int> answers) {
    final scores = <QuestionModule, int>{};
    for (final entry in answers.entries) {
      final question = questionBank.firstWhere((q) => q.id == entry.key, 
          orElse: () => Question(id: '', textKey: '', module: QuestionModule.general));
      scores[question.module] = (scores[question.module] ?? 0) + entry.value;
    }
    return scores;
  }

  List<QuestionRule> _getActiveFollowUpRules(Map<String, int> answers) {
    final activeRules = <QuestionRule>[];
    for (final entry in answers.entries) {
      final question = questionBank.firstWhere((q) => q.id == entry.key, 
          orElse: () => Question(id: '', textKey: '', module: QuestionModule.general));
      for (final rule in question.followUpRules) {
        if (rule.triggerValues.contains(entry.value)) {
          activeRules.add(rule);
        }
      }
    }
    return activeRules;
  }

  /// Calculates multidimensional summary
  OrientationResult computeResult(Map<String, int> answers) {
    final moduleScores = _calculateModuleScores(answers);
    final justifications = <String>[];
    final strengths = <String>[];
    
    // Strengths identification
    moduleScores.forEach((module, score) {
      if (score <= 1) { // Low score means strength in this domain
        switch (module) {
          case QuestionModule.stress:
            strengths.add('strength_calm');
            break;
          case QuestionModule.relationship:
            strengths.add('strength_social_support');
            break;
          case QuestionModule.selfEsteem:
            strengths.add('strength_self_confidence');
            break;
          case QuestionModule.behavioral:
            strengths.add('strength_organization');
            break;
          default:
            break;
        }
      }
    });

    // Justifications based on module thresholds
    moduleScores.forEach((module, score) {
      if (score >= 4) {
        switch (module) {
          case QuestionModule.stress: justifications.add('high_stress_detected'); break;
          case QuestionModule.sleep: justifications.add('sleep_issues_detected'); break;
          case QuestionModule.phq4: justifications.add('mood_tension_detected'); break;
          case QuestionModule.relationship: justifications.add('relational_tension_detected'); break;
          case QuestionModule.cognitive: justifications.add('cognitive_bias_detected'); break;
          case QuestionModule.functioning: justifications.add('functioning_impact_detected'); break;
          case QuestionModule.sart: justifications.add('trauma_indicators_detected'); break;
          case QuestionModule.emotions: justifications.add('emotional_imbalance_detected'); break;
          case QuestionModule.selfEsteem: justifications.add('self_esteem_concerns'); break;
          default: break;
        }
      }
    });

    if (_isSafetyTriggered(answers)) {
      return OrientationResult(
        level: OrientationLevel.level4,
        summaryKey: 'summary_urgent_help',
        justifications: ['priority_safety_alert', ...justifications],
        strengths: strengths,
        isRedFlagTriggered: true,
        moduleScores: moduleScores,
      );
    }

    int totalScore = answers.values.fold(0, (sum, val) => sum + val);
    OrientationLevel level = OrientationLevel.level1;
    String summaryKey = 'summary_self_care';

    if (totalScore >= 40) {
      level = OrientationLevel.level3;
      summaryKey = 'summary_contact_recommended';
    } else if (totalScore >= 20) {
      level = OrientationLevel.level2;
      summaryKey = 'summary_consultation_advised';
    }

    return OrientationResult(
      level: level,
      summaryKey: summaryKey,
      justifications: justifications.isEmpty ? ['general_wellness'] : justifications,
      strengths: strengths.isEmpty ? ['strength_resilience'] : strengths,
      moduleScores: moduleScores,
      recommendations: [], // Will be filled by ResourceRecommendationEngine
    );
  }
}
