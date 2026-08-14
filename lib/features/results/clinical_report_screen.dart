import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/assessment/assessment_state.dart';
import 'package:projetmascara/features/results/clinical_report.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/localization/l10n_helper.dart';
import 'package:share_plus/share_plus.dart';

import 'package:projetmascara/features/results/pdf_report_generator.dart';
import 'package:printing/printing.dart';
import 'package:projetmascara/core/localization/locale_provider.dart';

class ClinicalReportScreen extends ConsumerWidget {
  const ClinicalReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assessmentProvider);
    final result = state.result;
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);

    if (result == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final report = ClinicalReportGenerator.generate(result, state.answers);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reportTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              try {
                final pdfBytes = await PdfReportGenerator.generate(
                  result: result,
                  answers: state.answers,
                  l10n: l10n,
                  locale: locale.languageCode,
                );
                await Printing.sharePdf(bytes: pdfBytes, filename: 'report.pdf');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.pdfError)),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final text = "NeuroSync 4.0 - ${l10n.reportTitle}\n\n"
                  "${l10n.reportPersonStatus}: ${l10n.translate(report['riskLevel'])}\n"
                  "${l10n.recommendations}:\n"
                  "${(report['recommendations'] as List<String>).map((r) => '- ' + l10n.translate(r)).join('\n')}\n\n"
                  "${l10n.reportDisclaimer}";
              
              Share.share(text);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, l10n.reportPersonStatus),
            _buildReportCard(
              context,
              child: Column(
                children: [
                  Text(
                    l10n.translate(report['riskLevel']),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const Divider(height: 32),
                  ... (report['psychologicalProfile'] as List<String>).map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.psychology, size: 20, color: Colors.blueGrey),
                        const SizedBox(width: 12),
                        Expanded(child: Text(l10n.translate(p), style: const TextStyle(fontSize: 15))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle(context, l10n.recommendations),
            ... (report['recommendations'] as List<String>).map((r) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: Colors.teal[50],
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.teal),
                title: Text(l10n.translate(r)),
              ),
            )),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.reportDisclaimer,
                      style: const TextStyle(fontSize: 13, color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
