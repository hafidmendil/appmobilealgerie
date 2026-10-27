import '../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../../core/theme/tokens/app_spacing.dart';
import '../../../core/theme/tokens/app_radii.dart';
import '../../../core/widgets/sind_components.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../core/localization/l10n_helper.dart';
import '../../../core/data/professional_data.dart';
import '../../../core/data/wilaya_data.dart';
import '../resource_model.dart' as model;
import '../../professional/models/professional_model.dart';
import '../../adaptive_assessment/domain/models/assessment_axis.dart';
import '../../adaptive_assessment/domain/models/quran_verse.dart';
import '../../adaptive_assessment/domain/models/hadith.dart';
import '../../adaptive_assessment/domain/models/psychological_resource.dart';
import '../../content/quran_library.dart';
import '../../content/hadith_library.dart';
import '../../content/resource_library.dart';
import '../../content/hikma_library.dart';
import '../../content/micro_action_library.dart';
import '../../content/video_library.dart';
import '../../adaptive_assessment/domain/models/hikma.dart';
import '../../adaptive_assessment/domain/models/micro_action.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
          isScrollable: true,
          indicatorColor: AppColors.oliveGreen,
          labelColor: AppColors.oliveGreen,
          unselectedLabelColor: AppColors.textMuted,
          tabs: [
            Tab(text: l10n.services_tab),
            Tab(text: l10n.professionals_tab),
            Tab(text: l10n.library_tab),
            Tab(text: l10n.action_calm),
            Tab(text: l10n.recommended_resources),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ServicesList(searchQuery: _searchQuery),
          _ProfessionalsList(searchQuery: _searchQuery),
          _LibraryList(searchQuery: _searchQuery),
          _MicroActionsList(),
          _VideoResourcesList(),
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
                  color: _getTypeColor(res.type).withAlpha(25),
                  borderRadius: AppRadii.mediumRadius,
                ),
                child: Icon(_getIcon(res.type), color: _getTypeColor(res.type)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate(res.nameKey),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _getTypeLabel(context, res.type),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.translate(res.descriptionKey),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _ActionChip(
                icon: LucideIcons.phone,
                label: l10n.call,
                color: AppColors.info,
              ),
              const SizedBox(width: AppSpacing.sm),
              _ActionChip(
                icon: LucideIcons.map_pin,
                label: l10n.locate,
                color: AppColors.oliveGreen,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1, end: 0);
  }

  String _getTypeLabel(BuildContext context, model.ResourceType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case model.ResourceType.emergency:
        return l10n.typeEmergency;
      case model.ResourceType.listening:
        return l10n.typeListening;
      case model.ResourceType.counseling:
        return l10n.typeCounseling;
      case model.ResourceType.selfCare:
        return l10n.typeSelfCare;
    }
  }

  Color _getTypeColor(model.ResourceType type) {
    switch (type) {
      case model.ResourceType.emergency:
        return AppColors.danger;
      case model.ResourceType.listening:
        return AppColors.warning;
      case model.ResourceType.counseling:
        return AppColors.info;
      case model.ResourceType.selfCare:
        return AppColors.success;
    }
  }

  IconData _getIcon(model.ResourceType type) {
    switch (type) {
      case model.ResourceType.emergency:
        return LucideIcons.circle_alert;
      case model.ResourceType.listening:
        return LucideIcons.phone;
      case model.ResourceType.counseling:
        return LucideIcons.user;
      case model.ResourceType.selfCare:
        return LucideIcons.flower_2;
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final filteredProfessionals = mockProfessionals.where((pro) {
      final matchesSearch =
          pro.fullName.toLowerCase().contains(
            widget.searchQuery.toLowerCase(),
          ) ||
          pro.specialty.toLowerCase().contains(
            widget.searchQuery.toLowerCase(),
          );
      final matchesWilaya =
          _selectedWilayaId == null ||
          "w${pro.wilayaId.toString().padLeft(2, '0')}" == _selectedWilayaId;
      return matchesSearch && matchesWilaya;
    }).toList();

    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: l10n.filter_wilaya,
              prefixIcon: const Icon(LucideIcons.map_pin),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            value: _selectedWilayaId,
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.all_wilayas)),
              ...algerianWilayas.map(
                (w) => DropdownMenuItem(
                  value: w.id,
                  child: Text(isRtl ? w.nameAr : w.nameFr),
                ),
              ),
            ],
            onChanged: (val) => setState(() => _selectedWilayaId = val),
          ),
        ),
        Expanded(
          child: filteredProfessionals.isEmpty
              ? Center(child: Text(l10n.no_professionals_found))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  itemCount: filteredProfessionals.length,
                  itemBuilder: (context, index) {
                    final pro = filteredProfessionals[index];
                    final proWilayaId =
                        "w${pro.wilayaId.toString().padLeft(2, '0')}";
                    final wilaya = algerianWilayas.firstWhere(
                      (w) => w.id == proWilayaId,
                    );

                    return SindGlassCard(
                          color: Colors.white,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.softOlive.withAlpha(
                                  51,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.oliveGreen,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            pro.fullName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        if (pro.verificationStatus ==
                                            'VERIFIED') ...[
                                          const SizedBox(width: 4),
                                          const Icon(
                                            LucideIcons.circle_check_big,
                                            color: AppColors.info,
                                            size: 16,
                                          ),
                                        ],
                                      ],
                                    ),
                                    Text(
                                      pro.specialty,
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          LucideIcons.map_pin,
                                          size: 14,
                                          color: AppColors.textMuted,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isRtl ? wilaya.nameAr : wilaya.nameFr,
                                          style: TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  LucideIcons.phone,
                                  color: AppColors.oliveGreen,
                                ),
                                onPressed: pro.phone != null ? () {} : null,
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: (index * 100).ms)
                        .slideX(begin: 0.1, end: 0);
                  },
                ),
        ),
      ],
    );
  }
}

