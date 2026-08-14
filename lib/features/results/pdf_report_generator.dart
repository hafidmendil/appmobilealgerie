import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:projetmascara/features/engine/decision_engine.dart';
import 'package:projetmascara/features/assessment/assessment_models.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/localization/l10n_helper.dart';
import 'package:projetmascara/features/results/clinical_report.dart';

class PdfReportGenerator {
  static Future<Uint8List> generate({
    required OrientationResult result,
    required Map<String, int> answers,
    required AppLocalizations l10n,
    required String locale,
  }) async {
    final pdf = pw.Document();
    final report = ClinicalReportGenerator.generate(result, answers);
    
    // Load fonts for Unicode support (Arabic)
    final fontData = await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf");
    final arabicFont = pw.Font.ttf(fontData);
    
    final isRtl = locale == 'ar';
    final textDirection = isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
        ),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("NeuroSync 4.0", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text(DateFormat('dd/MM/yyyy').format(DateTime.now())),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              l10n.reportTitle,
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              textDirection: textDirection,
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
            
            pw.Text(
              "${l10n.reportPersonStatus}: ${l10n.translate(report['riskLevel'])}",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              textDirection: textDirection,
            ),
            pw.SizedBox(height: 10),
            
            pw.Text(l10n.explanation, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold), textDirection: textDirection),
            _buildBullet(l10n.translate(report['riskLevel']), textDirection),
            ... (report['psychologicalProfile'] as List<String>).map(
              (p) => _buildBullet(l10n.translate(p), textDirection)
            ),
            
            pw.SizedBox(height: 20),
            pw.Text(l10n.recommendations, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold), textDirection: textDirection),
            ... (report['recommendations'] as List<String>).map(
              (r) => _buildBullet(l10n.translate(r), textDirection)
            ),
            
            pw.Spacer(),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
              ),
              child: pw.Text(
                l10n.reportDisclaimer,
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                textDirection: textDirection,
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildBullet(String text, pw.TextDirection textDirection) {
    return pw.Directionality(
      textDirection: textDirection,
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("• ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Expanded(child: pw.Text(text)),
          ],
        ),
      ),
    );
  }
}

// Helper for formatting date in PDF without requiring full intl in generator if possible
class DateFormat {
  final String pattern;
  DateFormat(this.pattern);
  String format(DateTime date) => "${date.day}/${date.month}/${date.year}";
}
