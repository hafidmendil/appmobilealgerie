import 'package:flutter/material.dart';
import '../models/professional_model.dart';
import '../models/center_model.dart';
import '../models/wilaya_model.dart';
import '../widgets/wilaya_selector.dart';
import 'professional_profile_page.dart';

class ProfessionalSearchPage extends StatefulWidget {
  const ProfessionalSearchPage({super.key});

  @override
  State<ProfessionalSearchPage> createState() => _ProfessionalSearchPageState();
}

class _ProfessionalSearchPageState extends State<ProfessionalSearchPage> {
  WilayaModel? _selectedWilaya;
  bool _isSearchingProfessionals = true; // Toggle between Professionals and Centers
  
  // Mock data for demonstration - in real implementation, this comes from a Provider
  final List<WilayaModel> _mockWilayas = [
    const WilayaModel(id: 29, code: '29', nameFr: 'Mascara', nameAr: 'معسكر', nameEn: 'Mascara'),
    const WilayaModel(id: 16, code: '16', nameFr: 'Alger', nameAr: 'الجزائر', nameEn: 'Algiers'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orientation Professionnelle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: _showWilayaSelector,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTypeToggle(),
          if (_selectedWilaya == null)
            _buildInitialState()
          else
            Expanded(child: _buildResultsList()),
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SegmentedButton<bool>(
        segments: const [
          ButtonSegment(value: true, label: Text('Professionnels'), icon: Icon(Icons.person)),
          ButtonSegment(value: false, label: Text('Centres'), icon: Icon(Icons.business)),
        ],
        selected: {_isSearchingProfessionals},
        onSelectionChanged: (value) {
          setState(() => _isSearchingProfessionals = value.first);
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainManager.center,
          children: [
            const Icon(Icons.search, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Sélectionnez votre wilaya pour commencer'),
            ElevatedButton(
              onPressed: _showWilayaSelector,
              child: const Text('Choisir une wilaya'),
            ),
          ],
        ),
      ),
    );
  }

  void _showWilayaSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => WilayaSelector(
          wilayas: _mockWilayas,
          initialSelection: _selectedWilaya,
          onSelected: (wilaya) {
            setState(() => _selectedWilaya = wilaya);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    // This would fetch data via a Provider based on _selectedWilaya and _isSearchingProfessionals
    return ListView.builder(
      itemCount: 5, // Mock count
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(_isSearchingProfessionals ? 'Dr. Ahmed Benali' : 'Centre de Santé Mascara'),
            subtitle: Text('${_selectedWilaya!.nameFr} - ${_isSearchingProfessionals ? 'Psychologue' : 'Services divers'}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to profile
            },
          ),
        );
      },
    );
  }
}
