import '../../core/localization/l10n_extension.dart';
import '../../generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../adaptive_assessment/presentation/providers/assessment_provider.dart';
import '../adaptive_assessment/domain/models/assessment_axis.dart';
import '../../core/widgets/sind_components.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestResult = ref.watch(latestResultProvider);
    final theme = Theme.of(context);

    if (latestResult == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.auto_analyses_dtailles)),
        body: Center(
          child: Text(context.l10n.auto_effectuez_une_valuation_pour),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.auto_analyses_dtailles),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.file_text),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.auto_gnration_rapport_pdf)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.analyticsWellbeingRadar,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildRadarChart(latestResult.axisNeeds, context.l10n),
            const SizedBox(height: AppSpacing.xl),
            Text(
              context.l10n.analyticsAxisDetail,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            ...latestResult.axisNeeds.entries.map(
              (e) => _buildAxisDetail(e.key, e.value, theme, context.l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadarChart(
    Map<AssessmentAxis, double> data,
    AppLocalizations l10n,
  ) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              fillColor: AppColors.oliveGreen.withOpacity(0.4),
              borderColor: AppColors.oliveGreen,
              entryRadius: 3,
              dataEntries: data.values
                  .map((v) => RadarEntry(value: v))
                  .toList(),
            ),
          ],
          radarShape: RadarShape.circle,
          tickCount: 5,
          getTitle: (index, angle) {
            final axis = data.keys.elementAt(index);
            return RadarChartTitle(
              text: _getAxisLabel(axis, l10n),
              angle: angle,
            );
          },
          tickBorderData: const BorderSide(color: Colors.grey, width: 0.5),
          gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
    );
  }

  String _getAxisLabel(AssessmentAxis axis, AppLocalizations l10n) {
    switch (axis) {
      case AssessmentAxis.emotions:
        return l10n.analyticsAxisEmotions;
      case AssessmentAxis.stressAnxiety:
        return l10n.analyticsAxisStress;
      case AssessmentAxis.sleepEnergy:
        return l10n.analyticsAxisSleep;
      case AssessmentAxis.productivity:
        return l10n.analyticsAxisProductivity;
      case AssessmentAxis.socialSupport:
        return l10n.analyticsAxisSocial;
      default:
        return "";
    }
  }

  Widget _buildAxisDetail(
    AssessmentAxis axis,
    double value,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return SindGlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getAxisLabel(axis, l10n),
                style: theme.textTheme.titleMedium,
              ),
              Text(
                "${(value * 100).toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _getTechnicalTerm(axis, value),
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey.shade200,
            color: value > 0.7
                ? Colors.red
                : (value > 0.4 ? Colors.orange : AppColors.oliveGreen),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  String _getTechnicalTerm(AssessmentAxis axis, double value) {
    if (value < 0.3) return "Stabilité homéostatique";
    switch (axis) {
      case AssessmentAxis.emotions:
        return value > 0.7 ? "Dysrégulation affective" : "Fluctuation thymique";
      case AssessmentAxis.stressAnxiety:
        return value > 0.7 ? "Charge allostatique critique" : "Tension adaptative";
      case AssessmentAxis.sleepEnergy:
        return value > 0.7 ? "Désynchronisation circadienne" : "Dette de sommeil";
      case AssessmentAxis.productivity:
        return value > 0.7 ? "Inhibition cognitive" : "Fatigue exécutive";
      default:
        return "Indicateur clinique";
    }
  }
}
