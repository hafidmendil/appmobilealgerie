import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:projetmascara/features/assessment/assessment_state.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/theme/tokens/app_spacing.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(assessmentHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.assessmentHistory),
      ),
      body: historyAsync.when(
        data: (history) => history.isEmpty
            ? Center(child: Text(l10n.noAssessmentsYet))
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final record = history[index];
                  final date = DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(record.createdAt);

                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.oliveGreen.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.clipboard_list, color: AppColors.oliveGreen),
                      ),
                      title: Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${l10n.assessmentTitle} - ${record.answers.length} questions"),
                      trailing: const Icon(LucideIcons.chevron_right),
                      onTap: () {
                        ref.read(assessmentProvider.notifier).loadRecord(record);
                        context.push('/results');
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("${l10n.error_occurred}: $e")),
      ),
    );
  }
}
