import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import 'package:projetmascara/core/theme/tokens/app_spacing.dart';
import 'package:projetmascara/core/theme/tokens/app_radii.dart';
import 'package:projetmascara/features/health/models/health_knowledge_item.dart';
import 'package:projetmascara/features/health/providers/health_provider.dart';
import 'package:projetmascara/features/health/widgets/health_components.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class HealthKnowledgePage extends ConsumerWidget {
  const HealthKnowledgePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final filteredItems = ref.watch(filteredHealthItemsProvider);
    final selectedCategory = ref.watch(healthCategoryFilterProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              title: Text(
                l10n.health_nutrition_title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.deepOlive, AppColors.oliveGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  TextField(
                    onChanged: (val) =>
                        ref.read(healthSearchQueryProvider.notifier).state =
                            val,
                    decoration: InputDecoration(
                      hintText: l10n.healthSearchHint,
                      prefixIcon: const Icon(LucideIcons.search),
                      border: OutlineInputBorder(
                        borderRadius: AppRadii.mediumRadius,
                      ),
                    ),
                  ).animate().fadeIn(),

                  const SizedBox(height: AppSpacing.xl),

                  // Categories Grid
                  Text(l10n.categoriesLabel, style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: HealthCategory.values.map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.md),
                          child: SizedBox(
                            width: 140,
                            child: HealthCategoryCard(
                              category: cat,
                              title: _getCategoryName(cat, l10n),
                              icon: _getCategoryIcon(cat),
                              onTap: () =>
                                  ref
                                      .read(
                                        healthCategoryFilterProvider.notifier,
                                      )
                                      .state = selectedCategory == cat
                                  ? null
                                  : cat,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  if (selectedCategory != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Text(
                          l10n.filteredBy(
                            _getCategoryName(selectedCategory, l10n),
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.oliveGreen,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.x, size: 16),
                          onPressed: () =>
                              ref
                                      .read(
                                        healthCategoryFilterProvider.notifier,
                                      )
                                      .state =
                                  null,
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xl),

                  // Articles List
                  Text(
                    l10n.latestPublications,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = filteredItems[index];
                return HealthKnowledgeCard(
                  item: item,
                  onTap: () => context.push('/health/article/${item.id}'),
                ).animate().fadeIn(delay: (index * 100).ms).slideX();
              }, childCount: filteredItems.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
        ],
      ),
    );
  }

  String _getCategoryName(HealthCategory category, AppLocalizations l10n) {
    switch (category) {
      case HealthCategory.nutrition:
        return l10n.cat_nutrition;
      case HealthCategory.lifestyle:
        return l10n.cat_lifestyle;
      case HealthCategory.islamicNutrition:
        return l10n.cat_islamic_nutrition;
      case HealthCategory.propheticMedicine:
        return l10n.cat_prophetic_medicine;
      case HealthCategory.traditionalPlants:
        return l10n.cat_traditional_plants;
      case HealthCategory.physicalWellbeing:
        return l10n.cat_physical_wellbeing;
      case HealthCategory.psychologicalWellbeing:
        return l10n.cat_psychological_wellbeing;
      case HealthCategory.sleepHabits:
        return l10n.cat_sleep_habits;
      case HealthCategory.prevention:
        return l10n.cat_prevention;
      case HealthCategory.scientificResearch:
        return l10n.cat_scientific_research;
      case HealthCategory.sources:
        return l10n.cat_sources;
    }
  }

  IconData _getCategoryIcon(HealthCategory category) {
    switch (category) {
      case HealthCategory.nutrition:
        return LucideIcons.apple;
      case HealthCategory.lifestyle:
        return LucideIcons.sun;
      case HealthCategory.islamicNutrition:
        return LucideIcons.book_open;
      case HealthCategory.propheticMedicine:
        return LucideIcons.heart;
      case HealthCategory.traditionalPlants:
        return LucideIcons.leaf;
      case HealthCategory.physicalWellbeing:
        return LucideIcons.activity;
      case HealthCategory.psychologicalWellbeing:
        return LucideIcons.brain;
      case HealthCategory.sleepHabits:
        return LucideIcons.moon;
      case HealthCategory.prevention:
        return LucideIcons.shield_check;
      case HealthCategory.scientificResearch:
        return LucideIcons.microscope;
      case HealthCategory.sources:
        return LucideIcons.library;
    }
  }
}
