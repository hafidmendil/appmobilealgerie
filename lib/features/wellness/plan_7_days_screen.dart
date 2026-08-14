import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';
import '../adaptive_assessment/domain/engines/plan_7_days_engine.dart';
import '../adaptive_assessment/domain/models/assessment_axis.dart';

class Plan7DaysScreen extends ConsumerStatefulWidget {
  const Plan7DaysScreen({super.key});

  @override
  ConsumerState<Plan7DaysScreen> createState() => _Plan7DaysScreenState();
}

class _Plan7DaysScreenState extends ConsumerState<Plan7DaysScreen> {
  final Map<int, bool> _completedDays = {};

  @override
  Widget build(BuildContext context) {
    final engine = Plan7DaysEngine();
    final plan = engine.generatePlan({
      AssessmentAxis.stressAnxiety: 0.6,
    }, 'fr');

    int completedCount = _completedDays.values.where((v) => v).length;
    double progress = completedCount / 7;

    return Scaffold(
      backgroundColor: AppColors.softBlue,
      appBar: AppBar(
        title: const Text("Ton Plan 7 Jours"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Progress Header
            SindGlassCard(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Progression", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${(progress * 100).toInt()}%"),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SindProgressBar(value: progress),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    "$completedCount jours sur 7 complétés",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ).animate().fadeIn(),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Timeline
            ...plan.entries.map((entry) {
              final day = entry.key;
              final task = entry.value;
              final isCompleted = _completedDays[day] ?? false;

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day indicator
                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isCompleted ? AppColors.success : AppColors.oliveGreen.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted ? AppColors.success : AppColors.oliveGreen,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(LucideIcons.check, color: Colors.white, size: 20)
                                : Text(
                                    "$day",
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.oliveGreen),
                                  ),
                          ),
                        ),
                        if (day < 7)
                          Container(
                            width: 2,
                            height: 60,
                            color: isCompleted ? AppColors.success : AppColors.oliveGreen.withOpacity(0.2),
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // Task Card
                    Expanded(
                      child: SindGlassCard(
                        color: isCompleted ? AppColors.success.withOpacity(0.05) : Colors.white,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jour $day",
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: isCompleted ? AppColors.success : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    task,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: isCompleted,
                              activeColor: AppColors.success,
                              onChanged: (val) {
                                setState(() {
                                  _completedDays[day] = val ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: (day * 100).ms).slideX(begin: 0.1, end: 0),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            const SizedBox(height: AppSpacing.xxl),
            
            SindPrimaryButton(
              label: "Fermer",
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
