import 'package:json_annotation/json_annotation.dart';

part 'health_learning_progress.g.dart';

enum LearningLevel {
  beginner,
  explorer,
  learner,
  connoisseur,
}

@JsonSerializable()
class HealthLearningProgress {
  final String userId;
  final List<String> completedLessons;
  final List<String> completedQuizzes;
  final List<String> favoriteItems;
  final List<String> readingHistory;
  final int knowledgeScore;
  final List<String> badges;
  final LearningLevel currentLevel;

  HealthLearningProgress({
    required this.userId,
    this.completedLessons = const [],
    this.completedQuizzes = const [],
    this.favoriteItems = const [],
    this.readingHistory = const [],
    this.knowledgeScore = 0,
    this.badges = const [],
    this.currentLevel = LearningLevel.beginner,
  });

  factory HealthLearningProgress.fromJson(Map<String, dynamic> json) => _$HealthLearningProgressFromJson(json);
  Map<String, dynamic> toJson() => _$HealthLearningProgressToJson(this);

  HealthLearningProgress copyWith({
    List<String>? completedLessons,
    List<String>? completedQuizzes,
    List<String>? favoriteItems,
    List<String>? readingHistory,
    int? knowledgeScore,
    List<String>? badges,
    LearningLevel? currentLevel,
  }) {
    return HealthLearningProgress(
      userId: userId,
      completedLessons: completedLessons ?? this.completedLessons,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      favoriteItems: favoriteItems ?? this.favoriteItems,
      readingHistory: readingHistory ?? this.readingHistory,
      knowledgeScore: knowledgeScore ?? this.knowledgeScore,
      badges: badges ?? this.badges,
      currentLevel: currentLevel ?? this.currentLevel,
    );
  }
}
