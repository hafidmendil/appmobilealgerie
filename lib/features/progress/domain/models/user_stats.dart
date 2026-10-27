import 'package:hive/hive.dart';

part 'user_stats.g.dart';

// Type 20 is used by EvidenceLevel.  Keep progress data on a distinct id.
@HiveType(typeId: 27)
class UserStats extends HiveObject {
  static const int xpPerLevel = 500;

  @HiveField(0)
  final int xp;

  @HiveField(1)
  final int level;

  @HiveField(2)
  final int streak;

  @HiveField(3)
  final List<String> badgeIds;

  @HiveField(4)
  final DateTime lastActionDate;

  UserStats({
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    this.badgeIds = const [],
    required this.lastActionDate,
  });

  static int levelForXp(int xp) {
    if (xp < 0) return 1;
    return 1 + (xp ~/ xpPerLevel);
  }

  static int xpToNextLevelFor(int xp) {
    final remainingInCurrentLevel = xp % xpPerLevel;
    return xpPerLevel - remainingInCurrentLevel;
  }

  static double progressForXp(int xp) {
    final currentLevelXp = xp % xpPerLevel;
    return currentLevelXp / xpPerLevel;
  }

  UserStats copyWith({
    int? xp,
    int? level,
    int? streak,
    List<String>? badgeIds,
    DateTime? lastActionDate,
  }) {
    return UserStats(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      badgeIds: badgeIds ?? this.badgeIds,
      lastActionDate: lastActionDate ?? this.lastActionDate,
    );
  }
}
