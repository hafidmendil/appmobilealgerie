import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/localization/l10n_extension.dart';
import '../../../../core/localization/localization_utils.dart';
import '../../../../core/widgets/sind_components.dart';
import '../../../content/video_library.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/assessment_provider.dart';
import '../../domain/models/assessment_result.dart';
import '../../domain/models/assessment_axis.dart';
import '../../domain/engines/plan_7_days_engine.dart';
import '../../domain/engines/spiritual_support_engine.dart';
import '../../domain/engines/clinical_report_engine.dart';
import '../../domain/engines/patient_deep_study_engine.dart';

class ResultsPage extends ConsumerWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assessmentProvider);
    final result = state.result;
    final bool isRtl = context.isRTL;

    if (result == null) {
      return Scaffold(body: Center(child: Text(context.l10n.error_occurred)));
    }

    final plan = Plan7DaysEngine().generatePlan(result.axisNeeds, context.l10n);
    final spiritual = SpiritualSupportEngine().getRelevantContent(
      result.axisNeeds,
      context.l10n,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(context.l10n.resultsTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEmpathyHeader(context.l10n),
            const SizedBox(height: 20),
            _buildAchievementBadge(result, context.l10n, isRtl),
            const SizedBox(height: 20),
            _buildOrientationCard(result, context.l10n),
            const SizedBox(height: 20),
            _buildClinicalDeepDive(result, context.l10n, isRtl),
            const SizedBox(height: 20),
            _buildPatientDeepStudy(result, context.l10n, isRtl),
            const SizedBox(height: 20),
            _buildJustificationSection(result, context.l10n, isRtl),
            const SizedBox(height: 20),
            _buildNeedsSection(context, result, context.l10n, isRtl),
            const SizedBox(height: 20),
            _buildPersonalizedVideos(context, result, isRtl),
            const SizedBox(height: 20),
            _buildSpiritualSection(spiritual, context.l10n),
            const SizedBox(height: 20),
            Text(
              context.l10n.week_plan_title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
            ),
            const SizedBox(height: 10),
            _build7DayPlan(plan, context.l10n, isRtl, context),
            const SizedBox(height: 30),
            _buildFooter(context, context.l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(
    AssessmentResult result,
    AppLocalizations l10n,
    bool isRtl,
  ) {
    String badgeName = l10n.resilience_warrior;
    IconData icon = Icons.shield;
    Color color = Colors.orange;

    if (result.axisNeeds[AssessmentAxis.selfConfidence]! > 0.7) {
      badgeName = l10n.strength_engine;
      icon = Icons.bolt;
      color = Colors.blue;
    } else if (result.axisNeeds[AssessmentAxis.stressAnxiety]! < 0.3) {
      badgeName = l10n.haven_of_peace;
      icon = Icons.wb_sunny;
      color = Colors.teal;
    }

    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, size: 48, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            badgeName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          Text(
            l10n.current_clinical_profile,
            style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicalDeepDive(
    AssessmentResult result,
    AppLocalizations l10n,
    bool isRtl,
  ) {
    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          l10n.result_understanding_title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _getClinicalSynthesis(result, l10n),
            style: const TextStyle(fontSize: 14, height: 1.6),
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }

  String _getClinicalSynthesis(AssessmentResult result, AppLocalizations l10n) {
    return ClinicalReportEngine().generateSynthesis(result, l10n);
  }

  Widget _buildPatientDeepStudy(
    AssessmentResult result,
    AppLocalizations l10n,
    bool isRtl,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF8FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment:
            isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                isRtl ? "دراسة معمقة لتطوير الحالة" : "Étude approfondie de développement",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            PatientDeepStudyEngine().generateDetailedAnalysis(result, l10n, isRtl),
            style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpathyHeader(AppLocalizations l10n) {
    return Column(
      children: [
        const Icon(Icons.favorite, color: Colors.redAccent, size: 40),
        const SizedBox(height: 10),
        Text(
          l10n.empathy_message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildOrientationCard(AssessmentResult result, AppLocalizations l10n) {
    Color color;
    String title;
    String text;
    IconData icon;

    switch (result.orientationLevel) {
      case OrientationLevel.level4:
        color = const Color(0xFFFFE5E5);
        title = l10n.orientation_level_4_title;
        text = l10n.orientation_level_4_text;
        icon = Icons.warning_rounded;
        break;
      case OrientationLevel.level3:
        color = const Color(0xFFFFF4E5);
        title = l10n.orientation_level_3_title;
        text = l10n.orientation_level_3_text;
        icon = Icons.info_outline;
        break;
      case OrientationLevel.level2:
        color = const Color(0xFFE5F1FF);
        title = l10n.orientation_level_2_title;
        text = l10n.orientation_level_2_text;
        icon = Icons.self_improvement;
        break;
      case OrientationLevel.level1:
        color = const Color(0xFFE5FFEA);
        title = l10n.orientation_level_1_title;
        text = l10n.orientation_level_1_text;
        icon = Icons.check_circle_outline;
        break;
      case OrientationLevel.level0:
      default:
        color = const Color(0xFFF0FFF4);
        title = l10n.orientation_level_0_title;
        text = l10n.orientation_level_0_text;
        icon = Icons.verified_user_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.black87),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildJustificationSection(
    AssessmentResult result,
    AppLocalizations l10n,
    bool isRtl,
  ) {
    if (result.identifiedThemes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          l10n.clinical_analysis_title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueGrey.withAlpha(51)),
          ),
          child: Column(
            children: result.identifiedThemes.map((theme) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: isRtl
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!isRtl)
                      const Icon(
                        Icons.analytics_outlined,
                        size: 16,
                        color: Colors.blueGrey,
                      ),
                    if (!isRtl) const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getThemeDescription(theme, l10n),
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    if (isRtl) const SizedBox(width: 8),
                    if (isRtl)
                      const Icon(
                        Icons.analytics_outlined,
                        size: 16,
                        color: Colors.blueGrey,
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _getThemeDescription(String theme, AppLocalizations l10n) {
    if (theme.contains('high_need_')) {
      final axisName = theme.replaceFirst('high_need_', '');
      try {
        final axis = AssessmentAxis.values.firstWhere(
          (e) => e.name == axisName,
        );
        return l10n.high_need_alert(_getAxisName(axis, l10n));
      } catch (_) {
        return theme;
      }
    }
    if (theme.contains('moderate_need_')) {
      final axisName = theme.replaceFirst('moderate_need_', '');
      try {
        final axis = AssessmentAxis.values.firstWhere(
          (e) => e.name == axisName,
        );
        return l10n.moderate_need_alert(_getAxisName(axis, l10n));
      } catch (_) {
        return theme;
      }
    }
    return theme;
  }

  Widget _buildNeedsSection(
    BuildContext context,
    AssessmentResult result,
    AppLocalizations l10n,
    bool isRtl,
  ) {
    final sortedNeeds =
        result.axisNeeds.entries.where((e) => e.value > 0.2).toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          l10n.focus_areas_title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...sortedNeeds
            .take(3)
            .map(
              (e) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: isRtl
                      ? [
                          Text(
                            LocalizationUtils.formatPercent(e.value, context),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            _getAxisName(e.key, l10n),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                        ]
                      : [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            _getAxisName(e.key, l10n),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            LocalizationUtils.formatPercent(e.value, context),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                ),
              ),
            ),
      ],
    );
  }

  String _getAxisName(AssessmentAxis axis, AppLocalizations l10n) {
    switch (axis) {
      case AssessmentAxis.emotions:
        return l10n.axis_emotions;
      case AssessmentAxis.stressAnxiety:
        return l10n.axis_stress;
      case AssessmentAxis.sleepEnergy:
        return l10n.axis_sleep;
      case AssessmentAxis.productivity:
        return l10n.axis_productivity;
      case AssessmentAxis.socialSupport:
        return l10n.axis_social;
      case AssessmentAxis.angerRegulation:
        return l10n.axis_anger;
      case AssessmentAxis.selfConfidence:
        return l10n.axis_confidence;
      case AssessmentAxis.dailyPressures:
        return l10n.axis_pressures;
      case AssessmentAxis.lifestyle:
        return l10n.axis_lifestyle;
      case AssessmentAxis.safety:
        return l10n.axis_safety;
      case AssessmentAxis.spiritual:
        return l10n.axis_spiritual;
      default:
        return l10n.all;
    }
  }

  Widget _buildSpiritualSection(List<dynamic> content, AppLocalizations l10n) {
    if (content.isEmpty) return const SizedBox.shrink();
    final item = content.first;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue.withAlpha(25)),
      ),
      child: Column(
        children: [
          Text(
            l10n.spiritual_pause_title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.contentAr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.reference,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizedVideos(
    BuildContext context,
    AssessmentResult result,
    bool isRtl,
  ) {
    final rankedAxes = result.axisNeeds.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final videos = <SupportVideo>[];
    for (final axis in rankedAxes.take(3)) {
      final match = supportVideos.where((video) => video.axis == axis.key);
      if (match.isNotEmpty) videos.add(match.first);
    }
    if (videos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: isRtl
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.res_video_personalized,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 12),
        ...videos.map(
          (video) => SindVideoCard(
            title: isRtl ? video.titleAr : video.title,
            description: isRtl ? video.descriptionAr : video.description,
            thumbnailUrl: video.thumbnailUrl,
            onTap: () async {
              final uri = Uri.parse(video.url);
              if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
                  context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.error_occurred),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _build7DayPlan(
    Map<int, String> plan,
    AppLocalizations l10n,
    bool isRtl,
    BuildContext context,
  ) {
    return Column(
      children: plan.entries.map((e) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.blue[50],
              child: Text(
                LocalizationUtils.formatNumber(e.key, context),
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              '${l10n.day_label} ${LocalizationUtils.formatNumber(e.key, context)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(e.value),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => context.push('/professional-search'),
          icon: const Icon(Icons.location_on),
          label: Text(
            l10n.search_pro_nearby,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D3142),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.push('/orientation/network'),
          icon: const Icon(Icons.hub_outlined),
          label: Text(l10n.res_search_trusted_network),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(
            l10n.back_to_home,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.disclaimer_text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
