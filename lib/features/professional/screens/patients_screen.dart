import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/features/professional/professional_provider.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/theme/app_animations.dart';

class PatientsScreen extends ConsumerStatefulWidget {
  const PatientsScreen({super.key});

  @override
  ConsumerState<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends ConsumerState<PatientsScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(authorizedPatientsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myPatients)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchPatient,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: patientsAsync.when(
              data: (patients) {
                final filtered = patients.where((p) {
                  return p.email.toLowerCase().contains(_searchQuery) ||
                      p.id.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? l10n.noPatients
                          : "Aucun patient trouvé",
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final patient = filtered[index];
                    return FadeInAnimation(
                      delay: Duration(milliseconds: index * 50),
                      child: _PatientListTile(patient: patient),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) =>
                  Center(child: Text("${l10n.error_occurred}: $e")),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientListTile extends ConsumerWidget {
  final UserModel patient;

  const _PatientListTile({required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final assessmentsAsync = ref.watch(patientAssessmentsProvider(patient.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey[100],
          child: Text(patient.email.substring(0, 1).toUpperCase()),
        ),
        title: Text(
          patient.email,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: assessmentsAsync.when(
          data: (list) {
            final isHighRisk = list.any((r) => r.isHighRisk);
            return Row(
              children: [
                Text("${l10n.user_label} ID: ${patient.id.substring(0, 8)}"),
                if (isHighRisk) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "RISQUE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
          loading: () =>
              Text("${l10n.user_label} ID: ${patient.id.substring(0, 8)}"),
          error: (_, __) =>
              Text("${l10n.user_label} ID: ${patient.id.substring(0, 8)}"),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/psychologist/patients/${patient.id}'),
      ),
    );
  }
}
