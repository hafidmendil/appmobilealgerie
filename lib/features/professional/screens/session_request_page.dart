import 'package:flutter/material.dart';
import '../models/professional_model.dart';
import '../models/session_request_model.dart';

class SessionRequestPage extends StatefulWidget {
  final ProfessionalModel professional;

  const SessionRequestPage({super.key, required this.professional});

  @override
  State<SessionRequestPage> createState() => _SessionRequestPageState();
}

class _SessionRequestPageState extends State<SessionRequestPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTime;
  String? _sessionType = 'Présentiel';
  final _messageController = TextEditingController();
  bool _consentGiven = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demander une séance')),
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
                decoration: const InputDecoration(
                  labelText: 'Message (facultatif)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              _buildConsentSection(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _consentGiven ? _showConfirmationDialog : null,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  child: const Text('Confirmer la demande'),
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
      title: const Text('Date souhaitée'),
      subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
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
        items: ['Présentiel', 'En ligne', 'Domicile']
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => _sessionType = v),
        decoration: const InputDecoration(labelText: 'Type de séance', border: OutlineInputBorder()),
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
      child: Column(
        children: [
          const Text(
            'Les informations sélectionnées seront transmises au professionnel afin de traiter votre demande de séance.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          CheckboxListTile(
            title: const Text('J\'accepte la transmission de ces informations.'),
            value: _consentGiven,
            onChanged: (v) => setState(() => _consentGiven = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer l\'envoi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Voulez-vous envoyer cette demande à ce professionnel ?'),
            const SizedBox(height: 12),
            Text('Professionnel : ${widget.professional.fullName}'),
            Text('Date : ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
            Text('Type : $_sessionType'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: _submitRequest, child: const Text('Confirmer')),
        ],
      ),
    );
  }

  void _submitRequest() {
    // Logic to call repository and send request
    Navigator.pop(context); // Close dialog
    Navigator.pop(context); // Return to profile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demande envoyée avec succès')),
    );
  }
}
