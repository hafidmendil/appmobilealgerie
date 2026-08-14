import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../../core/theme/tokens/app_spacing.dart';
import '../../../core/theme/tokens/app_radii.dart';
import '../../../core/widgets/sind_components.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../core/localization/l10n_helper.dart';
import '../../../core/data/professional_data.dart';
import '../../../core/data/wilaya_data.dart';
import '../professional_model.dart' as pro_model;
import '../resource_model.dart' as model;
import '../../assessment/assessment_models.dart';
import '../../content/quran_library.dart';
import '../../content/hadith_library.dart';
import '../../content/resource_library.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        title: Text(l10n.resources),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.oliveGreen,
          labelColor: AppColors.oliveGreen,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(text: "Services"),
            Tab(text: "Professionnels"),
            Tab(text: "Bibliothèque"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ServicesList(searchQuery: _searchQuery),
          _ProfessionalsList(searchQuery: _searchQuery),
          _LibraryList(searchQuery: _searchQuery),
        ],
      ),
    );
  }
}

class _ServicesList extends StatelessWidget {
  final String searchQuery;
  const _ServicesList({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filteredResources = model.mockResources.where((res) {
      final name = l10n.translate(res.nameKey).toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: filteredResources.length,
      itemBuilder: (context, index) {
        final res = filteredResources[index];
        return _ResourceCard(res: res, index: index);
      },
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final model.Resource res;
  final int index;

  const _ResourceCard({required this.res, required this.index});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SindGlassCard(
      color: Colors.white,
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: _getTypeColor(res.type).withOpacity(0.1),
                  borderRadius: AppRadii.mediumRadius,
                ),
                child: Icon(_getIcon(res.type), color: _getTypeColor(res.type)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.translate(res.nameKey), style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(_getTypeLabel(context, res.type), style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.translate(res.descriptionKey), style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _ActionChip(icon: LucideIcons.phone, label: l10n.call, color: AppColors.info),
              const SizedBox(width: AppSpacing.sm),
              _ActionChip(icon: LucideIcons.map_pin, label: l10n.locate, color: AppColors.oliveGreen),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1, end: 0);
  }

  String _getTypeLabel(BuildContext context, model.ResourceType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case model.ResourceType.emergency: return l10n.typeEmergency;
      case model.ResourceType.listening: return l10n.typeListening;
      case model.ResourceType.counseling: return l10n.typeCounseling;
      case model.ResourceType.selfCare: return l10n.typeSelfCare;
    }
  }

  Color _getTypeColor(model.ResourceType type) {
    switch (type) {
      case model.ResourceType.emergency: return AppColors.danger;
      case model.ResourceType.listening: return AppColors.warning;
      case model.ResourceType.counseling: return AppColors.info;
      case model.ResourceType.selfCare: return AppColors.success;
    }
  }

  IconData _getIcon(model.ResourceType type) {
    switch (type) {
      case model.ResourceType.emergency: return LucideIcons.circle_alert;
      case model.ResourceType.listening: return LucideIcons.phone;
      case model.ResourceType.counseling: return LucideIcons.user;
      case model.ResourceType.selfCare: return LucideIcons.flower_2;
    }
  }
}

class _ProfessionalsList extends StatefulWidget {
  final String searchQuery;
  const _ProfessionalsList({required this.searchQuery});

  @override
  State<_ProfessionalsList> createState() => _ProfessionalsListState();
}

class _ProfessionalsListState extends State<_ProfessionalsList> {
  String? _selectedWilayaId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final filteredProfessionals = mockProfessionals.where((pro) {
      final matchesSearch = pro.name.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
          pro.specialty.toLowerCase().contains(widget.searchQuery.toLowerCase());
      final matchesWilaya = _selectedWilayaId == null || pro.wilayaId == _selectedWilayaId;
      return matchesSearch && matchesWilaya;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: "Filtrer par Wilaya",
              prefixIcon: const Icon(LucideIcons.map_pin),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            value: _selectedWilayaId,
            items: [
              const DropdownMenuItem(value: null, child: Text("Toutes les Wilayas")),
              ...algerianWilayas.map((w) => DropdownMenuItem(
                value: w.id,
                child: Text(isRtl ? w.nameAr : w.nameFr),
              )),
            ],
            onChanged: (val) => setState(() => _selectedWilayaId = val),
          ),
        ),
        Expanded(
          child: filteredProfessionals.isEmpty
              ? Center(child: Text("Aucun professionnel trouvé."))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: filteredProfessionals.length,
                  itemBuilder: (context, index) {
                    final pro = filteredProfessionals[index];
                    final wilaya = algerianWilayas.firstWhere((w) => w.id == pro.wilayaId);
                    
                    return SindGlassCard(
                      color: Colors.white,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.softOlive.withOpacity(0.2),
                            child: Icon(_getProIcon(pro.type), color: AppColors.oliveGreen, size: 32),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(child: Text(pro.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                    if (pro.isVerified) ...[
                                      const SizedBox(width: 4),
                                      const Icon(LucideIcons.circle_check_big, color: AppColors.info, size: 16),
                                    ],
                                  ],
                                ),
                                Text(pro.specialty, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(LucideIcons.map_pin, size: 14, color: AppColors.textMuted),
                                    const SizedBox(width: 4),
                                    Text(isRtl ? wilaya.nameAr : wilaya.nameFr, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.phone, color: AppColors.oliveGreen),
                            onPressed: pro.phone != null ? () {} : null,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1, end: 0);
                  },
                ),
        ),
      ],
    );
  }

