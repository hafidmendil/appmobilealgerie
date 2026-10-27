import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/data/wilaya_data.dart';
import 'package:projetmascara/core/theme/tokens/app_spacing.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class WilayaSelectionScreen extends ConsumerStatefulWidget {
  const WilayaSelectionScreen({super.key});

  @override
  ConsumerState<WilayaSelectionScreen> createState() =>
      _WilayaSelectionScreenState();
}

class _WilayaSelectionScreenState extends ConsumerState<WilayaSelectionScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final filteredWilayas = algerianWilayas.where((w) {
      final query = _searchQuery.toLowerCase();
      return w.nameFr.toLowerCase().contains(query) || w.nameAr.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.select_wilaya_title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchService,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWilayas.length,
              itemBuilder: (context, index) {
                final wilaya = filteredWilayas[index];
                final isSelected = user?.wilayaId == wilaya.id;

                return ListTile(
                  title: Text(isRtl ? wilaya.nameAr : wilaya.nameFr),
                  subtitle: Text(isRtl ? wilaya.nameFr : wilaya.nameAr),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () async {
                    if (user != null) {
                      final updatedUser = user.copyWith(wilayaId: wilaya.id);
                      await ref
                          .read(authRepositoryProvider)
                          .updateUser(updatedUser);
                      if (mounted) Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
