import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/confidence_entry.dart';
import 'package:uuid/uuid.dart';
import 'package:projetmascara/core/data/hive_config.dart';

final confidenceEntriesProvider =
    StateNotifierProvider<ConfidenceNotifier, List<ConfidenceEntry>>((ref) {
      return ConfidenceNotifier();
    });

class ConfidenceNotifier extends StateNotifier<List<ConfidenceEntry>> {
  ConfidenceNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    final box = Hive.box<ConfidenceEntry>(HiveConfig.confidenceBox);
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

    final box = Hive.box<ConfidenceEntry>(HiveConfig.confidenceBox);
    await box.add(entry);
    state = [entry, ...state];
  }

  Future<void> deleteEntry(String id) async {
    final box = Hive.box<ConfidenceEntry>(HiveConfig.confidenceBox);
    final entry = box.values.firstWhere((e) => e.id == id);
    await box.delete(entry.key);
    state = state.where((e) => e.id != id).toList();
  }
}
