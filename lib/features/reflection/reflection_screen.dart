import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';
import '../../generated/l10n/app_localizations.dart';

class ReflectionScreen extends ConsumerWidget {
  const ReflectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Réflexions"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _ReflectionCard(
            date: "13 Août 2026",
            question: "Qu'est-ce qui vous apporte actuellement du réconfort ?",
            answer: "La lecture et le calme du matin me permettent de me recentrer.",
            icon: LucideIcons.sun,
          ),
          const SizedBox(height: AppSpacing.md),
          _ReflectionCard(
            date: "12 Août 2026",
            question: "Quelle petite chose pourriez-vous faire aujourd'hui ?",
            answer: "Prendre le temps d'appeler un ami pour prendre des nouvelles.",
            icon: LucideIcons.phone,
          ),
        ],
      ),
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  final String date;
  final String question;
  final String answer;
  final IconData icon;

  const _ReflectionCard({
    required this.date,
    required this.question,
    required this.answer,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SindGlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMuted)),
              Icon(icon, size: 16, color: AppColors.oliveGreen),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            answer,
            style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
