import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/wilaya_model.dart';
import '../models/professional_model.dart';
import '../models/center_model.dart';
import '../widgets/wilaya_selector.dart';
import '../professional_provider.dart';

import 'package:projetmascara/generated/l10n/app_localizations.dart';

class ProfessionalSearchPage extends ConsumerStatefulWidget {
  const ProfessionalSearchPage({super.key});

  @override
  ConsumerState<ProfessionalSearchPage> createState() =>
      _ProfessionalSearchPageState();
}

class _ProfessionalSearchPageState
    extends ConsumerState<ProfessionalSearchPage> {
  Wilaya? _selectedWilaya;
  bool _isSearchingProfessionals = true;
  String _sortCriteria = 'name'; // 'name' or 'specialty'

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(professionalProvider).loadWilayas());
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(professionalProvider);
    final l10n = AppLocalizations.of(context)!;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.professional_orientation),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortDialog(l10n),
            tooltip: l10n.sort,
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () => _showWilayaSelector(provider.wilayas, l10n),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTypeToggle(l10n),
          if (_selectedWilaya == null)
            _buildInitialState(provider.wilayas, l10n)
          else if (provider.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(child: _buildResultsList(provider, l10n, isRtl)),
        ],
      ),
    );
  }

  void _showSortDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sort_by),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.sort_name),
              leading: Radio<String>(
                value: 'name',
                groupValue: _sortCriteria,
                onChanged: (val) {
                  setState(() => _sortCriteria = val!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text(l10n.sort_specialty),
              leading: Radio<String>(
                value: 'specialty',
                groupValue: _sortCriteria,
                onChanged: (val) {
                  setState(() => _sortCriteria = val!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeToggle(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SegmentedButton<bool>(
        segments: [
          ButtonSegment(
            value: true,
            label: Text(l10n.professionals),
            icon: const Icon(Icons.person),
          ),
          ButtonSegment(
            value: false,
            label: Text(l10n.centers),
            icon: const Icon(Icons.business),
          ),
        ],
        selected: {_isSearchingProfessionals},
        onSelectionChanged: (value) {
          setState(() => _isSearchingProfessionals = value.first);
        },
      ),
    );
  }

  Widget _buildInitialState(List<Wilaya> wilayas, AppLocalizations l10n) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey.withAlpha(102)),
            const SizedBox(height: 24),
            Text(
              l10n.search_resources_wilaya,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showWilayaSelector(wilayas, l10n),
              icon: const Icon(Icons.map),
              label: Text(l10n.choose_wilaya),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWilayaSelector(List<Wilaya> wilayas, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => WilayaSelector(
          wilayas: wilayas,
          initialSelection: _selectedWilaya,
          onSelected: (wilaya) {
            setState(() => _selectedWilaya = wilaya);
            ref
                .read(professionalProvider)
                .search(wilayaId: int.parse(wilaya.code));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildResultsList(
    ProfessionalProvider provider,
    AppLocalizations l10n,
    bool isRtl,
  ) {
    if (_isSearchingProfessionals) {
      if (provider.professionals.isEmpty) return _buildNoResults(l10n);

      final sortedList = List<ProfessionalModel>.from(provider.professionals);
      if (_sortCriteria == 'name') {
        sortedList.sort((a, b) => a.fullName.compareTo(b.fullName));
      } else {
        sortedList.sort((a, b) => a.specialty.compareTo(b.specialty));
      }

      return ListView.builder(
        itemCount: sortedList.length,
        itemBuilder: (context, index) =>
            _buildProfessionalCard(sortedList[index], isRtl),
      );
    } else {
      if (provider.centers.isEmpty) return _buildNoResults(l10n);
      return ListView.builder(
        itemCount: provider.centers.length,
        itemBuilder: (context, index) =>
            _buildCenterCard(provider.centers[index], isRtl),
      );
    }
  }

  Widget _buildNoResults(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            l10n.no_results_wilaya(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? (_selectedWilaya?.nameAr ?? '')
                  : (_selectedWilaya?.nameFr ?? ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalCard(ProfessionalModel prof, bool isRtl) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue.withAlpha(25),
          child: const Icon(Icons.person, color: Colors.blue, size: 32),
        ),
        title: Text(
          prof.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              prof.specialty,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(prof.address, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prof.whatsapp != null)
              IconButton(
                icon: const Icon(Icons.chat, color: Colors.green, size: 20),
                onPressed: () {
                  // Direct WhatsApp logic or navigation
                  context.push('/professional-profile', extra: prof);
                },
              ),
            Icon(isRtl ? Icons.chevron_left : Icons.chevron_right),
          ],
        ),
        onTap: () => context.push('/professional-profile', extra: prof),
      ),
    );
  }

  Widget _buildCenterCard(CenterModel center, bool isRtl) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.green.withAlpha(25),
          child: const Icon(Icons.business, color: Colors.green, size: 32),
        ),
        title: Text(
          center.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: isRtl
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(center.address),
            if (center.services != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Wrap(
                  spacing: 4,
                  children: center.services!
                      .take(2)
                      .map(
                        (s) => Chip(
                          label: Text(s, style: const TextStyle(fontSize: 10)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
        trailing: Icon(isRtl ? Icons.chevron_left : Icons.chevron_right),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(center.name),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(center.description ?? ''),
                    const SizedBox(height: 12),
                    Text(center.address),
                    if (center.services != null) ...[
                      const SizedBox(height: 12),
                      ...center.services!.map(Text.new),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.close),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
