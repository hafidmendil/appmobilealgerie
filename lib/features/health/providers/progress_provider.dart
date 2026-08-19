import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/health/models/health_learning_progress.dart';

final healthProgressProvider = StateNotifierProvider<HealthProgressNotifier, HealthLearningProgress>((ref) {
  return HealthProgressNotifier();
});

class HealthProgressNotifier extends StateNotifier<HealthLearningProgress> {
  HealthProgressNotifier() : super(HealthLearningProgress(userId: 'current_user'));

  void completeLesson(String lessonId) {
    if (!state.completedLessons.contains(lessonId)) {
      final newScore = state.knowledgeScore + 10;
      state = state.copyWith(
        completedLessons: [...state.completedLessons, lessonId],
        knowledgeScore: newScore,
        currentLevel: _calculateLevel(newScore),
      );
    }
  }

  void completeQuiz(String quizId, int score) {
    if (!state.completedQuizzes.contains(quizId)) {
      final newScore = state.knowledgeScore + score;
      state = state.copyWith(
        completedQuizzes: [...state.completedQuizzes, quizId],
        knowledgeScore: newScore,
        currentLevel: _calculateLevel(newScore),
      );
    }
  }

  LearningLevel _calculateLevel(int score) {
    if (score > 300) return LearningLevel.connoisseur;
    if (score > 150) return LearningLevel.learner;
    if (score > 50) return LearningLevel.explorer;
    return LearningLevel.beginner;
  }
}
