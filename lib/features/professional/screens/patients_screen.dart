import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/features/professional/professional_provider.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/theme/app_animations.dart';

class PatientsScreen extends ConsumerWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsAsync = ref.watch(authorizedPatientsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myPatients),
      ),
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
                // TODO: Implement local search if needed
              },
            ),
          ),
          Expanded(
            child: patientsAsync.when(
              data: (patients) => patients.isEmpty
                  ? Center(child: Text(l10n.noPatients))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        return FadeInAnimation(
                          delay: Duration(milliseconds: index * 50),
                          child: _PatientListTile(patient: patient),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text("${l10n.error_occurred}: $e")),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientListTile extends StatelessWidget {
  final UserModel patient;

  const _PatientListTile({required this.patient});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
        subtitle: Text("${l10n.user_label} ID: ${patient.id.substring(0, 8)}"),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/psychologist/patients/${patient.id}'),
      ),
    );
  }
}
