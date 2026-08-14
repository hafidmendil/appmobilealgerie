import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:projetmascara/features/engine/decision_engine.dart';
import 'package:projetmascara/features/engine/adaptive_assessment_engine.dart';
import 'package:projetmascara/features/assessment/assessment_models.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/core/services/assessment_repository.dart';
import 'package:projetmascara/core/services/mock_assessment_repository.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:uuid/uuid.dart';

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return MockAssessmentRepository();
});

final adaptiveEngineProvider = Provider<AdaptiveAssessmentEngine>((ref) {
  return AdaptiveAssessmentEngine(questionBank: neuroSyncAdaptiveBank);
});

class AssessmentData {
  final Map<String, int> answers;
  final List<String> path; // Sequence of question IDs
  final String? finalMessage;
  final OrientationResult? result;
  final bool isCompleted;

  AssessmentData({
    this.answers = const {},
    this.path = const [],
    this.finalMessage,
    this.result,
    this.isCompleted = false,
  });

  Question? get currentQuestion {
    if (path.isEmpty) return null;
    final lastId = path.last;
    return neuroSyncAdaptiveBank.firstWhere((q) => q.id == lastId, 
      orElse: () => neuroSyncAdaptiveBank.first);
  }

  Map<String, int> get activeAnswers {
    final result = <String, int>{};
    for (final id in path) {
      if (answers.containsKey(id)) {
        result[id] = answers[id]!;
      }
    }
    return result;
  }

  double get progress {
    if (isCompleted) return 1.0;
    // Base estimation: we expect around 15 questions for a full assessment
    // but at least progress according to what we've done.
    final count = path.length;
    if (count == 0) return 0.0;
    
    // Smooth progress: first few questions move faster, then it slows down as we approach the limit
    // to avoid jumping to 100% too early.
    double est = count / 15.0;
    return est.clamp(0.0, 0.95);
  }

  AssessmentData copyWith({
    Map<String, int>? answers,
    List<String>? path,
    String? finalMessage,
    OrientationResult? result,
    bool? isCompleted,
  }) {
    return AssessmentData(
      answers: answers ?? this.answers,
      path: path ?? this.path,
      finalMessage: finalMessage ?? this.finalMessage,
      result: result ?? this.result,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class AssessmentNotifier extends StateNotifier<AssessmentData> {
  final Ref _ref;
  final _uuid = const Uuid();

  AssessmentNotifier(this._ref) : super(AssessmentData()) {
    // Start session if empty
    if (state.path.isEmpty) {
      _startNewSession();
    }
  }

  void _startNewSession() {
    final engine = _ref.read(adaptiveEngineProvider);
    final firstQuestion = engine.getNextQuestion({});
    if (firstQuestion != null) {
      state = state.copyWith(path: [firstQuestion.id]);
    }
  }

  void setAnswer(String id, int value) {
    state = state.copyWith(
      answers: {...state.answers, id: value},
    );
    _saveDraft();

    // Check if safety triggered
    final question = neuroSyncAdaptiveBank.firstWhere((q) => q.id == id,
        orElse: () => Question(id: '', textKey: '', module: QuestionModule.general));
    if (question.id.isEmpty) return;

    final option = question.options.firstWhere((o) => o.value == value, 
      orElse: () => Option(textKey: '', value: -1));
    
    if (option.isSafetyTrigger) {
      calculateResult();
    }
  }

  void setFinalMessage(String message) {
    state = state.copyWith(finalMessage: message);
    _saveDraft();
  }

  void nextStep() {
    final engine = _ref.read(adaptiveEngineProvider);
    final nextQuestion = engine.getNextQuestion(state.activeAnswers);
    
    if (nextQuestion == null) {
      calculateResult();
    } else {
      state = state.copyWith(
        path: [...state.path, nextQuestion.id],
      );
      _saveDraft();
    }
  }

  void prevStep() {
    if (state.path.length > 1) {
      final newPath = List<String>.from(state.path)..removeLast();
      state = state.copyWith(path: newPath);
      _saveDraft();
    }
  }

  void calculateResult() {
    final engine = _ref.read(adaptiveEngineProvider);
    final result = engine.computeResult(state.activeAnswers);
    state = state.copyWith(result: result, isCompleted: true);
    
    // Save to local DB
    final user = _ref.read(currentUserProvider);
    final record = AssessmentRecord(
      id: _uuid.v4(),
      userId: user?.id,
      answers: state.activeAnswers,
      safetyAnswers: {}, // Deprecated but kept for compat
      createdAt: DateTime.now(),
      finalMessage: state.finalMessage,
    );
    _ref.read(assessmentRepositoryProvider).saveAssessment(record);
  }

  void reset() {
    state = AssessmentData();
    _startNewSession();
    _saveDraft();
  }

  void loadRecord(AssessmentRecord record) {
    final engine = _ref.read(adaptiveEngineProvider);
    state = AssessmentData(
      answers: record.answers,
      path: record.answers.keys.toList(), // Simplification
      finalMessage: record.finalMessage,
      result: engine.computeResult(record.answers),
      isCompleted: true,
    );
  }

  Future<void> _saveDraft() async {
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    final box = await Hive.openBox('assessment_draft', encryptionCipher: encryptionCipher);
    await box.put('current', {
      'answers': state.answers,
      'path': state.path,
      'finalMessage': state.finalMessage,
      'isCompleted': state.isCompleted,
    });
  }

  Future<void> loadDraft() async {
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    final box = await Hive.openBox('assessment_draft', encryptionCipher: encryptionCipher);
    final draft = box.get('current');
    if (draft != null) {
      state = AssessmentData(
        answers: Map<String, int>.from(draft['answers'] ?? {}),
        path: List<String>.from(draft['path'] ?? []),
        finalMessage: draft['finalMessage'],
        isCompleted: draft['isCompleted'] ?? false,
      );
      if (state.path.isEmpty) _startNewSession();
    }
  }
}

final assessmentProvider =
    StateNotifierProvider<AssessmentNotifier, AssessmentData>((ref) {
  return AssessmentNotifier(ref);
});

final userAssessmentsProvider = FutureProvider<List<AssessmentRecord>>((ref) async {
  final user = ref.watch(currentUserProvider);
  return ref.watch(assessmentRepositoryProvider).getAssessments(user?.id);
});

final guestAssessmentsProvider = FutureProvider<List<AssessmentRecord>>((ref) async {
  return ref.watch(assessmentRepositoryProvider).getAssessments(null);
});

final assessmentHistoryProvider = FutureProvider<List<AssessmentRecord>>((ref) async {
  final user = ref.watch(currentUserProvider);
  return ref.watch(assessmentRepositoryProvider).getAssessments(user?.id);
});
