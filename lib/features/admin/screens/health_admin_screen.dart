import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:projetmascara/features/health/models/health_knowledge_item.dart';
import 'package:projetmascara/features/health/providers/health_provider.dart';
import 'package:projetmascara/features/health/widgets/health_components.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class HealthAdminScreen extends ConsumerStatefulWidget {
  const HealthAdminScreen({super.key});

  @override
  ConsumerState<HealthAdminScreen> createState() => _HealthAdminScreenState();
}

class _HealthAdminScreenState extends ConsumerState<HealthAdminScreen> {
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(healthKnowledgeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.knowledge_management),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () => _showArticleDialog(context, ref),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.title),
            subtitle: EvidenceLevelBadge(level: item.evidenceLevel),
            trailing: const Icon(LucideIcons.pencil),
            onTap: () => _showArticleDialog(context, ref, existing: item),
          );
        },
      ),
    );
  }

  void _showArticleDialog(
    BuildContext context,
    WidgetRef ref, {
    HealthKnowledgeItem? existing,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController(text: existing?.title);
    final arabicTitleController = TextEditingController(
      text: existing?.arabicTitle,
    );
    final descriptionController = TextEditingController(
      text: existing?.description,
    );
    HealthCategory selectedCategory =
        existing?.category ?? HealthCategory.nutrition;
    EvidenceLevel selectedLevel =
        existing?.evidenceLevel ?? EvidenceLevel.uncertain;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(existing == null ? l10n.add_knowledge : 'Modifier'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "${l10n.reportTitle} (FR)",
                  ),
                ),
                TextField(
                  controller: arabicTitleController,
                  decoration: InputDecoration(
                    labelText: "${l10n.reportTitle} (AR)",
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                DropdownButton<HealthCategory>(
                  value: selectedCategory,
                  isExpanded: true,
                  onChanged: (val) => setState(() => selectedCategory = val!),
                  items: HealthCategory.values
                      .map(
                        (c) => DropdownMenuItem(value: c, child: Text(c.name)),
                      )
                      .toList(),
                ),
                DropdownButton<EvidenceLevel>(
                  value: selectedLevel,
                  isExpanded: true,
                  onChanged: (val) => setState(() => selectedLevel = val!),
                  items: EvidenceLevel.values
                      .map(
                        (l) => DropdownMenuItem(value: l, child: Text(l.name)),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final item = HealthKnowledgeItem(
                  id: existing?.id ?? const Uuid().v4(),
                  title: titleController.text,
                  arabicTitle: arabicTitleController.text,
                  description: descriptionController.text,
                  category: selectedCategory,
                  evidenceLevel: selectedLevel,
                  createdAt: existing?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                if (existing == null) {
                  ref.read(healthKnowledgeProvider.notifier).addArticle(item);
                } else {
                  ref
                      .read(healthKnowledgeProvider.notifier)
                      .updateArticle(item);
                }
                Navigator.pop(context);
              },
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }
}
