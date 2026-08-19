import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/directory_models.dart';

class ProfessionalDetailPage extends StatelessWidget {
  final dynamic record; // Can be Professional or SearchResult

  const ProfessionalDetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final String name = record is Professional ? record.fullName : record.name;
    final String? type = record is Professional ? record.professionalType : record.subType;
    final String? phone = record is Professional ? record.phonePrimary : record.phone;
    final String? address = record is Professional ? record.address : record.address;
    final String? wilaya = record is Professional ? record.wilayaName : record.wilayaName;
    final String status = record.verificationStatus;

    return Scaffold(
      appBar: AppBar(title: const Text('Fiche détaillée')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(LucideIcons.user, size: 40, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                type ?? 'Professionnel de santé',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoTile(LucideIcons.map_pin, 'Localisation', '$wilaya, $address'),
            if (phone != null) _buildInfoTile(LucideIcons.phone, 'Téléphone', phone, isAction: true, onTap: () => _callNumber(phone)),
            _buildInfoTile(LucideIcons.check_circle, 'Statut de vérification', status),
            const SizedBox(height: 32),
            const Text(
              'Avertissement',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const Text(
              'Les informations de cet annuaire proviennent de sources publiques et sont régulièrement vérifiées. Elles peuvent changer. Veuillez confirmer les coordonnées auprès du professionnel avant de vous déplacer.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Report error logic
              },
              icon: const Icon(LucideIcons.alert_triangle),
              label: const Text('Signaler une erreur'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade50, foregroundColor: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value, {bool isAction = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: isAction ? const Icon(LucideIcons.external_link, size: 16) : null,
      onTap: onTap,
    );
  }

  Future<void> _callNumber(String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}
