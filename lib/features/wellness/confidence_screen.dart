import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';

class ConfidenceScreen extends StatelessWidget {
  const ConfidenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        title: const Text("Construire ma confiance"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chaque petit pas compte.",
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ).animate().fadeIn(),
            const SizedBox(height: AppSpacing.xl),
            
            _ConfidenceCard(
              title: "Mes forces",
              icon: LucideIcons.zap,
              color: AppColors.oliveGreen,
              description: "Ce que j'apprécie chez moi aujourd'hui.",
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: AppSpacing.md),
            
            _ConfidenceCard(
              title: "Mes petites réussites",
              icon: LucideIcons.award,
              color: AppColors.skyBlue,
              description: "Une chose simple que j'ai accomplie.",
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: AppSpacing.md),
            
            _ConfidenceCard(
              title: "Mon objectif du jour",
              icon: LucideIcons.target,
              color: AppColors.warning,
              description: "Une petite étape pour avancer.",
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: AppSpacing.md),
            
            _ConfidenceCard(
              title: "Ce que je veux améliorer",
              icon: LucideIcons.trending_up,
              color: AppColors.info,
              description: "Avec douceur et patience.",
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: AppSpacing.xxl),
            
            SindPrimaryButton(
              label: "Écrire dans mon journal",
              onPressed: () {
                // Future journal implementation
              },
              icon: LucideIcons.pen_tool,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfidenceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _ConfidenceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SindGlassCard(
      color: Colors.white,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: AppRadii.mediumRadius,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(LucideIcons.chevron_right, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
