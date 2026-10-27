import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import 'package:projetmascara/core/theme/tokens/app_spacing.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class MedicalDisclaimerBanner extends StatelessWidget {
  const MedicalDisclaimerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.shield_alert, color: Colors.orange, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.medical_disclaimer,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.disclaimer_text,
                  style: TextStyle(
                    color: Colors.orange.shade900,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