  IconData _getProIcon(pro_model.ProfessionalType type) {
    switch (type) {
      case pro_model.ProfessionalType.psychologist: return LucideIcons.brain;
      case pro_model.ProfessionalType.doctor: return LucideIcons.stethoscope;
      case pro_model.ProfessionalType.neurologist: return LucideIcons.activity;
      case pro_model.ProfessionalType.socialWorker: return LucideIcons.heart_handshake;
      case pro_model.ProfessionalType.educator: return LucideIcons.graduation_cap;
      case pro_model.ProfessionalType.counselor: return LucideIcons.message_circle;
    }
  }
}

class _LibraryList extends StatelessWidget {
  final String searchQuery;
  const _LibraryList({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final allLibraryItems = [
      ...quranLibrary.map((v) => {'type': 'Quran', 'item': v}),
      ...hadithLibrary.map((h) => {'type': 'Hadith', 'item': h}),
      ...psychologicalResources.map((r) => {'type': 'Psychology', 'item': r}),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: allLibraryItems.length,
      itemBuilder: (context, index) {
        final entry = allLibraryItems[index];
        final type = entry['type'] as String;
        final item = entry['item'];

        String title = "";
        IconData icon = LucideIcons.book;
        Color color = AppColors.oliveGreen;

        if (item is QuranVerse) {
          title = "Coran ${item.surahNumber}:${item.verseNumber}";
          icon = LucideIcons.book_open;
          color = AppColors.softOlive;
        } else if (item is Hadith) {
          title = "Hadith - ${item.theme}";
          icon = LucideIcons.message_circle;
          color = AppColors.oliveGreen;
        } else if (item is PsychologicalResource) {
          title = l10n.translate(item.titleKey);
          icon = LucideIcons.brain;
          color = AppColors.skyBlue;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: Icon(icon, color: color),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(type, style: const TextStyle(fontSize: 12)),
            trailing: const Icon(LucideIcons.chevron_right, size: 16),
            onTap: () => _showItemDetail(context, item),
          ),
        );
      },
    );
  }

  void _showItemDetail(BuildContext context, dynamic item) {
    // Show a simple dialog with the content
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item is QuranVerse ? "Verset Coranique" : (item is Hadith ? "Hadith" : "Ressource")),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item is QuranVerse || item is Hadith) ...[
                Text(
                  item.textAr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.oliveGreen),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(item.textFr, textAlign: TextAlign.center, style: const TextStyle(fontStyle: FontStyle.italic)),
              ] else if (item is PsychologicalResource) ...[
                Text(AppLocalizations.of(context)!.translate(item.contentKey)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fermer")),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadii.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
