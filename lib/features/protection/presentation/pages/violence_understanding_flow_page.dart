import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:projetmascara/core/localization/l10n_extension.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/providers/unified_data_providers.dart';
import 'package:projetmascara/core/providers/local_care_providers.dart';
import '../../domain/engines/adaptive_protection_question_engine.dart';
import '../../domain/models/protection_models.dart';
import '../providers/protection_providers.dart'
    hide protectionRepositoryProvider;

class ViolenceUnderstandingFlowPage extends ConsumerStatefulWidget {
  const ViolenceUnderstandingFlowPage({super.key});

  @override
  ConsumerState<ViolenceUnderstandingFlowPage> createState() =>
      _ViolenceUnderstandingFlowPageState();
}

class _ViolenceUnderstandingFlowPageState
    extends ConsumerState<ViolenceUnderstandingFlowPage> {
  int _currentStep =
      0; // 0: Consent, 1: Categories, 2: Context, 3: Adaptive Qs, 4: Result
  bool _consentGiven = false;

  final Set<ViolenceType> _selectedCategories = {};
  String? _frequency;
  String? _duration;
  String? _contextType;
  String? _relationship;

  final Map<String, AnswerValue> _answers = {};
  ProtectionQuestion? _currentQuestion;
  bool _isAnalyzing = false;
  bool _interruptedByRedFlag = false;

  ViolenceAssessmentResult? _assessmentResult;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onConsentAccepted() async {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      await ref
          .read(localCareRepositoryProvider)
          .grantConsent(
            userId: user.id,
            type: 'data_storage',
            purpose: context.l10n.prot_offline_notice,
            dataFields: context.isRTL
                ? const ['الإجابات', 'نتيجة الخطر']
                : const ['réponses', 'résultat de risque'],
          );
    }
    if (!mounted) return;
    setState(() {
      _consentGiven = true;
      _currentStep = 1;
    });
  }

  void _onCategoriesSelected() {
    if (!_consentGiven) return;
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.prot_select_min_one),
        ),
      );
      return;
    }
    setState(() => _currentStep = 2);
  }

  void _onContextSubmitted() {
    setState(() => _currentStep = 3);
    _loadNextAdaptiveQuestion();
  }

  void _loadNextAdaptiveQuestion() {
    final adaptiveEngine = ref.read(adaptiveProtectionEngineProvider);
    final redFlagEngine = ref.read(redFlagEngineProvider);

    // Check early Red Flag interruption
    if (redFlagEngine.hasCriticalRedFlag(_answers)) {
      setState(() {
        _interruptedByRedFlag = true;
      });
      _finalizeAssessment();
      return;
    }

    final q = adaptiveEngine.next(
      categories: _selectedCategories,
      answers: _answers,
    );

    if (q == null) {
      // Questionnaire complete!
      _finalizeAssessment();
    } else {
      setState(() {
        _currentQuestion = q;
      });
    }
  }

  void _answerCurrentQuestion(AnswerValue value) {
    if (_currentQuestion == null) return;
    _answers[_currentQuestion!.id] = value;

    final redFlagEngine = ref.read(redFlagEngineProvider);
    if (redFlagEngine.hasCriticalRedFlag(_answers)) {
      setState(() {
        _interruptedByRedFlag = true;
      });
      _finalizeAssessment();
      return;
    }

    _loadNextAdaptiveQuestion();
  }

  Future<void> _finalizeAssessment() async {
    setState(() {
      _isAnalyzing = true;
    });

    final currentUser = ref.read(currentUserProvider);
    final isGuest = currentUser == null;
    final now = DateTime.now();
    final assessmentId = const Uuid().v4();

    final assessment = ViolenceAssessment(
      id: assessmentId,
      userId: isGuest ? null : currentUser.id,
      createdAt: now,
      updatedAt: now,
      categories: _selectedCategories.toList(),
      answers: Map.from(_answers),
      frequency: _frequency,
      duration: _duration,
      contextType: _contextType,
      relationshipToAuthor: _relationship,
      status: _interruptedByRedFlag ? 'interruptedByRedFlag' : 'completed',
      isAnonymous: isGuest,
    );

    final riskEngine = ref.read(riskEngineProvider);
    final result = riskEngine.evaluateAssessment(
      assessment,
      wilaya: currentUser?.wilayaId ?? '01',
    );

    // Save via Repository locally (Hive)
    final repo = ref.read(protectionRepositoryProvider);
    await repo.saveAssessment(assessment);
    await repo.saveAssessmentResult(result);

    // Also save backward-compatible RiskAssessment for legacy tools
    final legacyRisk = result.toRiskAssessment(reportId: assessmentId);
    await repo.saveRiskAssessment(legacyRisk);

    if (!mounted) return;
    setState(() {
      _assessmentResult = result;
      _isAnalyzing = false;
      _currentStep = 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.prot_flow_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined),
            onPressed: () => context.push('/protection/privacy'),
            tooltip: context.l10n.prot_privacy_tooltip,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildCurrentStepView(context.isRTL),
      ),
    );
  }

  Widget _buildCurrentStepView(bool isRtl) {
    if (_isAnalyzing) {
      return _buildAnalyzingView(isRtl);
    }

    switch (_currentStep) {
      case 0:
        return _buildConsentStep(isRtl);
      case 1:
        return _buildCategorySelectionStep(isRtl);
      case 2:
        return _buildContextStep(isRtl);
      case 3:
        return _buildAdaptiveQuestionnaireStep(isRtl);
      case 4:
        return _buildResultStep(isRtl);
      default:
        return _buildConsentStep(isRtl);
    }
  }

  // --- Step 0: Consent & Privacy ---
  Widget _buildConsentStep(bool isRtl) {
    return SingleChildScrollView(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withAlpha(51),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withAlpha(76),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shield_rounded,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    context.l10n.prot_offline_notice,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.prot_consent_info_title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            "• ${context.l10n.prot_consent_bullet_1}\n• ${context.l10n.prot_consent_bullet_2}\n• ${context.l10n.prot_consent_bullet_3}\n• ${context.l10n.prot_consent_bullet_4}",
            style: const TextStyle(fontSize: 15, height: 1.6),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _onConsentAccepted,
            icon: const Icon(Icons.check_circle_outline),
            label: Text(context.l10n.prot_consent_accept),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 1: Configurable Category Selection ---
  Widget _buildCategorySelectionStep(bool isRtl) {
    final categories = ref.watch(categoryRegistryProvider);

    return Column(
      key: const ValueKey(1),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.prot_nature_situation,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.l10n.prot_nature_desc,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = _selectedCategories.contains(cat.id);
              return Card(
                elevation: isSelected ? 2 : 0,
                color: isSelected
                    ? Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withAlpha(76)
                    : Theme.of(
                        context,
                      ).colorScheme.surfaceVariant.withAlpha(100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: CheckboxListTile(
                  value: isSelected,
                  activeColor: Theme.of(context).colorScheme.primary,
                  title: Text(
                    isRtl ? cat.labelAr : cat.labelFr,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(isRtl ? cat.descriptionAr : cat.descriptionFr),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedCategories.add(cat.id);
                      } else {
                        _selectedCategories.remove(cat.id);
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: FilledButton(
            onPressed: _selectedCategories.isNotEmpty
                ? _onCategoriesSelected
                : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(context.l10n.continue_action),
          ),
        ),
      ],
    );
  }

  // --- Step 2: Context & Relationship ---
  Widget _buildContextStep(bool isRtl) {
    return SingleChildScrollView(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.prot_context_repetition,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Frequency
          Text(
            context.l10n.prot_freq_label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _frequency,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            hint: Text(context.l10n.prot_freq_hint),
            items: [
              DropdownMenuItem(
                value: 'isolated',
                child: Text(context.l10n.prot_freq_isolated),
              ),
              DropdownMenuItem(
                value: 'repeated',
                child: Text(context.l10n.prot_freq_repeated),
              ),
              DropdownMenuItem(
                value: 'escalating',
                child: Text(context.l10n.prot_freq_escalating),
              ),
              DropdownMenuItem(
                value: 'continuous',
                child: Text(context.l10n.prot_freq_continuous),
              ),
            ],
            onChanged: (val) => setState(() => _frequency = val),
          ),
          const SizedBox(height: 24),

          // Context
          Text(
            context.l10n.prot_cadre_label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _contextType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            hint: Text(context.l10n.prot_cadre_hint),
            items: [
              DropdownMenuItem(
                value: 'family',
                child: Text(context.l10n.prot_cadre_family),
              ),
              DropdownMenuItem(
                value: 'work',
                child: Text(context.l10n.prot_cadre_work),
              ),
              DropdownMenuItem(
                value: 'school',
                child: Text(context.l10n.prot_cadre_school),
              ),
              DropdownMenuItem(
                value: 'online',
                child: Text(context.l10n.prot_cadre_online),
              ),
              DropdownMenuItem(
                value: 'other',
                child: Text(context.l10n.prot_cadre_other),
              ),
            ],
            onChanged: (val) => setState(() => _contextType = val),
          ),
          const SizedBox(height: 24),

          // Relationship
          Text(
            context.l10n.prot_relation_label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _relationship,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            hint: Text(context.l10n.prot_relation_hint),
            items: [
              DropdownMenuItem(
                value: 'partner',
                child: Text(context.l10n.prot_relation_partner),
              ),
              DropdownMenuItem(
                value: 'relative',
                child: Text(context.l10n.prot_relation_relative),
              ),
              DropdownMenuItem(
                value: 'colleague',
                child: Text(context.l10n.prot_relation_colleague),
              ),
              DropdownMenuItem(
                value: 'acquaintance',
                child: Text(context.l10n.prot_relation_acquaintance),
              ),
              DropdownMenuItem(
                value: 'unknown',
                child: Text(context.l10n.prot_relation_unknown),
              ),
            ],
            onChanged: (val) => setState(() => _relationship = val),
          ),
          const SizedBox(height: 36),

          FilledButton(
            onPressed: _onContextSubmitted,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(context.l10n.prot_goto_adaptive),
          ),
        ],
      ),
    );
  }

  // --- Step 3: Adaptive Questionnaire ---
  Widget _buildAdaptiveQuestionnaireStep(bool isRtl) {
    if (_currentQuestion == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final q = _currentQuestion!;

    return Padding(
      key: ValueKey(q.id),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (_answers.length + 1) / 8.0,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    q.isRedFlagCandidate
                        ? Icons.error_outline
                        : Icons.help_outline,
                    size: 48,
                    color: q.isRedFlagCandidate
                        ? Colors.orange.shade700
                        : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isRtl ? q.textAr : q.textFr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => _answerCurrentQuestion(AnswerValue.yes),
            icon: const Icon(Icons.check, color: Colors.green),
            label: Text(context.l10n.yes),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _answerCurrentQuestion(AnswerValue.no),
            icon: const Icon(Icons.close, color: Colors.red),
            label: Text(context.l10n.no),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                _answerCurrentQuestion(AnswerValue.preferNotToAnswer),
            child: Text(context.l10n.prefer_not_to_answer),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- Analyzing Screen ---
  Widget _buildAnalyzingView(bool isRtl) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            context.l10n.prot_analyzing,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  // --- Step 4: Result Page ---
  Widget _buildResultStep(bool isRtl) {
    if (_assessmentResult == null) return const SizedBox.shrink();
    final res = _assessmentResult!;
    final severity = res.severity;

    Color badgeColor;
    IconData badgeIcon;
    switch (severity) {
      case ViolenceSeverity.level1Preoccupante:
        badgeColor = Colors.teal;
        badgeIcon = Icons.info_outline;
        break;
      case ViolenceSeverity.level2Vigilance:
        badgeColor = Colors.amber.shade800;
        badgeIcon = Icons.visibility;
        break;
      case ViolenceSeverity.level3Accompagnement:
        badgeColor = Colors.orange.shade900;
        badgeIcon = Icons.health_and_safety;
        break;
      case ViolenceSeverity.level4GravePrioriteSecurite:
        badgeColor = Colors.red.shade700;
        badgeIcon = Icons.warning_amber_rounded;
        break;
    }

    return SingleChildScrollView(
      key: const ValueKey(4),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Badge
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: badgeColor.withAlpha(25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: badgeColor, width: 2),
            ),
            child: Column(
              children: [
                Icon(badgeIcon, size: 56, color: badgeColor),
                const SizedBox(height: 12),
                Text(
                  isRtl ? severity.titleAr() : severity.titleFr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isRtl ? severity.explanationAr() : severity.explanationFr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Vocabulary Disclaimer Notice
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    res.disclaimerFor(isRtl),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Red Flags Section if detected
          if (res.detectedRedFlags.isNotEmpty) ...[
            Text(
              context.l10n.prot_red_flags_title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ...res.detectedRedFlags.map(
              (rf) => Card(
                color: Colors.red.shade50,
                child: ListTile(
                  leading: const Icon(Icons.priority_high, color: Colors.red),
                  title: Text(
                    isRtl ? rf.titleAr : rf.titleFr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(isRtl ? rf.descriptionAr : rf.descriptionFr),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Guidance Actions
          Text(
            context.l10n.prot_guidance_title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...res.guidanceFor(isRtl).map(
            (g) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.teal,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(g, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Orientation towards Professionals
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person_pin,
                        color: Colors.blue,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.l10n.prot_orientation_pro,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.prot_orientation_reco(
                      _getSpecialtyLabel(res.orientation.requiredSpecialty, isRtl),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      context.push('/professional-search');
                    },
                    icon: const Icon(Icons.search),
                    label: Text(context.l10n.prot_search_national),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Immediate Emergency Button if Level 4
          if (severity == ViolenceSeverity.level4GravePrioriteSecurite)
            FilledButton.icon(
              onPressed: () => context.push('/protection/emergency'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.warning_amber),
              label: Text(context.l10n.prot_goto_emergency),
            ),
          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: () => context.go('/protection'),
            child: Text(context.l10n.prot_back_home),
          ),
        ],
      ),
    );
  }

  String _getSpecialtyLabel(String key, bool isRtl) {
    final cleanKey = key.toLowerCase();
    if (cleanKey.contains('child') || cleanKey.contains('enfance')) {
      return context.l10n.specialty_child_protection;
    } else if (cleanKey.contains('family') || cleanKey.contains('familial')) {
      return context.l10n.specialty_family_counselor;
    } else if (cleanKey.contains('digital') || cleanKey.contains('numérique')) {
      return context.l10n.specialty_digital_safety;
    } else if (cleanKey.contains('work') || cleanKey.contains('travail')) {
      return context.l10n.specialty_work_psychologist;
    }
    return context.l10n.specialty_psychologist;
  }
}