class _LibraryList extends StatefulWidget {
  final String searchQuery;
  const _LibraryList({required this.searchQuery});

  @override
  State<_LibraryList> createState() => _LibraryListState();
}

class _LibraryListState extends State<_LibraryList> {
  String _currentFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final allItems = [
      ...quranLibrary.map((v) => {'type': 'Quran', 'item': v}),
      ...hadithLibrary.map((h) => {'type': 'Hadith', 'item': h}),
      ...hikmaLibrary.map((hk) => {'type': 'Hikma', 'item': hk}),
      ...psychologicalResources.map((r) => {'type': 'Psychology', 'item': r}),
    ];

    final filteredItems = allItems.where((entry) {
      if (_currentFilter != 'All' && entry['type'] != _currentFilter)
        return false;
      return true; // Simplified search for now
    }).toList();

    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final entry = filteredItems[index];
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
              } else if (item is Hikma) {
                title = "Sagesse - ${item.authorFr}";
                icon = LucideIcons.sparkles;
                color = AppColors.deepOlive;
              } else if (item is PsychologicalResource) {
                title = l10n.translate(item.titleKey);
                icon = LucideIcons.brain;
                color = AppColors.skyBlue;
              }

              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  leading: Icon(icon, color: color),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(type, style: const TextStyle(fontSize: 12)),
                  trailing: const Icon(LucideIcons.chevron_right, size: 16),
                  onTap: () => _showItemDetail(context, item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: ['All', 'Quran', 'Hadith', 'Hikma', 'Psychology'].map((f) {
          final isSelected = _currentFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(f),
              selected: isSelected,
              onSelected: (val) => setState(() => _currentFilter = f),
              selectedColor: AppColors.softOlive,
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showItemDetail(BuildContext context, dynamic item) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          item is QuranVerse
              ? "Verset Coranique"
              : (item is Hadith
                    ? "Hadith"
                    : (item is Hikma ? "Sagesse" : "Ressource")),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item is QuranVerse || item is Hadith || item is Hikma) ...[
                Text(
                  item.textAr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepOlive,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  item.textFr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (item is QuranVerse && item.reflection != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.softBlue.withAlpha(51),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          context.l10n.auto_rflexion_clinique_style_textstylefontweight,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.reflection!,
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
            ),
          ),
        ),
      );
    }
}

class _MicroActionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: microActions.length,
      itemBuilder: (context, index) {
        final action = microActions[index];
        final title = isRtl
            ? (action.titleAr ?? action.titleKey)
            : (action.titleFr ?? action.titleKey);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.softOlive,
              child: Icon(Icons.flash_on, color: AppColors.oliveGreen),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${action.estimatedMinutes} min • ${action.type}"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showActionDetail(context, action, isRtl),
          ),
        );
      },
    );
  }

  void _showActionDetail(BuildContext context, MicroAction action, bool isRtl) {
    final title = isRtl ? (action.titleAr ?? "") : (action.titleFr ?? "");
    final desc = isRtl ? (action.descAr ?? "") : (action.descFr ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(desc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.auto_fermer),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.auto_termin),
          ),
        ],
      ),
    );
  }
}

class _VideoResourcesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: supportVideos.length,
      itemBuilder: (context, index) {
        final video = supportVideos[index];
        return SindVideoCard(
          title: isRtl ? video.titleAr : video.title,
          description: isRtl ? video.descriptionAr : video.description,
          thumbnailUrl: video.thumbnailUrl,
          onTap: () async {
            final uri = Uri.parse(video.url);
            if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
                context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.error_occurred)));
            }
          },
        );
      },
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: AppRadii.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
