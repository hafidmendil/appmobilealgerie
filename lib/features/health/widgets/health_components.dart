import 'package:flutter/material.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import 'package:projetmascara/core/theme/tokens/app_spacing.dart';
import 'package:projetmascara/core/theme/tokens/app_radii.dart';
import 'package:projetmascara/core/widgets/sind_components.dart';
import 'package:projetmascara/features/health/models/health_knowledge_item.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class HealthCategoryCard extends StatelessWidget {
  final HealthCategory category;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const HealthCategoryCard({
    super.key,
    required this.category,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SindGlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.largeRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.oliveGreen, size: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HealthKnowledgeCard extends StatelessWidget {
  final HealthKnowledgeItem item;
  final VoidCallback onTap;

  const HealthKnowledgeCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return SindGlassCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EvidenceLevelBadge(level: item.evidenceLevel),
              if (item.sourceStatus == 'UNVERIFIED') const UnverifiedBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isAr ? item.arabicTitle : item.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isAr ? l10n.contentAvailableInFrench : item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.source ?? "",
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
              ),
              TextButton(onPressed: onTap, child: Text(l10n.read_more)),
            ],
          ),
        ],
      ),
    );
  }
}

class EvidenceLevelBadge extends StatelessWidget {
  final EvidenceLevel level;

  const EvidenceLevelBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    String label;

    switch (level) {
      case EvidenceLevel.traditionalSource:
        color = Colors.brown;
        label = l10n.evidence_traditional;
        break;
      case EvidenceLevel.religiousSource:
        color = AppColors.oliveGreen;
        label = l10n.evidence_religious;
        break;
      case EvidenceLevel.academicResearch:
        color = Colors.blue;
        label = l10n.evidence_academic;
        break;
      case EvidenceLevel.clinicalEvidence:
        color = Colors.red;
        label = l10n.evidence_clinical;
        break;
      case EvidenceLevel.review:
        color = Colors.orange;
        label = l10n.evidence_review;
        break;
      case EvidenceLevel.uncertain:
        color = Colors.grey;
        label = l10n.evidence_uncertain;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class UnverifiedBadge extends StatelessWidget {
  const UnverifiedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        l10n.unverified_source,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
