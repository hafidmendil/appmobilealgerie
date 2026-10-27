import 'package:hive/hive.dart';

part 'health_learning_progress.g.dart';

@HiveType(typeId: 23)
enum LearningLevel {
  @HiveField(0)
  beginner,
  @HiveField(1)
  explorer,
  @HiveField(2)
  learner,
  @HiveField(3)
  connoisseur,
}

@HiveType(typeId: 24)
class HealthLearningProgress extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final List<String> completedLessons;

  @HiveField(2)
  final List<String> completedQuizzes;

  @HiveField(3)
  final List<String> favoriteItems;

  @HiveField(4)
  final List<String> readingHistory;

  @HiveField(5)
  final int knowledgeScore;

  @HiveField(6)
  final List<String> badges;

  @HiveField(7)
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

  factory HealthLearningProgress.fromJson(Map<String, dynamic> json) {
    return HealthLearningProgress(
      userId: json['userId'],
      completedLessons: List<String>.from(json['completedLessons'] ?? []),
      completedQuizzes: List<String>.from(json['completedQuizzes'] ?? []),
      favoriteItems: List<String>.from(json['favoriteItems'] ?? []),
      readingHistory: List<String>.from(json['readingHistory'] ?? []),
      knowledgeScore: json['knowledgeScore'] ?? 0,
      badges: List<String>.from(json['badges'] ?? []),
      currentLevel: LearningLevel.values.firstWhere(
        (e) => e.name == json['currentLevel'],
        orElse: () => LearningLevel.beginner,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'completedLessons': completedLessons,
      'completedQuizzes': completedQuizzes,
      'favoriteItems': favoriteItems,
      'readingHistory': readingHistory,
      'knowledgeScore': knowledgeScore,
      'badges': badges,
      'currentLevel': currentLevel.name,
    };
  }

  HealthLearningProgress copyWith({
    String? userId,
    List<String>? completedLessons,
    List<String>? completedQuizzes,
    List<String>? favoriteItems,
    List<String>? readingHistory,
    int? knowledgeScore,
    List<String>? badges,
    LearningLevel? currentLevel,
  }) {
    return HealthLearningProgress(
      userId: userId ?? this.userId,
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
