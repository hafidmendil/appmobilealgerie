import 'package:flutter/material.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/features/onboarding/privacy_screen.dart';

class PurposeScreen extends StatelessWidget {
  const PurposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.purposeTitle,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 24),
              _PurposeItem(
                icon: Icons.insights,
                text: l10n.purposeItem1,
              ),
              _PurposeItem(
                icon: Icons.explore,
                text: l10n.purposeItem2,
              ),
              _PurposeItem(
                icon: Icons.warning_amber_rounded,
                text: l10n.purposeItem3,
                isWarning: true,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PrivacyInfoScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(l10n.continueLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PurposeItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isWarning;

  const _PurposeItem({
    required this.icon,
    required this.text,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isWarning ? Colors.orange[800] : const Color(0xFF455A64),
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
