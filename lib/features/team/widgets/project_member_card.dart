import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import 'package:projetmascara/core/theme/tokens/app_spacing.dart';
import 'package:projetmascara/core/theme/tokens/app_radii.dart';
import 'package:projetmascara/core/widgets/sind_components.dart';
import 'package:projetmascara/features/team/models/project_member.dart';
import 'package:projetmascara/core/services/team/whatsapp_service.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class ProjectMemberCard extends StatelessWidget {
  final ProjectMember member;

  const ProjectMemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SindGlassCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.oliveGreen.withOpacity(0.1),
                child: Text(
                  member.name[0].toUpperCase(),
                  style: theme.textTheme.titleLarge?.copyWith(color: AppColors.oliveGreen),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      member.role,
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.oliveGreen),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (member.expertise != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              member.expertise!,
              style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
          if (member.location != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(LucideIcons.map_pin, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  member.location!,
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ],
          if (member.phone != null) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            InkWell(
              onTap: () => WhatsAppService.openWhatsApp(member.phone!),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(LucideIcons.phone, size: 16, color: AppColors.oliveGreen),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      member.phone!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.oliveGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (member.whatsappEnabled) ...[
              const SizedBox(height: AppSpacing.md),
              SindPrimaryButton(
                label: l10n.contact_whatsapp,
                icon: LucideIcons.message_circle,
                onPressed: () => _handleWhatsAppClick(context),
              ),
            ],
          ],
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  void _handleWhatsAppClick(BuildContext context) async {
    try {
      await WhatsAppService.openWhatsApp(member.phone!);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Impossible d'ouvrir WhatsApp")),
        );
      }
    }
  }
}
