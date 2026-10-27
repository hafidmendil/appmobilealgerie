import 'package:flutter/material.dart';
import '../../../core/models/wilaya_model.dart';
import '../../../core/localization/l10n_extension.dart';

class WilayaSelector extends StatefulWidget {
  final List<Wilaya> wilayas;
  final Wilaya? initialSelection;
  final Function(Wilaya) onSelected;

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
  late List<Wilaya> _filteredWilayas;
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
              hintText: context.l10n.searchWilayaHint,
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
                  title: Text(
                    context.isRTL ? wilaya.nameAr : wilaya.nameFr,
                    textDirection: context.isRTL
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                  leading: CircleAvatar(child: Text(wilaya.code)),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
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
