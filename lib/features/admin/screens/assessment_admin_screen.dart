import '../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_axis.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_question.dart';
import 'package:projetmascara/features/admin/admin_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class AssessmentAdminScreen extends ConsumerStatefulWidget {
  const AssessmentAdminScreen({super.key});

  @override
  ConsumerState<AssessmentAdminScreen> createState() =>
      _AssessmentAdminScreenState();
}

class _AssessmentAdminScreenState extends ConsumerState<AssessmentAdminScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final questionsAsync = ref.watch(adminQuestionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.assessment_logic_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _confirmReset(l10n),
          ),
        ],
      ),
      body: questionsAsync.when(
        data: (questions) => Column(
          children: [
            _buildHeader(l10n),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  return ListTile(
                    title: Text(q.textFr),
                    subtitle: Text("${q.axis.name} - ${q.subTheme}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(l10n, q),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(l10n, q.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("${l10n.error_occurred}: $e")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(l10n),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.withAlpha(25),
      child: Column(
        children: [
          const Icon(Icons.psychology, size: 48, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            l10n.algorithm_config_title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            l10n.algorithm_config_subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(AppLocalizations l10n, [AssessmentQuestion? question]) {
    final frController = TextEditingController(text: question?.textFr);
    final arController = TextEditingController(text: question?.textAr);
    final themeController = TextEditingController(text: question?.subTheme);
    AssessmentAxis selectedAxis = question?.axis ?? AssessmentAxis.general;
    AnswerType selectedType = question?.answerType ?? AnswerType.frequency;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            question == null ? l10n.add_question : l10n.edit_question,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: frController,
                  decoration: const InputDecoration(
                    labelText: "Texte Français",
                  ),
                  maxLines: 2,
                ),
                TextField(
                  controller: arController,
                  decoration: const InputDecoration(labelText: "Texte Arabe"),
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                ),
                TextField(
                  controller: themeController,
                  decoration: const InputDecoration(labelText: "Sous-thème"),
                ),
                DropdownButton<AssessmentAxis>(
                  value: selectedAxis,
                  isExpanded: true,
                  onChanged: (val) => setState(() => selectedAxis = val!),
                  items: AssessmentAxis.values
                      .map(
                        (a) => DropdownMenuItem(value: a, child: Text(a.name)),
                      )
                      .toList(),
                ),
                DropdownButton<AnswerType>(
                  value: selectedType,
                  isExpanded: true,
                  onChanged: (val) => setState(() => selectedType = val!),
                  items: AnswerType.values
                      .map(
                        (t) => DropdownMenuItem(value: t, child: Text(t.name)),
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
                final newQ = AssessmentQuestion(
                  id: question?.id ?? const Uuid().v4(),
                  textFr: frController.text,
                  textAr: arController.text,
                  axis: selectedAxis,
                  subTheme: themeController.text,
                  answerType: selectedType,
                  options:
                      question?.options ??
                      [], // Would need option editor for full implementation
                );
                ref.read(adminNotifierProvider.notifier).saveQuestion(newQ);
                Navigator.pop(context);
              },
              child: Text(context.l10n.auto_enregistrer),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(AppLocalizations l10n, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.auto_supprimer),
        content: Text(l10n.delete_question_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(adminNotifierProvider.notifier).deleteQuestion(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.auto_supprimer),
          ),
        ],
      ),
    );
  }

  void _confirmReset(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.auto_rinitialiser),
        content: Text(l10n.reset_algorithm_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(adminNotifierProvider.notifier).resetAlgorithm();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.auto_rinitialiser),
          ),
        ],
      ),
    );
  }
}
