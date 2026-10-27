class MoodCheckIn {
  final String id;
  final String userId;
  final DateTime date;
  final int mood;
  final int energy;
  final int stress;
  final int sleep;
  final int motivation;
  final String? notes;

  const MoodCheckIn({
    required this.id,
    required this.userId,
    required this.date,
    required this.mood,
    required this.energy,
    required this.stress,
    required this.sleep,
    required this.motivation,
    this.notes,
  });

  MoodCheckIn copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? mood,
    int? energy,
    int? stress,
    int? sleep,
    int? motivation,
    String? notes,
  }) {
    return MoodCheckIn(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      stress: stress ?? this.stress,
      sleep: sleep ?? this.sleep,
      motivation: motivation ?? this.motivation,
      notes: notes ?? this.notes,
    );
  }
}
