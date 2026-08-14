import 'package:flutter/material.dart';
import 'package:projetmascara/core/theme/app_animations.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyPolicy)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FadeInAnimation(
              child: Center(
                child: Icon(Icons.security_outlined, size: 80, color: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: 32),
            FadeInAnimation(
              delay: const Duration(milliseconds: 200),
              child: Text(
                l10n.privacyEngagement,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            FadeInAnimation(
              delay: const Duration(milliseconds: 300),
              child: _PrivacyTile(
                icon: Icons.lock_outline,
                title: l10n.dataSovereigntyTitle,
                description: l10n.dataSovereigntyDesc,
              ),
            ),
            FadeInAnimation(
              delay: const Duration(milliseconds: 400),
              child: _PrivacyTile(
                icon: Icons.visibility_off_outlined,
                title: l10n.anonymityTitle,
                description: l10n.anonymityDesc,
              ),
            ),
            FadeInAnimation(
              delay: const Duration(milliseconds: 500),
              child: _PrivacyTile(
                icon: Icons.psychology_outlined,
                title: l10n.professionalSecretTitle,
                description: l10n.professionalSecretDesc,
              ),
            ),
            const SizedBox(height: 32),
            const FadeInAnimation(
              delay: Duration(milliseconds: 600),
              child: Divider(),
            ),
            const SizedBox(height: 24),
            FadeInAnimation(
              delay: const Duration(milliseconds: 700),
              child: Text(
                l10n.userRightsTitle,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            FadeInAnimation(
              delay: const Duration(milliseconds: 800),
              child: Text(
                l10n.userRightsDesc,
                style: const TextStyle(height: 1.5, color: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: 48),
            FadeInAnimation(
              delay: const Duration(milliseconds: 900),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(60)),
                child: Text(l10n.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PrivacyTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blueGrey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.blueGrey, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
