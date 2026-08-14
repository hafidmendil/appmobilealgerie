import 'package:flutter/material.dart';
import 'package:projetmascara/features/onboarding/consent_screen.dart';

class PrivacyInfoScreen extends StatelessWidget {
  const PrivacyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Confidentialité",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 24),
              const _PrivacyItem(
                title: "Traitement local",
                description: "Vos données sont traitées sur votre appareil autant que possible.",
              ),
              const _PrivacyItem(
                title: "Anonymat",
                description: "Aucune collecte nominative inutile n'est effectuée.",
              ),
              const _PrivacyItem(
                title: "Pas de profilage criminel",
                description: "NeuroSync n'est pas un outil de prédiction ou de surveillance.",
              ),
              const _PrivacyItem(
                title: "Confidentialité totale",
                description: "Aucune transmission automatique aux autorités n'est prévue.",
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
                child: const Text("Continuer vers le consentement"),
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
          Text(
            description,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
