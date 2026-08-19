import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/confidence_entry.dart';
import 'package:uuid/uuid.dart';

final confidenceEntriesProvider = StateNotifierProvider<ConfidenceNotifier, List<ConfidenceEntry>>((ref) {
  return ConfidenceNotifier();
});

class ConfidenceNotifier extends StateNotifier<List<ConfidenceEntry>> {
  ConfidenceNotifier() : super([]) {
    _init();
  }

  static const String _boxName = 'confidence_box';

  Future<void> _init() async {
    final box = await Hive.openBox<ConfidenceEntry>(_boxName);
    state = box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addEntry({
    required String strength,
    required String success,
    required String goal,
  }) async {
    final entry = ConfidenceEntry(
      id: const Uuid().v4(),
      date: DateTime.now(),
      strength: strength,
      success: success,
      goal: goal,
    );

    final box = Hive.box<ConfidenceEntry>(_boxName);
    await box.add(entry);
    state = [entry, ...state];
  }

  Future<void> deleteEntry(String id) async {
    final box = Hive.box<ConfidenceEntry>(_boxName);
    final key = box.values.firstWhere((e) => e.id == id).key;
    await box.delete(key);
    state = state.where((e) => e.id != id).toList();
  }
}
