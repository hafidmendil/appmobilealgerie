import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../providers/directory_providers.dart';
import '../models/directory_models.dart';

class DirectorySearchPage extends ConsumerWidget {
  const DirectorySearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final selectedWilaya = ref.watch(selectedWilayaProvider);
    final searchType = ref.watch(searchTypeProvider);

    final searchResults = ref.watch(searchResultsProvider(SearchParams(
      query: query,
      wilayaId: selectedWilaya?.id,
      type: searchType,
    )));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trouver un professionnel'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom, spécialité...',
                    prefixIcon: const Icon(LucideIcons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: selectedWilaya?.nameFr ?? 'Toutes les wilayas',
                        icon: LucideIcons.map_pin,
                        onTap: () => _showWilayaPicker(context, ref),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: _getTypeLabel(searchType),
                        icon: LucideIcons.filter,
                        onTap: () => _showTypePicker(context, ref),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: searchResults.when(
        data: (results) {
          if (results.isEmpty) {
            return const Center(
              child: Text('Aucun résultat trouvé.'),
            );
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return _SearchResultCard(result: result);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  String _getTypeLabel(String? type) {
    switch (type) {
      case 'professional': return 'Professionnels';
      case 'cabinet': return 'Cabinets privés';
      case 'public': return 'Structures publiques';
      default: return 'Tous les types';
    }
  }

  void _showWilayaPicker(BuildContext context, WidgetRef ref) {
    final wilayas = ref.read(wilayasProvider);
    wilayas.whenData((list) {
      showModalBottomSheet(
        context: context,
        builder: (context) => ListView.builder(
          itemCount: list.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                title: const Text('Toutes les wilayas'),
                onTap: () {
                  ref.read(selectedWilayaProvider.notifier).state = null;
                  Navigator.pop(context);
                },
              );
            }
            final wilaya = list[index - 1];
            return ListTile(
              title: Text('${wilaya.code} - ${wilaya.nameFr}'),
              onTap: () {
                ref.read(selectedWilayaProvider.notifier).state = wilaya;
                Navigator.pop(context);
              },
            );
          },
        ),
      );
    });
  }

  void _showTypePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Tous les types'),
            onTap: () {
              ref.read(searchTypeProvider.notifier).state = null;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Professionnels'),
            onTap: () {
              ref.read(searchTypeProvider.notifier).state = 'professional';
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Cabinets privés'),
            onTap: () {
              ref.read(searchTypeProvider.notifier).state = 'cabinet';
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Structures publiques'),
            onTap: () {
              ref.read(searchTypeProvider.notifier).state = 'public';
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onTap: onTap,
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final SearchResult result;

  const _SearchResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(result.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.subType ?? ''),
            Row(
              children: [
                const Icon(LucideIcons.map_pin, size: 14),
                const SizedBox(width: 4),
                Text('${result.wilayaName} - ${result.address ?? ""}'),
              ],
            ),
          ],
        ),
        trailing: _VerificationBadge(status: result.verificationStatus),
        onTap: () {
          // Navigate to detail page
        },
      ),
    );
  }
}

class _VerificationBadge extends StatelessWidget {
  final String status;

  const _VerificationBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'VERIFIE':
        color = Colors.green;
        label = 'Vérifié';
        break;
      case 'A_VERIFIER':
        color = Colors.orange;
        label = 'À vérifier';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
