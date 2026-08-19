import 'package:flutter/material.dart';
import '../models/professional_model.dart';
import '../../../core/services/whatsapp_service.dart';
import '../../../core/services/location_service.dart';
import 'session_request_page.dart';

class ProfessionalProfilePage extends StatelessWidget {
  final ProfessionalModel professional;
  final WhatsAppService _whatsAppService = WhatsAppService();
  final LocationService _locationService = LocationService();

  ProfessionalProfilePage({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(professional.fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: professional.photo != null ? NetworkImage(professional.photo!) : null,
                child: professional.photo == null ? const Icon(Icons.person, size: 60) : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(professional.fullName, style: Theme.of(context).textTheme.headlineMedium),
            Text(professional.specialty, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blue)),
            const Divider(),
            _buildInfoSection(Icons.location_on, 'Adresse', professional.address),
            _buildInfoSection(Icons.language, 'Langues', professional.languages?.join(', ') ?? 'Non spécifié'),
            _buildInfoSection(Icons.info, 'Biographie', professional.biography ?? 'Aucune biographie disponible'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (professional.phone != null)
                  _buildActionButton(context, Icons.phone, 'Appeler', () => _callNumber(professional.phone!)),
                if (professional.whatsapp != null)
                  _buildActionButton(context, Icons.chat, 'WhatsApp', () => _whatsAppService.openWhatsApp(professional.whatsapp!)),
                if (professional.latitude != null && professional.longitude != null)
                  _buildActionButton(context, Icons.map, 'Carte', () => _locationService.openMap(professional.latitude!, professional.longitude!)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _navigateToRequest(context),
                child: const Text('Demander une séance', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(content),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton.filledTonal(onPressed: onPressed, icon: Icon(icon)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _callNumber(String number) async {
    // Implementation using url_launcher
  }

  void _navigateToRequest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionRequestPage(professional: professional),
      ),
    );
  }
}
