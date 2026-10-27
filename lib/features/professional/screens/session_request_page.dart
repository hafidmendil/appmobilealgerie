import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/professional_model.dart';
import '../models/session_request_model.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/providers/backend_providers.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../../core/localization/l10n_extension.dart';

class SessionRequestPage extends ConsumerStatefulWidget {
  final ProfessionalModel professional;

  const SessionRequestPage({super.key, required this.professional});

  @override
  ConsumerState<SessionRequestPage> createState() => _SessionRequestPageState();
}

class _SessionRequestPageState extends ConsumerState<SessionRequestPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _sessionType = 'Présentiel';
  final _messageController = TextEditingController();
  bool _consentGiven = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.localAppointmentDraft)),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfessionalSummary(),
              const SizedBox(height: 20),
              _buildDatePicker(),
              _buildSessionTypeSelector(),
              TextFormField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: context.l10n.optional_message,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              _buildConsentSection(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_consentGiven && !_isSubmitting)
                      ? _showConfirmationDialog
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(context.l10n.saveLocalDraft),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalSummary() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(widget.professional.fullName),
        subtitle: Text(widget.professional.specialty),
      ),
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Text(context.l10n.requested_date),
      subtitle: Text(
        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 90)),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
    );
  }

  Widget _buildSessionTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: DropdownButtonFormField<String>(
        value: _sessionType,
        items: [
          'Présentiel',
          'En ligne',
          'Domicile',
        ].map((e) {
          String label;
          if (e == 'Présentiel') label = context.l10n.session_in_person;
          else if (e == 'En ligne') label = context.l10n.session_online;
          else label = context.l10n.session_home;
          return DropdownMenuItem(value: e, child: Text(label));
        }).toList(),
        onChanged: (v) => setState(() => _sessionType = v),
        decoration: InputDecoration(
          labelText: context.l10n.session_type,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildConsentSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Text(
              context.l10n.consent_transmission_info,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: Text(
                context.l10n.consent_transmission_accept,
              ),
              value: _consentGiven,
              onChanged: (v) => setState(() => _consentGiven = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.confirm_send),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.confirm_send_prompt,
            ),
            const SizedBox(height: 12),
            Text('${context.l10n.professional_prefix}${widget.professional.fullName}'),
            Text(
              '${context.l10n.date_prefix}${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            ),
            Text('${context.l10n.type_prefix}$_sessionType'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: _submitRequest,
            child: Text(context.l10n.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRequest() async {
    setState(() => _isSubmitting = true);
    Navigator.pop(context); // Close dialog

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception(context.l10n.user_not_connected);

      final request = SessionRequestModel(
        id: DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF,
        userId: user.id.hashCode,
        professionalId: widget.professional.id,
        wilayaId: widget.professional.wilayaId,
        requestedDate: _selectedDate,
        sessionType: _sessionType,
        userMessage: _messageController.text,
        consentGiven: _consentGiven,
        createdAt: DateTime.now(),
      );

      await ref
          .read(professionalRepositoryProvider)
          .submitSessionRequest(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.request_sent_success),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop(); // Return to profile
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.l10n.error_prefix}$e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
