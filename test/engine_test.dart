import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/engine/decision_engine.dart';

void main() {
  group('Decision Engine Tests', () {
    test('Level 4 - Red Flag Trigger', () {
      final result = DeterministicDecisionEngine.compute(
        {},
        {'safety_1': true},
      );
      expect(result.level, OrientationLevel.level4);
      expect(result.isRedFlagTriggered, true);
    });

    test('Level 1 - Low Score (< 20)', () {
      final result = DeterministicDecisionEngine.compute(
        {'phq_1': 3, 'stress_1': 3, 'sleep_1': 3}, // Total 9
        {'safety_1': false},
      );
      expect(result.level, OrientationLevel.level1);
    });

    test('Level 2 - Medium Score (>= 20)', () {
      final answers = <String, int>{};
      for (var i = 1; i <= 10; i++) {
        answers['q$i'] = 2; // Total 20
      }
      final result = DeterministicDecisionEngine.compute(
        answers,
        {'safety_1': false},
      );
      expect(result.level, OrientationLevel.level2);
    });

    test('Level 3 - High Score (>= 40)', () {
      final answers = <String, int>{};
      for (var i = 1; i <= 20; i++) {
        answers['q$i'] = 2; // Total 40
      }
      final result = DeterministicDecisionEngine.compute(
        answers,
        {'safety_1': false},
      );
      expect(result.level, OrientationLevel.level3);
    });

    test('Justifications Generation', () {
      final result = DeterministicDecisionEngine.compute(
        {'stress_1': 2, 'stress_2': 2}, // stress module score = 4
        {},
      );
      expect(result.justifications, contains('high_stress_detected'));
    });
  });
}
