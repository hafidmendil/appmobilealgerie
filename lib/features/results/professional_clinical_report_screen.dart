import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/features/assessment/assessment_models.dart';
import 'package:projetmascara/features/results/clinical_report.dart';
import 'package:projetmascara/features/engine/decision_engine.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/localization/l10n_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class ProfessionalClinicalReportScreen extends ConsumerWidget {
  final AssessmentRecord record;

  const ProfessionalClinicalReportScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // Compute result for this specific record
    final result = DeterministicDecisionEngine.compute(record.answers, record.safetyAnswers);
    final report = ClinicalReportGenerator.generate(result, record.answers);
    final dateStr = DateFormat.yMMMd(Localizations.localeOf(context).languageCode).add_Hm().format(record.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: Text("${l10n.reportTitle} - $dateStr"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final text = "NeuroSync 4.0 - ${l10n.reportTitle}\n"
                  "Date: $dateStr\n\n"
                  "${l10n.reportPersonStatus}: ${l10n.translate(report['riskLevel'])}\n"
                  "${l10n.recommendations}:\n"
                  "${(report['recommendations'] as List<String>).map((r) => '- ' + l10n.translate(r)).join('\n')}\n\n"
                  "${l10n.reportDisclaimer}";
              Share.share(text);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              l10n.reportPersonStatus,
              Column(
                children: [
                  Text(
                    l10n.translate(report['riskLevel']),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _getRiskColor(result.level),
                    ),
                  ),
                  const Divider(height: 32),
                  ... (report['psychologicalProfile'] as List<String>).map((p) => _profileRow(l10n, p)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              context,
              l10n.redFlags,
              result.isRedFlagTriggered
                  ? _alertBox(l10n, l10n.priority_safety_alert, Colors.red)
                  : Text(l10n.noRedFlags, style: const TextStyle(color: Colors.green)),
            ),
            const SizedBox(height: 32),
            _buildSection(
              context,
              l10n.recommendations,
              Column(
                children: (report['recommendations'] as List<String>).map((r) => _recommendationCard(l10n, r)).toList(),
              ),
            ),
            const SizedBox(height: 48),
            _disclaimer(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _profileRow(AppLocalizations l10n, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.psychology, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(child: Text(l10n.translate(key), style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _recommendationCard(AppLocalizations l10n, String key) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.teal[50],
      elevation: 0,
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.teal, size: 20),
        title: Text(l10n.translate(key), style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _alertBox(AppLocalizations l10n, String message, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: TextStyle(color: color, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _disclaimer(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        l10n.reportDisclaimer,
        style: const TextStyle(fontSize: 12, color: Colors.brown, fontStyle: FontStyle.italic),
      ),
    );
  }

  Color _getRiskColor(OrientationLevel level) {
    switch (level) {
      case OrientationLevel.level1: return Colors.green;
      case OrientationLevel.level2: return Colors.blue;
      case OrientationLevel.level3: return Colors.orange;
      case OrientationLevel.level4: return Colors.red;
    }
  }
}
