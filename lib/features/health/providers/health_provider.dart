import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/features/health/models/health_knowledge_item.dart';
import 'package:uuid/uuid.dart';

final healthKnowledgeProvider =
    StateNotifierProvider<HealthKnowledgeNotifier, List<HealthKnowledgeItem>>((
      ref,
    ) {
      return HealthKnowledgeNotifier();
    });

class HealthKnowledgeNotifier extends StateNotifier<List<HealthKnowledgeItem>> {
  HealthKnowledgeNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    final box = Hive.box<HealthKnowledgeItem>(HiveConfig.healthKnowledgeBox);
    if (box.isEmpty) {
      _loadInitialData();
    } else {
      state = box.values.toList();
    }
  }

  void _loadInitialData() {
    final initial = [
      HealthKnowledgeItem(
        id: 'khayati_2018_nutrition',
        title: 'La nutrition dans la médecine prophétique',
        arabicTitle: 'التغذية في الطب النبوي',
        description:
            'Étude des principes nutritionnels issus du patrimoine islamique.',
        category: HealthCategory.propheticMedicine,
        author: 'Mustapha Khiati',
        source: 'Conseil Supérieur de la Langue Arabe — Algérie',
        publicationYear: 2018,
        evidenceLevel: EvidenceLevel.traditionalSource,
        traditionalContext: 'Basé sur les écrits historiques et les hadiths.',
        scientificSummary: 'Source bibliographique et culturelle.',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sourceStatus: 'VERIFIED',
      ),
      HealthKnowledgeItem(
        id: 'al_bar_ethics',
        title: 'Éthique médicale et médecine islamique',
        arabicTitle: 'الأخلاق الطبية والطب الإسلامي',
        description: 'Recherches sur le rapport entre éthique, foi et santé.',
        category: HealthCategory.islamicNutrition,
        author: 'Mohammed Ali Al-Bar',
        source: 'Études médicales islamiques',
        evidenceLevel: EvidenceLevel.academicResearch,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sourceStatus: 'VERIFIED',
      ),
      HealthKnowledgeItem(
        id: 'doweik_quran_health',
        title: 'Alimentation, Coran et Santé',
        arabicTitle: 'الغذاء والقرآن والصحة',
        description:
            'Analyse des rapports entre les mentions coraniques d\'aliments et la santé.',
        category: HealthCategory.nutrition,
        author: 'Jamil Al-Qudsi al-Doweik',
        evidenceLevel: EvidenceLevel.review,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sourceStatus: 'VERIFIED',
      ),
    ];

    final box = Hive.box<HealthKnowledgeItem>(HiveConfig.healthKnowledgeBox);
    box.addAll(initial);
    state = initial;
  }

  Future<void> addArticle(HealthKnowledgeItem item) async {
    final box = Hive.box<HealthKnowledgeItem>(HiveConfig.healthKnowledgeBox);
    await box.add(item);
    state = [...state, item];
  }

  Future<void> updateArticle(HealthKnowledgeItem item) async {
    final box = Hive.box<HealthKnowledgeItem>(HiveConfig.healthKnowledgeBox);
    final key = box.keys.firstWhere(
      (key) => box.get(key)?.id == item.id,
      orElse: () => item.id,
    );
    await box.put(key, item);
    state = [
      for (final current in state) current.id == item.id ? item : current,
    ];
  }
}

final healthCategoryFilterProvider = StateProvider<HealthCategory?>(
  (ref) => null,
);
final healthSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredHealthItemsProvider = Provider<List<HealthKnowledgeItem>>((ref) {
  final items = ref.watch(healthKnowledgeProvider);
  final category = ref.watch(healthCategoryFilterProvider);
  final query = ref.watch(healthSearchQueryProvider).toLowerCase();

  return items.where((item) {
    final matchesCategory = category == null || item.category == category;
    final matchesSearch =
        item.title.toLowerCase().contains(query) ||
        item.arabicTitle.toLowerCase().contains(query) ||
        item.description.toLowerCase().contains(query);
    return matchesCategory && matchesSearch;
  }).toList();
});
