import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/auth/auth_provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/localization/l10n_helper.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';
import '../assessment/assessment_state.dart';
import '../engine/decision_engine.dart';
import '../engine/resource_recommendation_engine.dart';
import '../engine/understanding_engine.dart';
import '../engine/free_text_analysis_model.dart';
import '../assessment/assessment_models.dart';
import '../content/quran_library.dart';
import '../content/hadith_library.dart';
import '../content/hikma_library.dart';
import '../content/resource_library.dart';
import '../content/micro_action_library.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(assessmentProvider);
    final user = ref.watch(currentUserProvider);
    final result = state.result;

    if (result == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final moduleScores = _calculateModuleScores(state.answers);
    final recommendations = ResourceRecommendationEngine.getRecommendations(
      result, 
      state.answers, 
      moduleScores,
      state.finalMessage,
    );
    
    final analysis = state.finalMessage != null && state.finalMessage!.isNotEmpty 
        ? UnderstandingEngine.analyze(state.finalMessage!, spiritualEnabled: state.answers['pref_spiritual'] == 1)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resultsTitle),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share_2),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ResultHeader(result: result).animate().fadeIn().scale(),
            const SizedBox(height: AppSpacing.xl),

            if (analysis != null) ...[
              _SectionTitle(title: l10n.what_we_understood),
              const SizedBox(height: AppSpacing.md),
              _AnalysisSummaryCard(analysis: analysis).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: AppSpacing.xl),
            ],
            
            _SectionTitle(title: l10n.focus_areas),
            const SizedBox(height: AppSpacing.md),
            _FocusAreasSection(moduleScores: moduleScores).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: AppSpacing.xl),

            _SectionTitle(title: l10n.my_strengths),
            const SizedBox(height: AppSpacing.md),
            _StrengthsSection(strengths: result.strengths).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: AppSpacing.xl),
            
            _SectionTitle(title: l10n.recommendations),
            const SizedBox(height: AppSpacing.md),
            ...recommendations.map((rec) => _RecommendationCard(recommendation: rec)).toList(),
            
            const SizedBox(height: AppSpacing.xl),
            
            if (user == null)
              const _SavePromptCard().animate().fadeIn(delay: 600.ms),
              
            const SizedBox(height: AppSpacing.xxl),
            
            SindSecondaryButton(
              label: l10n.restart_assessment,
              onPressed: () {
                ref.read(assessmentProvider.notifier).reset();
                context.go('/');
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Map<QuestionModule, int> _calculateModuleScores(Map<String, int> answers) {
    final scores = <QuestionModule, int>{};
    for (final entry in answers.entries) {
      final question = neuroSyncAdaptiveBank.firstWhere((q) => q.id == entry.key, 
          orElse: () => Question(id: '', textKey: '', module: QuestionModule.general));
      scores[question.module] = (scores[question.module] ?? 0) + entry.value;
    }
    return scores;
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  final OrientationResult result;
  const _ResultHeader({required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    String getTitle() {
      switch (result.level) {
        case OrientationLevel.level1: return l10n.level1Title;
        case OrientationLevel.level2: return l10n.level2Title;
        case OrientationLevel.level3: return l10n.level3Title;
        case OrientationLevel.level4: return l10n.level4Title;
      }
    }

    Color getColor() {
      if (result.isRedFlagTriggered) return AppColors.danger;
      switch (result.level) {
        case OrientationLevel.level1: return AppColors.success;
        case OrientationLevel.level2: return AppColors.warning;
        case OrientationLevel.level3: return AppColors.danger;
        case OrientationLevel.level4: return AppColors.danger;
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: getColor().withOpacity(0.1),
        borderRadius: AppRadii.largeRadius,
        border: Border.all(color: getColor().withOpacity(0.35), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: getColor().withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              result.isRedFlagTriggered ? LucideIcons.triangle_alert : LucideIcons.circle_check_big,
              color: getColor(),
              size: 48,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            getTitle(),
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: getColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.translate(result.summaryKey),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _FocusAreasSection extends StatelessWidget {
  final Map<QuestionModule, int> moduleScores;
  const _FocusAreasSection({required this.moduleScores});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final allPossibleNeeds = {
      QuestionModule.stress: {'label': l10n.module_calm, 'icon': LucideIcons.wind, 'color': AppColors.skyBlue},
      QuestionModule.emotions: {'label': l10n.module_emotions, 'icon': LucideIcons.heart, 'color': AppColors.softOlive},
      QuestionModule.sleep: {'label': l10n.module_sleep, 'icon': LucideIcons.moon, 'color': AppColors.info},
      QuestionModule.relationship: {'label': l10n.module_support, 'icon': LucideIcons.users, 'color': AppColors.softBlue},
      QuestionModule.selfEsteem: {'label': l10n.module_confidence, 'icon': LucideIcons.sparkles, 'color': AppColors.softOlive},
      QuestionModule.behavioral: {'label': l10n.module_balance, 'icon': LucideIcons.activity, 'color': AppColors.success},
      QuestionModule.cognitive: {'label': l10n.module_bias, 'icon': LucideIcons.brain, 'color': AppColors.softOlive},
      QuestionModule.environmental: {'label': l10n.module_trauma, 'icon': LucideIcons.shield, 'color': AppColors.danger},
      QuestionModule.dailyPressures: {'label': "Pression", 'icon': LucideIcons.gauge, 'color': AppColors.warning},
      QuestionModule.emotionalManagement: {'label': "Gestion", 'icon': LucideIcons.frown, 'color': AppColors.softOlive},
    };

    final activeNeeds = moduleScores.entries
        .where((e) => e.value >= 2 && allPossibleNeeds.containsKey(e.key))
        .map((e) => {
              'module': e.key,
              ...allPossibleNeeds[e.key]!,
              'score': e.value,
            })
        .toList();

    if (activeNeeds.isEmpty) {
      return SindGlassCard(
        child: Center(child: Text(l10n.globally_stable)),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.3,
      ),
      itemCount: activeNeeds.length,
      itemBuilder: (context, index) {
        final need = activeNeeds[index];
        final score = need['score'] as int;
        final priorityColor = score >= 4 ? AppColors.danger : AppColors.warning;

        return SindGlassCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(need['icon'] as IconData, color: need['color'] as Color, size: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.2),
                      borderRadius: AppRadii.pillRadius,
                    ),
                    child: Text(
                      score >= 4 ? l10n.priority_high : l10n.priority_moderate,
                      style: TextStyle(color: priorityColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                need['label'] as String,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.need_support,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StrengthsSection extends StatelessWidget {
  final List<String> strengths;
  const _StrengthsSection({required this.strengths});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: strengths.map((s) => Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: AppRadii.pillRadius,
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.sparkles, color: AppColors.success, size: 16),
            const SizedBox(width: AppSpacing.xs),
            Text(
              l10n.translate(s),
              style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final OrientationRecommendation recommendation;
  const _RecommendationCard({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRationale = recommendation.descriptionKey.startsWith('rec_desc_text_');
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: (recommendation.isEmergency ? AppColors.danger : (isRationale ? AppColors.info : AppColors.oliveGreen)).withOpacity(0.15),
            borderRadius: AppRadii.mediumRadius,
          ),
          child: Icon(
            recommendation.isEmergency ? LucideIcons.circle_alert : (isRationale ? LucideIcons.message_square : LucideIcons.lightbulb),
            color: recommendation.isEmergency ? AppColors.danger : (isRationale ? AppColors.info : AppColors.oliveGreen),
          ),
        ),
        title: Text(
          l10n.translate(recommendation.titleKey),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(l10n.translate(recommendation.descriptionKey)),
        children: recommendation.resourceIds.map((id) => _ResourceListItem(resourceId: id)).toList(),
      ),
    );
  }
}

class _AnalysisSummaryCard extends StatelessWidget {
  final FreeTextAnalysis analysis;
  const _AnalysisSummaryCard({required this.analysis});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SindGlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.feather, color: AppColors.oliveGreen, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                "Analyse de votre message",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "Dans ce que vous avez écrit, nous avons identifié :",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: analysis.identifiedStates.map((state) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.oliveGreen.withOpacity(0.1),
                borderRadius: AppRadii.pillRadius,
              ),
              child: Text(
                _translateState(state, l10n),
                style: const TextStyle(fontSize: 12, color: AppColors.oliveGreen, fontWeight: FontWeight.w600),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  String _translateState(DeclaredState state, AppLocalizations l10n) {
    switch (state) {
      case DeclaredState.stress: return "Stress";
      case DeclaredState.anxious: return "Anxiété";
      case DeclaredState.sad: return "Tristesse";
      case DeclaredState.isolated: return "Isolement";
      case DeclaredState.familyConflict: return "Conflit familial";
      case DeclaredState.academicDifficulty: return "Difficultés d'études";
      case DeclaredState.professionalDifficulty: return "Difficultés professionnelles";
      case DeclaredState.overload: return "Surcharge";
      case DeclaredState.seekingMeaning: return "Recherche de sens";
      case DeclaredState.lackOfMotivation: return "Baisse de motivation";
      case DeclaredState.medicalCondition: return "État de santé";
      case DeclaredState.urgentSituation: return "Urgence déclarée";
      case DeclaredState.alreadyFollowed: return "Déjà accompagné";
      case DeclaredState.seekingMeaning: return "Recherche de sens";
      default: return state.name;
    }
  }
}

class _ResourceListItem extends StatelessWidget {
  final String resourceId;
  const _ResourceListItem({required this.resourceId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Find resource in any of the libraries
    dynamic resource;
    try {
      resource = quranLibrary.firstWhere((v) => v.id == resourceId);
    } catch (_) {
      try {
        resource = hadithLibrary.firstWhere((h) => h.id == resourceId);
      } catch (_) {
        try {
          resource = psychologicalResources.firstWhere((r) => r.id == resourceId);
        } catch (_) {
          try {
            resource = microActions.firstWhere((a) => a.id == resourceId);
          } catch (_) {
            resource = null;
          }
        }
      }
    }

    if (resource == null) return const SizedBox.shrink();

    String title = "";
    IconData icon = LucideIcons.file_text;
    Color color = AppColors.textSecondary;

    if (resource is QuranVerse) {
      title = "Coran ${resource.surahNumber}:${resource.verseNumber}";
      icon = LucideIcons.book_open;
      color = AppColors.softOlive;
    } else if (resource is Hadith) {
      title = "Hadith (${resource.collection})";
      icon = LucideIcons.message_circle_more;
      color = AppColors.oliveGreen;
    } else if (resource is PsychologicalResource) {
      title = l10n.translate(resource.titleKey);
      icon = LucideIcons.brain_circuit;
      color = AppColors.skyBlue;
    } else if (resource is MicroAction) {
      title = l10n.translate(resource.titleKey);
      icon = LucideIcons.circle_check;
      color = AppColors.success;
    }

    return ListTile(
      leading: Icon(icon, color: color, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(LucideIcons.chevron_right, size: 16),
      onTap: () => _showResourceDetail(context, resource, l10n),
    );
  }

  void _showResourceDetail(BuildContext context, dynamic resource, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ResourceDetailSheet(
        resource: resource,
        onReflectionTap: () {
          Navigator.pop(context);
          _showReflectionDialog(context, resource);
        },
      ),
    );
  }

  void _showReflectionDialog(BuildContext context, dynamic resource) {
    showDialog(
      context: context,
      builder: (context) => _ReflectionDialog(resource: resource),
    );
  }
}

class _ReflectionDialog extends StatefulWidget {
  final dynamic resource;
  const _ReflectionDialog({required this.resource});

  @override
  State<_ReflectionDialog> createState() => _ReflectionDialogState();
}

class _ReflectionDialogState extends State<_ReflectionDialog> {
  final TextEditingController _controller = TextEditingController();
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final reflectionQuestions = [
      "Qu'est-ce que ce message évoque pour vous ?",
      "Qu'est-ce qui vous apporte actuellement du réconfort ?",
      "Quelle petite chose pourriez-vous faire aujourd'hui ?",
      "Qui pourrait vous soutenir ?",
    ];

    return AlertDialog(
      title: Row(
        children: [
          const Icon(LucideIcons.sparkles, color: AppColors.oliveGreen),
          const SizedBox(width: AppSpacing.sm),
          const Text("Temps de réflexion"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            reflectionQuestions[_currentStep],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Écrivez ici...",
              border: OutlineInputBorder(borderRadius: AppRadii.mediumRadius),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.close),
        ),
        SindPrimaryButton(
          label: _currentStep < reflectionQuestions.length - 1 ? l10n.next : l10n.finish,
          onPressed: () {
            if (_currentStep < reflectionQuestions.length - 1) {
              setState(() {
                _currentStep++;
                _controller.clear();
              });
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Merci pour ce temps de réflexion. 🌿")),
              );
            }
          },
        ),
      ],
    );
  }
}

class _ResourceDetailSheet extends StatelessWidget {
  final dynamic resource;
  final VoidCallback? onReflectionTap;
  const _ResourceDetailSheet({required this.resource, this.onReflectionTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withOpacity(0.3),
                  borderRadius: AppRadii.pillRadius,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            if (resource is QuranVerse || resource is Hadith) ...[
              Text(
                resource.textAr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Amiri', // Assuming Amiri font is available for Arabic
                  fontSize: 24,
                  height: 1.6,
                  color: AppColors.oliveGreen,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: AppSpacing.xl),
              const Divider(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                resource.textFr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (resource is QuranVerse && resource.reflection != null) ...[
                _InfoBox(
                  title: "Réflexion",
                  content: resource.reflection!,
                  icon: LucideIcons.sparkles,
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              
              if (resource is QuranVerse || resource is Hadith || resource is PsychologicalResource)
                SindSecondaryButton(
                  label: "Prendre un temps de réflexion",
                  onPressed: onReflectionTap,
                ),

              const SizedBox(height: AppSpacing.lg),
              Text(
                resource is QuranVerse 
                  ? "Sourate ${resource.surahNumber}, Verset ${resource.verseNumber}"
                  : "${resource.collection}, Hadith n°${resource.number}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted),
              ),
            ] else if (resource is PsychologicalResource) ...[
              Text(
                l10n.translate(resource.titleKey),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.translate(resource.contentKey),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
              const SizedBox(height: AppSpacing.xl),
              _InfoBox(
                title: "Durée estimée",
                content: resource.duration,
                icon: LucideIcons.timer,
              ),
            ] else if (resource is MicroAction) ...[
              Text(
                l10n.translate(resource.titleKey),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.translate(resource.descriptionKey),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              SindPrimaryButton(
                label: "C'est fait !",
                onPressed: () => Navigator.pop(context),
              ),
            ],
            
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _InfoBox({required this.title, required this.content, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.oliveGreen.withOpacity(0.05),
        borderRadius: AppRadii.mediumRadius,
        border: Border.all(color: AppColors.oliveGreen.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.oliveGreen),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.oliveGreen)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(content, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _SavePromptCard extends StatelessWidget {
  const _SavePromptCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SindGlassCard(
      color: AppColors.oliveGreen,
      opacity: 0.1,
      child: Column(
        children: [
          Icon(LucideIcons.cloud_upload, color: AppColors.oliveGreen, size: 40),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.savePromptTitle,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.savePromptBody,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          SindPrimaryButton(
            label: l10n.savePromptButton,
            onPressed: () => context.push('/register'),
          ),
        ],
      ),
    );
  }
}
