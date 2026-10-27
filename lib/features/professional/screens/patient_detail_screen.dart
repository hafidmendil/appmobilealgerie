import '../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../professional_provider.dart';
import '../../../core/models/user_model.dart';
import '../../dashboard/widgets/patient_trend_chart.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../../core/theme/tokens/app_spacing.dart';
import '../../../core/widgets/sind_components.dart';
import '../../adaptive_assessment/domain/engines/clinical_report_engine.dart';
import '../../adaptive_assessment/domain/engines/scoring_engine.dart';
import '../../adaptive_assessment/domain/engines/orientation_engine.dart';
import '../../adaptive_assessment/domain/models/assessment_result.dart';
import '../../adaptive_assessment/domain/models/assessment_axis.dart';
import '../../assessment/assessment_record.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'package:projetmascara/features/messaging/chat_page.dart';

class PatientDetailScreen extends ConsumerWidget {
  final String patientId;

  const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsync = ref.watch(patientDetailProvider(patientId));
    final assessmentsAsync = ref.watch(patientAssessmentsProvider(patientId));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.auto_dossier_patient)),
      body: patientAsync.when(
        data: (user) => user == null
            ? Center(child: Text(context.l10n.auto_patient_introuvable))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPatientHeader(user),
                    const SizedBox(height: 24),

                    // Visual Trend Analysis
                    SindGlassCard(
                      color: Colors.white,
                      child: assessmentsAsync.when(
                        data: (records) => PatientTrendChart(records: records),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) =>
                            Text("Erreur lors du chargement des bilans: $e"),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      "Observation Clinique",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAIObservationCard(context, assessmentsAsync),

                    const SizedBox(height: 24),
                    const Text(
                      "Actions Recommandées",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildActionButtons(context),
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Erreur: $e")),
      ),
    );
  }

  Widget _buildPatientHeader(UserModel user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.softOlive,
          child: const Icon(
            Icons.person,
            size: 40,
            color: AppColors.oliveGreen,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name ?? "Patient Anonyme",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(user.email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusChip("Suivi Actif", Colors.green),
                const SizedBox(width: 8),
                if (user.wilayaId != null)
                  _buildStatusChip("Wilaya ${user.wilayaId}", Colors.blue),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAIObservationCard(
    BuildContext context,
    AsyncValue<List<AssessmentRecord>> assessments,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return SindGlassCard(
      color: AppColors.softBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.info, size: 20),
              const SizedBox(width: 8),
              Text(
                context.l10n.auto_analyse_assiste_style_textstyle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          assessments.when(
            data: (records) {
              if (records.isEmpty) {
                return Text(context.l10n.auto_analyse_indisponible);
              }
              final lastRecord = records.last;
              final result = _mapRecordToResult(lastRecord);
              return Text(
                ClinicalReportEngine().generateSynthesis(result, l10n),
                style: const TextStyle(fontSize: 14, height: 1.4),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => Text(context.l10n.auto_analyse_indisponible),
          ),
        ],
      ),
    );
  }

  AssessmentResult _mapRecordToResult(AssessmentRecord record) {
    final needs = ScoringEngine().calculateAxisNeeds(
      record.answers.map((key, value) => MapEntry(key, value)),
    );
    final orientation = OrientationEngine().determineLevel(
      record.answers.map((key, value) => MapEntry(key, value)),
      needs,
    );

    return AssessmentResult(
      sessionId: record.id,
      axisNeeds: needs,
      orientationLevel: orientation,
      identifiedThemes: OrientationEngine().getJustifications(
        needs,
        orientation,
      ),
      recommendationIds: [],
      exerciseIds: [],
      spiritualContentIds: [],
      createdAt: record.createdAt,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // open chat with this patient
              final otherId = patientId;
              final otherName = 'Patient';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ChatPage(otherId: otherId, otherName: otherName),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline),
            label: Text(context.l10n.auto_message),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // open chat as placeholder for teleconsult
              final otherId = patientId;
              final otherName = 'Patient';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ChatPage(otherId: otherId, otherName: otherName),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.oliveGreen,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.videocam_outlined),
            label: Text(context.l10n.auto_tlconsult),
          ),
        ),
      ],
    );
  }
}
