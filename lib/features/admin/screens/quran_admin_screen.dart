import '../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/models/admin/content_models.dart';
import 'package:projetmascara/features/admin/admin_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_axis.dart';
import 'package:uuid/uuid.dart';

class QuranAdminScreen extends ConsumerStatefulWidget {
  const QuranAdminScreen({super.key});

  @override
  ConsumerState<QuranAdminScreen> createState() => _QuranAdminScreenState();
}

class _QuranAdminScreenState extends ConsumerState<QuranAdminScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final versesAsync = ref.watch(adminQuranProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.auto_bibliothque_coranique),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showEditDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: versesAsync.when(
              data: (verses) {
                final filteredVerses = verses.where((v) {
                  final query = _searchQuery.toLowerCase();
                  return v.textAr.contains(query) ||
                      v.textFr.toLowerCase().contains(query) ||
                      v.theme.toLowerCase().contains(query);
                }).toList();

                if (filteredVerses.isEmpty)
                  return Center(child: Text(context.l10n.auto_aucun_verset_trouv));

                return ListView.builder(
                  itemCount: filteredVerses.length,
                  itemBuilder: (context, index) {
                    final verse = filteredVerses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          verse.textAr,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text("${verse.context} - ${verse.theme}"),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Français: ${verse.textFr}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text("Réflexion: ${verse.reflection ?? ''}"),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () => _showEditDialog(verse),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _confirmDelete(verse.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text("Erreur: $e")),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog([QuranVerseModel? verse]) {
    final textArController = TextEditingController(text: verse?.textAr);
    final textFrController = TextEditingController(text: verse?.textFr);
    final themeController = TextEditingController(text: verse?.theme);
    final contextController = TextEditingController(text: verse?.context);
    final reflectionController = TextEditingController(text: verse?.reflection);
    final surahController = TextEditingController(
      text: verse?.surahNumber.toString() ?? '1',
    );
    final verseNumController = TextEditingController(
      text: verse?.verseNumber.toString() ?? '1',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(verse == null ? "Ajouter un verset" : "Modifier le verset"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textArController,
                decoration: const InputDecoration(labelText: "Texte Arabe"),
                textDirection: TextDirection.rtl,
                maxLines: 3,
              ),
              TextField(
                controller: textFrController,
                decoration: const InputDecoration(labelText: "Texte Français"),
                maxLines: 3,
              ),
              TextField(
                controller: themeController,
                decoration: const InputDecoration(labelText: "Thème"),
              ),
              TextField(
                controller: contextController,
                decoration: const InputDecoration(
                  labelText: "Contexte (Sourate)",
                ),
              ),
              TextField(
                controller: surahController,
                decoration: const InputDecoration(labelText: "N° Sourate"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: verseNumController,
                decoration: const InputDecoration(labelText: "N° Verset"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: reflectionController,
                decoration: const InputDecoration(labelText: "Réflexion"),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.auto_annuler),
          ),
          ElevatedButton(
            onPressed: () {
              final newVerse = QuranVerseModel(
                id: verse?.id ?? const Uuid().v4(),
                surahNumber: int.tryParse(surahController.text) ?? 1,
                verseNumber: int.tryParse(verseNumController.text) ?? 1,
                textAr: textArController.text,
                textFr: textFrController.text,
                theme: themeController.text,
                context: contextController.text,
                reflection: reflectionController.text,
              );
              ref.read(adminNotifierProvider.notifier).saveQuranVerse(newVerse);
              Navigator.pop(context);
            },
            child: Text(context.l10n.auto_enregistrer),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.auto_supprimer),
        content: Text(context.l10n.auto_tesvous_vouloir_supprimer_verset),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.auto_annuler),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(adminNotifierProvider.notifier).deleteQuranVerse(id);
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
}
