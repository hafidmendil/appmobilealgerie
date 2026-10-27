import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/providers/local_care_providers.dart';

/// Local administration of the care and awareness network. Individual
/// assessments are not exposed here: organisations manage only their directory
/// record and verification status.
class AwarenessAdminScreen extends ConsumerWidget {
  const AwarenessAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final partners = ref.watch(localPartnersProvider(null));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.awareness_network_title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.add_partner),
      ),
      body: partners.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(l10n.load_network_error(error.toString())),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.no_partners_msg),
              ),
            );
          }
          return ListView.separated(
            itemCount: items.length,
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final partner = items[index];
              final approved =
                  partner['verified'] == true &&
                  partner['status'] == 'approved';
              return Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.school_outlined,
                    color: Colors.teal,
                  ),
                  title: Text('${partner['name']}'),
                  subtitle: Text(
                    '${partner['type']} · Wilaya ${partner['wilayaId']}\n${partner['contact'] ?? ''}',
                  ),
                  isThreeLine: true,
                  trailing: approved
                      ? Chip(label: Text(l10n.verified_chip))
                      : TextButton(
                          onPressed: () => _approve(ref, partner),
                          child: Text(l10n.verify_btn),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _approve(WidgetRef ref, Map<String, dynamic> partner) async {
    final actor = ref.read(currentUserProvider);
    await ref
        .read(localCareRepositoryProvider)
        .savePartner(
          id: '${partner['id']}',
          name: '${partner['name']}',
          type: '${partner['type']}',
          specialty: '${partner['specialty']}',
          wilayaId: '${partner['wilayaId']}',
          communeId: '${partner['communeId'] ?? ''}',
          contact: '${partner['contact'] ?? ''}',
          availability: '${partner['availability'] ?? 'unknown'}',
          services: List<String>.from(partner['services'] as List? ?? const []),
          supportedSituations: List<String>.from(
            partner['supportedSituations'] as List? ?? const [],
          ),
          supportedRiskLevels: List<String>.from(
            partner['supportedRiskLevels'] as List? ?? const [],
          ),
          languages: List<String>.from(
            partner['languages'] as List? ?? const ['fr', 'ar'],
          ),
          verified: true,
          status: 'approved',
          active: true,
          actorId: actor?.id,
        );
    ref.invalidate(localPartnersProvider(null));
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final name = TextEditingController();
    final wilaya = TextEditingController();
    final contact = TextEditingController();
    var type = 'UNIVERSITY';
    var specialty = 'awareness';
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.new_local_partner),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: InputDecoration(labelText: l10n.name_field),
                ),
                DropdownButtonFormField<String>(
                  value: specialty,
                  decoration: InputDecoration(labelText: l10n.domain_field),
                  items: [
                    DropdownMenuItem(
                      value: 'psychologist',
                      child: Text(l10n.specialty_psychologist),
                    ),
                    DropdownMenuItem(
                      value: 'psychiatrist',
                      child: Text(l10n.specialty_psychiatrist),
                    ),
                    DropdownMenuItem(
                      value: 'neurologist',
                      child: Text(l10n.specialty_neurologist),
                    ),
                    DropdownMenuItem(
                      value: 'healthProfessional',
                      child: Text(l10n.specialty_health_professional),
                    ),
                    DropdownMenuItem(
                      value: 'socialWorker',
                      child: Text(l10n.specialty_social_worker),
                    ),
                    DropdownMenuItem(
                      value: 'legalSupport',
                      child: Text(l10n.specialty_legal_support),
                    ),
                    DropdownMenuItem(
                      value: 'association',
                      child: Text(l10n.specialty_association),
                    ),
                    DropdownMenuItem(
                      value: 'awareness',
                      child: Text(l10n.specialty_awareness),
                    ),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => specialty = value!),
                ),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: InputDecoration(labelText: l10n.type_field),
                  items: [
                    DropdownMenuItem(
                      value: 'MIDDLE_SCHOOL',
                      child: Text(l10n.type_middle_school),
                    ),
                    DropdownMenuItem(
                      value: 'HIGH_SCHOOL',
                      child: Text(l10n.type_high_school),
                    ),
                    DropdownMenuItem(
                      value: 'UNIVERSITY',
                      child: Text(l10n.type_university),
                    ),
                    DropdownMenuItem(
                      value: 'COMPANY',
                      child: Text(l10n.type_company),
                    ),
                    DropdownMenuItem(
                      value: 'ASSOCIATION',
                      child: Text(l10n.type_association),
                    ),
                  ],
                  onChanged: (value) => setDialogState(() => type = value!),
                ),
                TextField(
                  controller: wilaya,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.wilaya_code_field,
                  ),
                ),
                TextField(
                  controller: contact,
                  decoration: InputDecoration(
                    labelText: l10n.professional_contact_field,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    l10n.pending_verification_note,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.save_btn),
            ),
          ],
        ),
      ),
    );
    if (save != true || name.text.trim().isEmpty || wilaya.text.trim().isEmpty)
      return;
    final actor = ref.read(currentUserProvider);
    await ref
        .read(localCareRepositoryProvider)
        .savePartner(
          name: name.text,
          type: specialty == 'awareness' ? type : specialty,
          specialty: specialty,
          wilayaId: wilaya.text,
          contact: contact.text,
          services: specialty == 'awareness'
              ? const ['awareness_campaigns']
              : const ['orientation'],
          supportedSituations: specialty == 'awareness'
              ? const ['informational']
              : const ['vulnerability', 'victim', 'actor', 'witness'],
          supportedRiskLevels: specialty == 'awareness'
              ? const ['low']
              : const ['low', 'moderate'],
          actorId: actor?.id,
        );
    ref.invalidate(localPartnersProvider(null));
  }
}
