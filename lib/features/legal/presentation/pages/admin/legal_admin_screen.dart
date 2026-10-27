import '../../../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/theme/app_theme.dart';
import '../../../domain/models/legal_models.dart';
import '../../providers/legal_providers.dart';

class LegalAdminScreen extends ConsumerStatefulWidget {
  const LegalAdminScreen({super.key});

  @override
  ConsumerState<LegalAdminScreen> createState() => _LegalAdminScreenState();
}

class _LegalAdminScreenState extends ConsumerState<LegalAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authStateProvider).value;
    final adminEmail = currentUser?.email ?? 'admin@neurosync.local';

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.auto_gestion_base_juridique_admin),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book), text: 'Articles'),
            Tab(icon: Icon(Icons.category), text: 'Catégories'),
            Tab(icon: Icon(Icons.alt_route), text: 'Procédures'),
            Tab(icon: Icon(Icons.source), text: 'Sources'),
            Tab(icon: Icon(Icons.history), text: 'Versions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildArticlesTab(adminEmail),
          _buildCategoriesTab(adminEmail),
          _buildProceduresTab(adminEmail),
          _buildSourcesTab(adminEmail),
          _buildVersionsTab(adminEmail),
        ],
      ),
    );
  }

  // ARTICLES TAB
  Widget _buildArticlesTab(String adminEmail) {
    final repo = ref.watch(legalRepositoryProvider);
    final articles = repo.getArticles(includeObsolete: true);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(context.l10n.auto_textes_juridiques_code_lois),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final art = articles[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    art.reference,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${art.titre}\nStatut: ${art.statutValidation.name} | Validé par: ${art.validatedBy}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _showEditArticleDialog(art, adminEmail),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await repo.deleteArticle(
                            art.id,
                            adminUser: adminEmail,
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // CATEGORIES TAB
  Widget _buildCategoriesTab(String adminEmail) {
    final repo = ref.watch(legalRepositoryProvider);
    final categories = repo.getCategories();

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              cat.titleFr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${cat.titleAr}\nCode: ${cat.code}'),
            trailing: Switch(
              value: cat.isEnabled,
              onChanged: (val) async {
                final updated = LegalCategory(
                  id: cat.id,
                  code: cat.code,
                  titleFr: cat.titleFr,
                  titleAr: cat.titleAr,
                  descriptionFr: cat.descriptionFr,
                  descriptionAr: cat.descriptionAr,
                  isEnabled: val,
                );
                await repo.saveCategory(updated, adminUser: adminEmail);
                setState(() {});
              },
            ),
          ),
        );
      },
    );
  }

  // PROCEDURES TAB
  Widget _buildProceduresTab(String adminEmail) {
    final repo = ref.watch(legalRepositoryProvider);
    final procedures = repo.getProcedures();

    return ListView.builder(
      itemCount: procedures.length,
      itemBuilder: (context, index) {
        final proc = procedures[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              proc.titleFr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${proc.titleAr}\nUrgence: ${proc.isEmergency ? "Oui" : "Non"}',
            ),
          ),
        );
      },
    );
  }

  // SOURCES TAB
  Widget _buildSourcesTab(String adminEmail) {
    final repo = ref.watch(legalRepositoryProvider);
    final sources = repo.getSources();

    return ListView.builder(
      itemCount: sources.length,
      itemBuilder: (context, index) {
        final src = sources[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              src.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Réf: ${src.officialReference}\nJuridiction: ${src.jurisdiction}',
            ),
          ),
        );
      },
    );
  }

  // VERSIONS TAB
  Widget _buildVersionsTab(String adminEmail) {
    final repo = ref.watch(legalRepositoryProvider);
    final versions = repo.getVersions();

    return ListView.builder(
      itemCount: versions.length,
      itemBuilder: (context, index) {
        final v = versions[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              v.versionCode,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${v.changelog}\nDate: ${v.releaseDate.toString().substring(0, 10)}',
            ),
            trailing: Chip(
              label: Text(v.isActive ? 'Active' : 'Inactive'),
              backgroundColor: v.isActive ? Colors.green : Colors.grey,
            ),
          ),
        );
      },
    );
  }

  void _showAddArticleDialog(String adminEmail) {
    final refController = TextEditingController();
    final titleController = TextEditingController();
    final textController = TextEditingController();
    final expController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.auto_ajouter_texte_juridique_valid),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: refController,
                decoration: const InputDecoration(
                  labelText: 'Référence (ex: Article 264 CP)',
                ),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre de l\'article',
                ),
              ),
              TextField(
                controller: textController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Texte officiel'),
              ),
              TextField(
                controller: expController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Explication simplifiée',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.auto_annuler),
          ),
          ElevatedButton(
            onPressed: () async {
              final newArticle = LegalArticle(
                id: 'art_${DateTime.now().millisecondsSinceEpoch}',
                titre: titleController.text,
                titreAr: titleController.text, // TODO: add Arabic field
                reference: refController.text,
                referenceAr: refController.text, // TODO: add Arabic field
                texte: textController.text,
                texteAr: textController.text, // TODO: add Arabic field
                explicationSimplifiee: expController.text,
                explicationSimplifieeAr: expController.text, // TODO: add Arabic field
                categoriesConcernees: ['cat_violence_physique'],
                proceduresAssociees: ['proc_depot_plainte'],
                sourceOfficielle: 'src_code_penal',
                dateValidite: DateTime.now(),
                version: 'v2026.1-DZ-OFFICIAL',
                statutValidation: ValidationStatus.validated,
                validatedBy: adminEmail,
                validatedAt: DateTime.now(),
              );
              await ref
                  .read(legalRepositoryProvider)
                  .saveArticle(newArticle, adminUser: adminEmail);
              if (mounted) {
                Navigator.pop(ctx);
                setState(() {});
              }
            },
            child: Text(context.l10n.auto_enregistrer_avec_audit_log),
          ),
        ],
      ),
    );
  }

  void _showEditArticleDialog(LegalArticle article, String adminEmail) {
    final titleController = TextEditingController(text: article.titre);
    final expController = TextEditingController(
      text: article.explicationSimplifiee,
    );
    ValidationStatus selectedStatus = article.statutValidation;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text('Modifier : ${article.reference}'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Titre'),
                ),
                TextField(
                  controller: expController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Explication simplifiée',
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<ValidationStatus>(
                  value: selectedStatus,
                  items: ValidationStatus.values
                      .map(
                        (s) => DropdownMenuItem(value: s, child: Text(s.name)),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => selectedStatus = val);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Statut de validation',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.l10n.auto_annuler),
            ),
            ElevatedButton(
              onPressed: () async {
                final updated = LegalArticle(
                  id: article.id,
                  titre: titleController.text,
                  titreAr: article.titreAr,
                  reference: article.reference,
                  referenceAr: article.referenceAr,
                  texte: article.texte,
                  texteAr: article.texteAr,
                  explicationSimplifiee: expController.text,
                  explicationSimplifieeAr: article.explicationSimplifieeAr,
                  categoriesConcernees: article.categoriesConcernees,
                  proceduresAssociees: article.proceduresAssociees,
                  sourceOfficielle: article.sourceOfficielle,
                  dateValidite: article.dateValidite,
                  version: article.version,
                  statutValidation: selectedStatus,
                  validatedBy: adminEmail,
                  validatedAt: DateTime.now(),
                );
                await ref
                    .read(legalRepositoryProvider)
                    .saveArticle(updated, adminUser: adminEmail);
                if (mounted) {
                  Navigator.pop(ctx);
                  setState(() {});
                }
              },
              child: Text(context.l10n.auto_sauvegarder),
            ),
          ],
        ),
      ),
    );
  }
}
