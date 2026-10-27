import 'package:flutter/material.dart';
import 'package:projetmascara/features/onboarding/consent_screen.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class PrivacyInfoScreen extends StatelessWidget {
  const PrivacyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.privacy_label,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 24),
              _PrivacyItem(
                title: l10n.dataSovereigntyTitle,
                description: l10n.dataSovereigntyDesc,
              ),
              _PrivacyItem(
                title: l10n.anonymityTitle,
                description: l10n.anonymityDesc,
              ),
              _PrivacyItem(
                title: l10n.professionalSecretTitle,
                description: l10n.professionalSecretDesc,
              ),
              _PrivacyItem(
                title: l10n.userRightsTitle,
                description: l10n.userRightsDesc,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ConsentScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(l10n.continue_to_consent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final String title;
  final String description;

  const _PrivacyItem({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
