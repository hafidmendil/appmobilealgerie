import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/admin/admin_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/models/user_model.dart';

class ProfessionalManagementScreen extends ConsumerStatefulWidget {
  const ProfessionalManagementScreen({super.key});

  @override
  ConsumerState<ProfessionalManagementScreen> createState() => _ProfessionalManagementScreenState();
}

class _ProfessionalManagementScreenState extends ConsumerState<ProfessionalManagementScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final prosAsync = ref.watch(adminProfessionalsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.professionalManagement),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: l10n.all,
                  selected: _filter == 'all',
                  onSelected: (_) => setState(() => _filter = 'all'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.statusPending,
                  selected: _filter == 'pending',
                  onSelected: (_) => setState(() => _filter = 'pending'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.statusApproved,
                  selected: _filter == 'approved',
                  onSelected: (_) => setState(() => _filter = 'approved'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.statusRejected,
                  selected: _filter == 'rejected',
                  onSelected: (_) => setState(() => _filter = 'rejected'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: prosAsync.when(
        data: (pros) {
          final filtered = _filter == 'all' ? pros : pros.where((p) => p.status == _filter).toList();
          
          if (filtered.isEmpty) {
            return Center(child: Text(l10n.noPendingRequests));
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final pro = filtered[index];
              return _ProfessionalTile(professional: pro);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("${l10n.error_occurred}: $e")),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }
}

class _ProfessionalTile extends ConsumerWidget {
  final UserModel professional;

  const _ProfessionalTile({required this.professional});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(professional.email, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${l10n.status_label}: ${_getStatusLabel(l10n, professional.status)}"),
        trailing: professional.status == 'pending' 
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () => ref.read(adminNotifierProvider.notifier).updateProfessionalStatus(professional.id, 'approved'),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => ref.read(adminNotifierProvider.notifier).updateProfessionalStatus(professional.id, 'rejected'),
                ),
              ],
            )
          : _getStatusIcon(professional.status),
      ),
    );
  }

  String _getStatusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'approved': return l10n.statusApproved;
      case 'pending': return l10n.statusPending;
      case 'rejected': return l10n.statusRejected;
      default: return status;
    }
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'approved': return const Icon(Icons.verified, color: Colors.blue);
      case 'rejected': return const Icon(Icons.block, color: Colors.red);
      default: return const Icon(Icons.info_outline);
    }
  }
}
