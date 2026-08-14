import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/assessment_result.dart';
import '../../domain/models/assessment_axis.dart';

class AssessmentRepository {
  static const String _boxName = 'assessment_results';

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  Future<void> saveResult(AssessmentResult result) async {
    final box = Hive.box(_boxName);
    await box.add(_resultToMap(result));
  }

  Future<List<AssessmentResult>> getAllResults() async {
    final box = Hive.box(_boxName);
    return box.values.map((map) => _mapToResult(Map<String, dynamic>.from(map))).toList();
  }

  Future<void> clearHistory() async {
    final box = Hive.box(_boxName);
    await box.clear();
  }

  Map<String, dynamic> _resultToMap(AssessmentResult result) {
    return {
      'sessionId': result.sessionId,
      'axisNeeds': result.axisNeeds.map((key, value) => MapEntry(key.index.toString(), value)),
      'orientationLevel': result.orientationLevel.index,
      'identifiedThemes': result.identifiedThemes,
      'recommendationIds': result.recommendationIds,
      'exerciseIds': result.exerciseIds,
      'spiritualContentIds': result.spiritualContentIds,
      'userFreeMessage': result.userFreeMessage,
      'createdAt': result.createdAt.toIso8601String(),
    };
  }

  AssessmentResult _mapToResult(Map<String, dynamic> map) {
    return AssessmentResult(
      sessionId: map['sessionId'],
      axisNeeds: (map['axisNeeds'] as Map).map((key, value) => MapEntry(AssessmentAxis.values[int.parse(key)], value as double)),
      orientationLevel: OrientationLevel.values[map['orientationLevel']],
      identifiedThemes: List<String>.from(map['identifiedThemes']),
      recommendationIds: List<String>.from(map['recommendationIds']),
      exerciseIds: List<String>.from(map['exerciseIds']),
      spiritualContentIds: List<String>.from(map['spiritualContentIds']),
      userFreeMessage: map['userFreeMessage'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
