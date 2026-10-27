import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/data/hive_config.dart';
import '../../../core/auth/auth_provider.dart';
import '../domain/models/user_stats.dart';

final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, UserStats>((ref) {
      final userId = ref.watch(currentUserProvider)?.id ?? 'guest';
      return GamificationNotifier(userId);
    });

class GamificationNotifier extends StateNotifier<UserStats> {
  final String _userId;

  String get _statsKey => 'stats_$_userId';
  String get _moodDateKey => 'daily_mood_date_$_userId';
  String get _moodKey => 'daily_mood_$_userId';

  GamificationNotifier(this._userId)
    : super(UserStats(lastActionDate: DateTime.now())) {
    _init();
  }

  Future<Box<UserStats>> _statsBox() async {
    if (Hive.isBoxOpen(HiveConfig.userStatsBox)) {
      return Hive.box<UserStats>(HiveConfig.userStatsBox);
    }
    return Hive.openBox<UserStats>(HiveConfig.userStatsBox);
  }

  Future<void> _init() async {
    try {
      final box = await _statsBox();
      final savedStats = box.get(_statsKey);
      if (savedStats != null) {
        state = savedStats.copyWith(level: UserStats.levelForXp(savedStats.xp));
        _checkStreak();
      }
    } catch (_) {
      state = UserStats(lastActionDate: DateTime.now());
    }
  }

  void _checkStreak() {
    final now = DateTime.now();
    final lastDate = state.lastActionDate;
    final diff = now
        .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
        .inDays;

    if (diff == 1) {
      return;
    }

    if (diff > 1) {
      state = state.copyWith(streak: 0, lastActionDate: now);
      _save();
    }
  }

  Future<void> recordMood(String mood) async {
    final settings = Hive.box(HiveConfig.settingsBox);
    final todayKey =
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    final lastMoodDay = settings.get(_moodDateKey) as String?;
    final lastMood = settings.get(_moodKey) as String?;

    if (lastMood == mood && lastMoodDay == todayKey) {
      return;
    }

    final xpReward = switch (mood) {
      '🙂' => 20,
      '😐' => 10,
      '😟' => 15,
      '😣' => 25,
      _ => 5,
    };

    await settings.put(_moodKey, mood);
    await settings.put(_moodDateKey, todayKey);

    await addXp(xpReward);
    if (mood == '😟' || mood == '😣') {
      await addBadge('mood-checkin');
    }
  }

  Future<void> addXp(int amount) async {
    if (amount <= 0) return;

    final now = DateTime.now();
    final newXp = state.xp + amount;
    final newLevel = UserStats.levelForXp(newXp);

    final previousDate = DateTime(
      state.lastActionDate.year,
      state.lastActionDate.month,
      state.lastActionDate.day,
    );
    final currentDate = DateTime(now.year, now.month, now.day);
    final streakIncrease = previousDate.isBefore(currentDate) ? 1 : 0;

    state = state.copyWith(
      xp: newXp,
      level: newLevel,
      streak: state.streak + streakIncrease,
      lastActionDate: now,
    );

    await _save();
  }

  Future<void> addBadge(String badgeId) async {
    if (!state.badgeIds.contains(badgeId)) {
      final newList = List<String>.from(state.badgeIds)..add(badgeId);
      state = state.copyWith(badgeIds: newList);
      await _save();
    }
  }

  Future<void> _save() async {
    final box = await _statsBox();
    await box.put(_statsKey, state);
  }
}
