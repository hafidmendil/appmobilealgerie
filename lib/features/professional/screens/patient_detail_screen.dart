import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/professional/professional_provider.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:projetmascara/features/results/professional_clinical_report_screen.dart';

class PatientDetailScreen extends ConsumerWidget {
  final String patientId;

  const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsync = ref.watch(patientDetailProvider(patientId));
    final assessmentsAsync = ref.watch(patientAssessmentsProvider(patientId));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.patientDetail),
      ),
      body: patientAsync.when(
        data: (patient) {
          if (patient == null) {
            return Center(child: Text(l10n.deniedAccess));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(context, patient),
                const SizedBox(height: 24),
                Text(
                  l10n.assessmentHistory,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                assessmentsAsync.when(
                  data: (assessments) => assessments.isEmpty
                      ? Center(child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(l10n.noAssessmentsYet),
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: assessments.length,
                          itemBuilder: (context, index) {
                            final record = assessments[index];
                            return _AssessmentRecordTile(record: record);
                          },
                        ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Text("${l10n.error_occurred}: $e"),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("${l10n.error_occurred}: $e")),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, UserModel patient) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  child: Text(
                    patient.email.substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.email,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${l10n.status_label}: ${l10n.authorizedAccess}",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _infoRow(l10n.user_label + " ID", patient.id),
            _infoRow(l10n.status_label, patient.status),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.blueGrey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _AssessmentRecordTile extends StatelessWidget {
  final AssessmentRecord record;

  const _AssessmentRecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr = DateFormat.yMMMd(Localizations.localeOf(context).languageCode).add_Hm().format(record.createdAt);
    
    // We should ideally use DecisionEngine to show the summary here
    // but for now let's just show the date and a "view" button
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.assignment_outlined, color: Colors.blueAccent),
        title: Text("${l10n.assessmentTitle} - $dateStr"),
        subtitle: Text("${l10n.status_label}: ${record.syncStatus}"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfessionalClinicalReportScreen(record: record),
            ),
          );
        },
      ),
    );
  }
}
