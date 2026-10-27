import '../../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/theme/app_theme.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import '../../domain/models/legal_models.dart';
import '../providers/legal_providers.dart';

class ReportBuilderPage extends ConsumerStatefulWidget {
  const ReportBuilderPage({super.key});

  @override
  ConsumerState<ReportBuilderPage> createState() => _ReportBuilderPageState();
}

class _ReportBuilderPageState extends ConsumerState<ReportBuilderPage> {
  late TextEditingController _summaryController;
  late TextEditingController _recipientNameController;
  late TextEditingController _recipientContactController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(reportDraftStateProvider);
    _summaryController = TextEditingController(text: draft?.summaryText ?? '');
    _recipientNameController = TextEditingController(
      text: draft?.recipient.name ?? '',
    );
    _recipientContactController = TextEditingController(
      text: draft?.recipient.contactInfo ?? '',
    );
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _recipientNameController.dispose();
    _recipientContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(reportDraftStateProvider);
    final consent = ref.watch(consentStateProvider);

    if (draft == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.report_builder_preparation),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.description_outlined,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(context.l10n.auto_aucun_brouillon_signalement_cours),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go('/legal/questionnaire'),
                child: Text(context.l10n.auto_crer_une_orientation),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.auto_prparation_signalement_report_builder),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Workflow Stepper Indicator
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildWorkflowStep(context.l10n.report_builder_step_collect, true),
                    _buildWorkflowArrow(),
                    _buildWorkflowStep(context.l10n.report_builder_step_preview, true),
                    _buildWorkflowArrow(),
                    _buildWorkflowStep(context.l10n.report_builder_step_edit, true),
                    _buildWorkflowArrow(),
                    _buildWorkflowStep(
                      context.l10n.report_builder_step_confirm,
                      draft.status == LegalReportStatus.userConfirmed,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Status Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.preview_outlined,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.l10n.report_builder_preview_title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              draft.status.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor:
                                draft.status == LegalReportStatus.userConfirmed
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Text(
                        context.l10n.report_builder_local_id(draft.id),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Consentement associé : ${consent?.checksum != null ? context.l10n.report_builder_consent_validated(consent!.checksum.substring(0, 10)) : context.l10n.report_builder_consent_pending}',
                        style: TextStyle(
                          fontSize: 12,
                          color: consent != null
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Section: Faits collectés
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.report_builder_facts_title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _summaryController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: context.l10n.report_builder_facts_hint,
                        ),
                        onChanged: (text) {
                          ref
                              .read(reportDraftStateProvider.notifier)
                              .updateSummary(text);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Section: Destinataire
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.report_builder_recipient_title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _recipientNameController,
                        decoration: InputDecoration(
                          labelText: context.l10n.report_builder_recipient_name_label,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) => _updateRecipient(),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _recipientContactController,
                        decoration: InputDecoration(
                          labelText: context.l10n.report_builder_recipient_contact_label,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) => _updateRecipient(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Section: Pièces jointes (Attachments)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              context.l10n.report_builder_attachments_title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              ref
                                  .read(reportDraftStateProvider.notifier)
                                  .addAttachment(
                                    ReportAttachment(
                                      id: 'att_${DateTime.now().millisecondsSinceEpoch}',
                                      fileName: 'Certificat_medical_ITT.pdf',
                                      fileType: 'pdf',
                                      addedAt: DateTime.now(),
                                    ),
                                  );
                            },
                            icon: const Icon(Icons.add),
                            label: Text(context.l10n.auto_ajouter),
                          ),
                        ],
                      ),
                      if (draft.attachments.isEmpty)
                        Text(
                          context.l10n.report_builder_attachments_empty,
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        )
                      else
                        ...draft.attachments.map(
                          (att) => ListTile(
                            leading: Icon(
                              Icons.attach_file,
                              color: AppColors.primary,
                            ),
                            title: Text(
                              att.fileName,
                              style: const TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              context.l10n.report_builder_attachments_added_at(att.addedAt.toString().substring(0, 16)),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                ref
                                    .read(reportDraftStateProvider.notifier)
                                    .removeAttachment(att.id);
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Confirm and Submit / Save Draft
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: consent != null
                      ? () async {
                          await ref
                              .read(reportDraftStateProvider.notifier)
                              .confirmAndSave(consent.id);
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(
                                  context.l10n.report_builder_dialog_title,
                                ),
                                content: Text(
                                  context.l10n.report_builder_dialog_content,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                      context.go('/legal');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      : null,
                  icon: const Icon(Icons.check_circle_outline, size: 22),
                  label: Text(
                    context.l10n.report_builder_confirm_btn,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _updateRecipient() {
    final draft = ref.read(reportDraftStateProvider);
    if (draft == null) return;
    ref
        .read(reportDraftStateProvider.notifier)
        .updateRecipient(
          ReportRecipient(
            id: draft.recipient.id,
            name: _recipientNameController.text,
            type: draft.recipient.type,
            contactInfo: _recipientContactController.text,
          ),
        );
  }

  Widget _buildWorkflowStep(String label, bool isCompleted) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
          color: isCompleted ? AppColors.primary : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildWorkflowArrow() {
    return const Icon(Icons.chevron_right, size: 14, color: Colors.grey);
  }
}
