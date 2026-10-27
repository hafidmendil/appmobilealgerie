import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/engines/safety_engine.dart';

void main() {
  group('SafetyEngine', () {
    test(
      'returns urgent support when a high-risk safety trigger is activated',
      () {
        final engine = SafetyEngine();

        final result = engine.evaluate({'Q000_Concern': 0, 'Q452': 4});

        expect(result.status, SafetyStatus.urgentSupport);
        expect(result.shouldStopAssessment, isTrue);
      },
    );

    test(
      'returns non-diagnostic message and stop flag for urgent support case',
      () {
        final engine = SafetyEngine();

        final result = engine.evaluate({'Q000_Concern': 0, 'Q452': 4});

        expect(
          result.messageFr.contains('ne constitue pas un diagnostic'),
          isTrue,
        );
        expect(result.shouldStopAssessment, isTrue);
      },
    );

    test('keeps neutral wording when no red flag is present', () {
      final engine = SafetyEngine();

      final result = engine.evaluate({'Q000_Concern': 3});

      expect(result.status, SafetyStatus.none);
      expect(result.messageFr, isEmpty);
    });
  });
}
