import '../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../assessment/assessment_record.dart';
import '../../../core/theme/tokens/app_colors.dart';
import 'package:intl/intl.dart';

class PatientTrendChart extends StatelessWidget {
  final List<AssessmentRecord> records;

  const PatientTrendChart({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Center(child: Text(context.l10n.auto_pas_assez_donnes_pour));
    }

    final sortedRecords = List<AssessmentRecord>.from(records)
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Évolution Clinique (Dépression & Anxiété)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < 0 ||
                          value.toInt() >= sortedRecords.length) {
                        return const SizedBox.shrink();
                      }
                      final date = sortedRecords[value.toInt()].createdAt;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('dd/MM').format(date),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Depression Line
                LineChartBarData(
                  spots: sortedRecords.asMap().entries.map((e) {
                    final depressionScore = _calculateScore(e.value, ['dep']);
                    return FlSpot(e.key.toDouble(), depressionScore.toDouble());
                  }).toList(),
                  isCurved: true,
                  color: AppColors.danger,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                ),
                // Anxiety Line
                LineChartBarData(
                  spots: sortedRecords.asMap().entries.map((e) {
                    final anxietyScore = _calculateScore(e.value, [
                      'anx',
                      'gad',
                    ]);
                    return FlSpot(e.key.toDouble(), anxietyScore.toDouble());
                  }).toList(),
                  isCurved: true,
                  color: AppColors.info,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend(AppColors.danger, "Dépression"),
            const SizedBox(width: 20),
            _buildLegend(AppColors.info, "Anxiété"),
          ],
        ),
      ],
    );
  }

  double _calculateScore(AssessmentRecord record, List<String> prefixes) {
    int total = 0;
    int count = 0;
    record.answers.forEach((key, value) {
      if (prefixes.any((p) => key.startsWith(p))) {
        total += value;
        count++;
      }
    });
    return count > 0
        ? (total / count) * 10
        : 0.0; // Normalized to 0-30 scale aprox
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
