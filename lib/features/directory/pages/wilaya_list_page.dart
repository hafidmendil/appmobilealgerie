import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../providers/directory_providers.dart';
import '../models/directory_models.dart';
import 'directory_search_page.dart';

class WilayaListPage extends ConsumerWidget {
  const WilayaListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wilayasAsync = ref.watch(wilayasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Santé mentale par Wilaya'),
      ),
      body: wilayasAsync.when(
        data: (wilayas) => ListView.builder(
          itemCount: wilayas.length,
          itemBuilder: (context, index) {
            final wilaya = wilayas[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    wilaya.code,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(wilaya.nameFr, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Row(
                  children: [
                    _StatBadge(icon: LucideIcons.user, count: wilaya.profCount, label: 'Profs'),
                    const SizedBox(width: 8),
                    _StatBadge(icon: LucideIcons.hospital, count: wilaya.publicCount, label: 'Public'),
                  ],
                ),
                trailing: const Icon(LucideIcons.chevron_right),
                onTap: () {
                  ref.read(selectedWilayaProvider.notifier).state = wilaya;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DirectorySearchPage()),
                  );
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const _StatBadge({required this.icon, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 2),
        Text(
          '$count $label',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
