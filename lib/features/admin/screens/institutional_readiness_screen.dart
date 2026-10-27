import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/providers/backend_providers.dart';
import 'package:projetmascara/core/services/institutional_readiness_service.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class InstitutionalReadinessScreen extends ConsumerStatefulWidget {
  const InstitutionalReadinessScreen({super.key});

  @override
  ConsumerState<InstitutionalReadinessScreen> createState() =>
      _InstitutionalReadinessScreenState();
}

class _InstitutionalReadinessScreenState
    extends ConsumerState<InstitutionalReadinessScreen> {
  late Future<List<InstitutionalApproval>> _approvals;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _approvals = ref.read(institutionalReadinessServiceProvider).getApprovals();
  }

  Future<void> _edit(InstitutionalApproval approval) async {
    final l10n = AppLocalizations.of(context)!;
    final reviewer = TextEditingController(text: approval.reviewerName);
    final reference = TextEditingController(text: approval.reference);
    final notes = TextEditingController(text: approval.notes);
    final grant = !approval.approved;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(grant ? l10n.grantApproval : l10n.revokeApproval),
        content: grant
            ? SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: reviewer,
                      decoration: InputDecoration(labelText: l10n.approverName),
                    ),
                    TextField(
                      controller: reference,
                      decoration: InputDecoration(
                        labelText: l10n.approvalReference,
                      ),
                    ),
                    TextField(
                      controller: notes,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: l10n.approvalNotes,
                      ),
                    ),
                  ],
                ),
              )
            : Text(l10n.revokeApproval),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(grant ? l10n.grantApproval : l10n.revokeApproval),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final actor = ref.read(currentUserProvider);
    if (actor == null) return;
    try {
      await ref
          .read(institutionalReadinessServiceProvider)
          .setApproval(
            actor: actor,
            area: approval.area,
            approved: grant,
            reviewerName: reviewer.text,
            reference: reference.text,
            notes: notes.text,
          );
      setState(_reload);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      reviewer.dispose();
      reference.dispose();
      notes.dispose();
    }
  }

  String _title(AppLocalizations l10n, InstitutionalApprovalArea area) {
    switch (area) {
      case InstitutionalApprovalArea.legal:
        return l10n.approvalLegal;
      case InstitutionalApprovalArea.medical:
        return l10n.approvalMedical;
      case InstitutionalApprovalArea.institutional:
        return l10n.approvalInstitutional;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.institutionalReadiness)),
      body: FutureBuilder<List<InstitutionalApproval>>(
        future: _approvals,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final approvals = snapshot.data!;
          final ready = approvals.every((approval) => approval.approved);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: ready ? Colors.green.shade50 : Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    ready ? l10n.publicReleaseReady : l10n.publicReleaseBlocked,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...approvals.map(
                (approval) => Card(
                  child: ListTile(
                    leading: Icon(
                      approval.approved
                          ? Icons.verified_user
                          : Icons.pending_actions,
                      color: approval.approved ? Colors.green : Colors.orange,
                    ),
                    title: Text(_title(l10n, approval.area)),
                    subtitle: Text(
                      approval.approved
                          ? '${l10n.approvalGranted} · ${approval.reviewerName}\n${approval.reference}${approval.decidedAt == null ? '' : ' · ${DateFormat.yMMMd(l10n.localeName).format(approval.decidedAt!.toLocal())}'}'
                          : l10n.approvalPending,
                    ),
                    isThreeLine: approval.approved,
                    trailing: TextButton(
                      onPressed: () => _edit(approval),
                      child: Text(
                        approval.approved
                            ? l10n.revokeApproval
                            : l10n.grantApproval,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
