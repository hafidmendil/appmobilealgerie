import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/hive_protection_repository.dart';
import '../../domain/engines/adaptive_protection_question_engine.dart';
import '../../domain/engines/violence_risk_engine.dart';
import '../../domain/engines/orientation_engine.dart';
import '../../domain/repositories/protection_repository.dart';

import '../../domain/engines/red_flag_engine.dart';
import '../../domain/engines/initial_guidance_engine.dart';
import '../../domain/models/protection_models.dart';

final protectionRepositoryProvider = Provider<ProtectionRepository>((ref) {
  return HiveProtectionRepository();
});

final redFlagEngineProvider = Provider<RedFlagEngine>((ref) {
  return const RedFlagEngine();
});

final initialGuidanceEngineProvider = Provider<InitialGuidanceEngine>((ref) {
  return const InitialGuidanceEngine();
});

final riskEngineProvider = Provider<ViolenceRiskEngine>((ref) {
  final redFlagEngine = ref.watch(redFlagEngineProvider);
  final initialGuidanceEngine = ref.watch(initialGuidanceEngineProvider);
  return ViolenceRiskEngine(
    redFlagEngine: redFlagEngine,
    initialGuidanceEngine: initialGuidanceEngine,
  );
});

final adaptiveProtectionEngineProvider =
    Provider<AdaptiveProtectionQuestionEngine>((ref) {
      final redFlagEngine = ref.watch(redFlagEngineProvider);
      return AdaptiveProtectionQuestionEngine(redFlagEngine: redFlagEngine);
    });

final orientationEngineProvider = Provider<ProtectionOrientationEngine>((ref) {
  return const ProtectionOrientationEngine();
});

final categoryRegistryProvider = Provider<List<ViolenceCategory>>((ref) {
  return ViolenceCategoryRegistry.all;
});
