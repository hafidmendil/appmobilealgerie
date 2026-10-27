import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/services/hive_assessment_repository.dart';
import '../../features/assessment/assessment_record.dart';
import '../../generated/l10n/app_localizations.dart';

final assessmentHistoryProvider = FutureProvider<List<AssessmentRecord>>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  final records = await HiveAssessmentRepository().getAssessments(userId);
  records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return records;
});

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final history = ref.watch(assessmentHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.assessment_history),
        actions: [
          IconButton(
            tooltip: l10n.retry,
            onPressed: () => ref.invalidate(assessmentHistoryProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${l10n.error_occurred}: $error', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(assessmentHistoryProvider),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
        data: (records) {
          if (records.isEmpty) {
            return Center(child: Text(l10n.noAssessmentsYet));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    record.isHighRisk
                        ? Icons.warning_amber_rounded
                        : Icons.assignment_turned_in_outlined,
                    color: record.isHighRisk ? Colors.orange.shade800 : null,
                  ),
                  title: Text(l10n.assessmentFinished),
                  subtitle: Text(
                    DateFormat.yMMMd(l10n.localeName)
                        .add_Hm()
                        .format(record.createdAt),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
