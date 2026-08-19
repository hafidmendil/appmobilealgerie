import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class ResilienceTask {
  final String id;
  final String title;
  final String icon;
  final bool isCompleted;

  ResilienceTask({required this.id, required this.title, required this.icon, this.isCompleted = false});

  ResilienceTask copyWith({bool? isCompleted}) {
    return ResilienceTask(
      id: id,
      title: title,
      icon: icon,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class DailyResilienceState {
  final List<ResilienceTask> tasks;
  final int treeLevel;

  DailyResilienceState({required this.tasks, required this.treeLevel});

  double get progress => tasks.isEmpty ? 0 : tasks.where((t) => t.isCompleted).length / tasks.length;
}

class DailyResilienceNotifier extends StateNotifier<DailyResilienceState> {
  DailyResilienceNotifier() : super(DailyResilienceState(
    tasks: [
      ResilienceTask(id: '1', title: '5 min Respiration', icon: '🫁'),
      ResilienceTask(id: '2', title: 'Lire une Hikma', icon: '📚'),
      ResilienceTask(id: '3', title: 'Action de gratitude', icon: '🙏'),
    ],
    treeLevel: 1,
  ));

  void toggleTask(String id) {
    state = DailyResilienceState(
      tasks: state.tasks.map((t) => t.id == id ? t.copyWith(isCompleted: !t.isCompleted) : t).toList(),
      treeLevel: state.treeLevel,
    );
    
    if (state.progress == 1.0) {
       // Grow tree logic
    }
  }
}

final dailyResilienceProvider = StateNotifierProvider<DailyResilienceNotifier, DailyResilienceState>((ref) {
  return DailyResilienceNotifier();
});
