import '../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/models/admin/content_models.dart';
import 'package:projetmascara/features/admin/admin_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class HadithAdminScreen extends ConsumerStatefulWidget {
  const HadithAdminScreen({super.key});

  @override
  ConsumerState<HadithAdminScreen> createState() => _HadithAdminScreenState();
}

class _HadithAdminScreenState extends ConsumerState<HadithAdminScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hadithsAsync = ref.watch(adminHadithProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.auto_hadiths_hikam),
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
            child: hadithsAsync.when(
              data: (hadiths) {
                final filteredHadiths = hadiths.where((h) {
                  final query = _searchQuery.toLowerCase();
                  return h.textAr.contains(query) ||
                      h.textFr.toLowerCase().contains(query) ||
                      h.theme.toLowerCase().contains(query);
                }).toList();

                if (filteredHadiths.isEmpty)
                  return Center(child: Text(context.l10n.auto_aucun_hadith_trouv));

                return ListView.builder(
                  itemCount: filteredHadiths.length,
                  itemBuilder: (context, index) {
                    final hadith = filteredHadiths[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          hadith.textAr,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "${hadith.source ?? hadith.collection} - ${hadith.theme}",
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Français: ${hadith.textFr}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () => _showEditDialog(hadith),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          _confirmDelete(hadith.id),
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

  void _showEditDialog([HadithModel? hadith]) {
    final textArController = TextEditingController(text: hadith?.textAr);
    final textFrController = TextEditingController(text: hadith?.textFr);
    final themeController = TextEditingController(text: hadith?.theme);
    final sourceController = TextEditingController(text: hadith?.source);
    final collectionController = TextEditingController(
      text: hadith?.collection,
    );
    final numberController = TextEditingController(text: hadith?.number);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          hadith == null ? "Ajouter un hadith" : "Modifier le hadith",
        ),
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
                controller: sourceController,
                decoration: const InputDecoration(labelText: "Source"),
              ),
              TextField(
                controller: collectionController,
                decoration: const InputDecoration(labelText: "Collection"),
              ),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: "Numéro"),
                keyboardType: TextInputType.number,
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
              final newHadith = HadithModel(
                id: hadith?.id ?? const Uuid().v4(),
                collection: collectionController.text,
                number: numberController.text,
                textAr: textArController.text,
                textFr: textFrController.text,
                theme: themeController.text,
                source: sourceController.text,
              );
              ref.read(adminNotifierProvider.notifier).saveHadith(newHadith);
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
        content: Text(context.l10n.auto_tesvous_vouloir_supprimer_hadith),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.auto_annuler),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(adminNotifierProvider.notifier).deleteHadith(id);
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
