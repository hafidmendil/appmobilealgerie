import '../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';
import 'confidence_provider.dart';

class ConfidenceScreen extends ConsumerStatefulWidget {
  const ConfidenceScreen({super.key});

  @override
  ConsumerState<ConfidenceScreen> createState() => _ConfidenceScreenState();
}

class _ConfidenceScreenState extends ConsumerState<ConfidenceScreen> {
  final _strengthController = TextEditingController();
  final _successController = TextEditingController();
  final _goalController = TextEditingController();
  bool _isWriting = false;

  @override
  void dispose() {
    _strengthController.dispose();
    _successController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_strengthController.text.trim().isEmpty ||
        _successController.text.trim().isEmpty ||
        _goalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.error_fill_all_fields),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    ref
        .read(confidenceEntriesProvider.notifier)
        .addEntry(
          strength: _strengthController.text.trim(),
          success: _successController.text.trim(),
          goal: _goalController.text.trim(),
        );

    _strengthController.clear();
    _successController.clear();
    _goalController.clear();
    setState(() => _isWriting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.action_success),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(confidenceEntriesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        title: Text(context.l10n.confidence_journal),
        actions: [
          if (!_isWriting)
            IconButton(
              icon: const Icon(LucideIcons.circle_plus),
              onPressed: () => setState(() => _isWriting = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isWriting) ...[
              Text(
                context.l10n.confidenceNewJournal,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(),
              const SizedBox(height: AppSpacing.md),
              SindGlassCard(
                color: Colors.white,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    TextField(
                      controller: _strengthController,
                      decoration: InputDecoration(
                        labelText: context.l10n.confidenceStrengthLabel,
                        hintText: context.l10n.confidenceStrengthHint,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _successController,
                      decoration: InputDecoration(
                        labelText: context.l10n.confidenceSuccessLabel,
                        hintText: context.l10n.confidenceSuccessHint,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _goalController,
                      decoration: InputDecoration(
                        labelText: context.l10n.confidenceGoalLabel,
                        hintText: context.l10n.confidenceGoalHint,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _isWriting = false),
                          child: Text(context.l10n.cancel),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        ElevatedButton(
                          onPressed: _saveEntry,
                          child: Text(context.l10n.auto_sauvegarder),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.1, end: 0),
            ] else ...[
              Text(
                context.l10n.confidenceEveryStep,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(),
              const SizedBox(height: AppSpacing.md),
              if (entries.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                    ),
                    child: Text(
                      context.l10n.confidenceEmpty,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final dateStr = DateFormat.yMMMd(
                      context.l10n.localeName,
                    ).format(entry.date);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: SindGlassCard(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dateStr,
                                  style: theme.textTheme.labelSmall,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.heart,
                                      size: 14,
                                      color: AppColors.danger,
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        LucideIcons.trash_2,
                                        size: 16,
                                        color: AppColors.textMuted,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(
                                              confidenceEntriesProvider
                                                  .notifier,
                                            )
                                            .deleteEntry(entry.id);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            _HistoryItem(
                              label: context.l10n.confidenceStrengthLabel,
                              text: entry.strength,
                              color: AppColors.oliveGreen,
                            ),
                            _HistoryItem(
                              label: context.l10n.confidenceSuccessLabel,
                              text: entry.success,
                              color: AppColors.skyBlue,
                            ),
                            _HistoryItem(
                              label: context.l10n.confidenceGoalLabel,
                              text: entry.goal,
                              color: AppColors.warning,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String label;
  final String text;
  final Color color;

  const _HistoryItem({
    required this.label,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 4,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadii.pillRadius,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
                children: [
                  TextSpan(
                    text: "$label : ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
