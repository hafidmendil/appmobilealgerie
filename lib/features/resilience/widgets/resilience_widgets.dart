import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../daily_resilience_provider.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../../core/theme/tokens/app_spacing.dart';
import '../../../core/widgets/sind_components.dart';

class ResilienceWidget extends ConsumerWidget {
  const ResilienceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyResilienceProvider);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SindGlassCard(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: isRtl
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isRtl ? "شجرة الحياة الخاصة بك" : "Votre Arbre de Vie",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                isRtl
                    ? "المستوى ${state.treeLevel}"
                    : "Niveau ${state.treeLevel}",
                style: const TextStyle(
                  color: AppColors.oliveGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text("🌳", style: TextStyle(fontSize: 48)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: isRtl
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRtl
                          ? "أكمل مهامك لتنمو شجرتك."
                          : "Complétez vos actions pour faire grandir votre arbre.",
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: state.progress,
                      backgroundColor: AppColors.softOlive.withAlpha(50),
                      color: AppColors.oliveGreen,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Text(
            isRtl ? "مهام اليوم" : "Actions du jour",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...state.tasks.map(
            (task) => CheckboxListTile(
              title: Text(
                isRtl
                    ? "${task.icon} ${task.titleAr}"
                    : "${task.icon} ${task.title}",
              ),
              value: task.isCompleted,
              onChanged: (_) => ref
                  .read(dailyResilienceProvider.notifier)
                  .toggleTask(task.id),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
