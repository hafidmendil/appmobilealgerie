import '../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SituationSelectionPage extends StatelessWidget {
  const SituationSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.auto_neurosync_orientation),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.situationWelcome,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.situationIntroduction,
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                context.l10n.situationQuestion,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Parcours A: Vulnérabilité Psychologique
                      _buildPathCard(
                        context,
                        title: context.l10n.wellbeingPathTitle,
                        subtitle: context.l10n.wellbeingPathDescription,
                        icon: Icons.psychology_outlined,
                        color: Colors.teal,
                        onTap: () {
                          context.push('/assessment');
                        },
                      ),
                      const SizedBox(height: 16),
                      // Parcours B: Victime de Violence
                      _buildPathCard(
                        context,
                        title: context.l10n.protectionPathTitle,
                        subtitle: context.l10n.protectionPathDescription,
                        icon: Icons.shield_outlined,
                        color: Colors.indigo,
                        onTap: () {
                          context.push('/protection/flow');
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPathCard(
                        context,
                        title: context.l10n.selection_conflict_title,
                        subtitle: context.l10n.selection_conflict_subtitle,
                        icon: Icons.psychology_alt_outlined,
                        color: Colors.deepOrange,
                        onTap: () => context.push('/assessment?concern=anger'),
                      ),
                      const SizedBox(height: 16),
                      _buildPathCard(
                        context,
                        title: context.l10n.selection_witness_title,
                        subtitle: context.l10n.selection_witness_subtitle,
                        icon: Icons.groups_outlined,
                        color: Colors.blueGrey,
                        onTap: () => context.push('/orientation/network'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPathCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
