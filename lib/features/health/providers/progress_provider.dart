import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/features/health/models/health_learning_progress.dart';

final healthProgressProvider =
    StateNotifierProvider<HealthProgressNotifier, HealthLearningProgress>((
      ref,
    ) {
      return HealthProgressNotifier();
    });

class HealthProgressNotifier extends StateNotifier<HealthLearningProgress> {
  HealthProgressNotifier()
    : super(HealthLearningProgress(userId: 'current_user')) {
    _init();
  }

  Future<void> _init() async {
    final box = Hive.box<HealthLearningProgress>(HiveConfig.healthProgressBox);
    if (box.isNotEmpty) {
      state = box.getAt(0)!;
    }
  }

  Future<void> completeLesson(String lessonId) async {
    if (!state.completedLessons.contains(lessonId)) {
      final newScore = state.knowledgeScore + 10;
      final newState = state.copyWith(
        completedLessons: [...state.completedLessons, lessonId],
        knowledgeScore: newScore,
        currentLevel: _calculateLevel(newScore),
      );
      state = newState;
      await _save();
    }
  }

  Future<void> completeQuiz(String quizId, int score) async {
    if (!state.completedQuizzes.contains(quizId)) {
      final newScore = state.knowledgeScore + score;
      final newState = state.copyWith(
        completedQuizzes: [...state.completedQuizzes, quizId],
        knowledgeScore: newScore,
        currentLevel: _calculateLevel(newScore),
      );
      state = newState;
      await _save();
    }
  }

  Future<void> _save() async {
    final box = Hive.box<HealthLearningProgress>(HiveConfig.healthProgressBox);
    if (box.isEmpty) {
      await box.add(state);
    } else {
      await box.putAt(0, state);
    }
  }

  LearningLevel _calculateLevel(int score) {
    if (score > 300) return LearningLevel.connoisseur;
    if (score > 150) return LearningLevel.learner;
    if (score > 50) return LearningLevel.explorer;
    return LearningLevel.beginner;
  }
}
