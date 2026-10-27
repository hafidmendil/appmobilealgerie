import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/user_role.dart';
import '../../../core/providers/backend_providers.dart';
import '../models/professional_model.dart';
import '../../../core/services/whatsapp_service.dart';
import '../../../core/services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionalProfilePage extends ConsumerWidget {
  final ProfessionalModel professional;
  final WhatsAppService _whatsAppService = WhatsAppService();
  final LocationService _locationService = LocationService();

  ProfessionalProfilePage({super.key, required this.professional});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                backgroundImage: professional.photo != null
                    ? NetworkImage(professional.photo!)
                    : null,
                child: professional.photo == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              professional.fullName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              professional.specialty,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.blue),
            ),
            const Divider(),
            _buildInfoSection(
              Icons.location_on,
              context.l10n.address,
              professional.address,
            ),
            _buildInfoSection(
              Icons.language,
              context.l10n.languages,
              professional.languages?.join(', ') ?? context.l10n.not_specified,
            ),
            _buildInfoSection(
              Icons.info,
              context.l10n.biography,
              professional.biography ?? context.l10n.no_biography_available,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (professional.phone != null)
                  _buildActionButton(
                    context,
                    Icons.phone,
                    context.l10n.call,
                    () => _callNumber(context, professional.phone!),
                  ),
                if (professional.whatsapp != null)
                  _buildActionButton(
                    context,
                    Icons.chat,
                    'WhatsApp',
                    () => _whatsAppService.openWhatsApp(professional.whatsapp!),
                  ),
                if (professional.latitude != null &&
                    professional.longitude != null)
                  _buildActionButton(
                    context,
                    Icons.map,
                    context.l10n.map,
                    () => _locationService.openMap(
                      professional.latitude!,
                      professional.longitude!,
                    ),
                  ),
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
                onPressed: () => _navigateToRequest(context, ref),
                child: Text(
                  context.l10n.request_session,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.person_add_alt_1),
                label: Text(context.l10n.add_to_message),
                onPressed: () => _addForMessaging(context, ref),
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
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(content),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        IconButton.filledTonal(onPressed: onPressed, icon: Icon(icon)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Future<void> _callNumber(BuildContext context, String number) async {
    final uri = Uri(scheme: 'tel', path: number.replaceAll(' ', ''));
    if (!await canLaunchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.cannot_open_phone)),
        );
      }
      return;
    }
    await launchUrl(uri);
  }

  void _navigateToRequest(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.user_not_connected)),
      );
      context.push('/login');
      return;
    }
    if (user.role != UserRole.user) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.request_reserved_for_users)),
      );
      return;
    }
    context.push('/session-request', extra: professional);
  }

  Future<void> _addForMessaging(BuildContext context, WidgetRef ref) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.login_to_add_psy),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await ref
          .read(professionalRepositoryProvider)
          .addProfessionalForMessaging(
            userId: user.id,
            professionalAccountId: professional.id,
          );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.localFollowUpPrepared),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.cannot_add_psychologist(error.toString())),
        ),
      );
    }
  }
}
