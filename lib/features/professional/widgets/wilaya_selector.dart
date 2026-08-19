import 'package:flutter/material.dart';
import '../models/wilaya_model.dart';

class WilayaSelector extends StatefulWidget {
  final List<WilayaModel> wilayas;
  final WilayaModel? initialSelection;
  final Function(WilayaModel) onSelected;

  const WilayaSelector({
    super.key,
    required this.wilayas,
    this.initialSelection,
    required this.onSelected,
  });

  @override
  State<WilayaSelector> createState() => _WilayaSelectorState();
}

class _WilayaSelectorState extends State<WilayaSelector> {
  late List<WilayaModel> _filteredWilayas;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredWilayas = widget.wilayas;
    _searchController.addListener(_filterWilayas);
  }

  void _filterWilayas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredWilayas = widget.wilayas.where((w) {
        return w.nameFr.toLowerCase().contains(query) ||
            w.nameAr.contains(query) ||
            w.code.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher une wilaya...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredWilayas.length,
              itemBuilder: (context, index) {
                final wilaya = _filteredWilayas[index];
                final isSelected = widget.initialSelection?.id == wilaya.id;
                return ListTile(
                  title: Text(wilaya.nameFr),
                  subtitle: Text(wilaya.nameAr, textDirection: TextDirection.rtl),
                  leading: CircleAvatar(
                    child: Text(wilaya.code),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                  onTap: () => widget.onSelected(wilaya),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
