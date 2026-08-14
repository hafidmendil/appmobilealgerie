import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Ta sécurité compte"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.danger,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(LucideIcons.shield_alert, size: 80, color: AppColors.danger),
            const SizedBox(height: AppSpacing.xl),
            Text(
              "Tu n'es pas seul(e).",
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.danger,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              "Si tu te sens en danger immédiat ou si tu as besoin d'une aide urgente, utilise les ressources ci-dessous.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            _SafetyActionCard(
              title: "Appeler les Urgences",
              icon: LucideIcons.phone_call,
              color: AppColors.danger,
              onTap: () {},
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            _SafetyActionCard(
              title: "Contacter une personne de confiance",
              icon: LucideIcons.user_plus,
              color: AppColors.oliveGreen,
              onTap: () {},
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            _SafetyActionCard(
              title: "Trouver de l'aide à proximité",
              icon: LucideIcons.map_pin,
              color: AppColors.info,
              onTap: () => context.push('/resources'),
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            SindSecondaryButton(
              label: "Retour au parcours",
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SafetyActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.largeRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          border: Border.all(color: color.withOpacity(0.2), width: 2),
          borderRadius: AppRadii.largeRadius,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Icon(LucideIcons.chevron_right, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
