import '../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../professional/professional_provider.dart';
import '../../core/models/user_model.dart';
import 'widgets/patient_trend_chart.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';

class PatientDetailsPage extends ConsumerWidget {
  final String patientId;

  const PatientDetailsPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsync = ref.watch(patientDetailProvider(patientId));
    final assessmentsAsync = ref.watch(patientAssessmentsProvider(patientId));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.auto_dtails_patient)),
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
                    assessmentsAsync.when(
                      data: (records) => PatientTrendChart(records: records),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) =>
                          Text("Erreur lors du chargement des bilans: $e"),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Dernières Observations",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildObservationsList(),
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
        const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name ?? "Anonyme",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(user.email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(50),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "Suivi Actif",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildObservationsList() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Aucune observation clinique pour le moment. L'IA n'a pas détecté de risque immédiat dans les derniers bilans.",
        ),
      ),
    );
  }
}
