import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../adaptive_assessment/domain/models/assessment_axis.dart';

class WeeklyNeedsChart extends StatelessWidget {
  final Map<AssessmentAxis, double> data;

  const WeeklyNeedsChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1.0,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final axis = data.keys.elementAt(value.toInt() % data.length);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _getShortName(axis),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: data.entries.indexed.map((entry) {
            final index = entry.$1;
            final val = entry.$2.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: val,
                  color: _getColor(val),
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getShortName(AssessmentAxis axis) {
    switch (axis) {
      case AssessmentAxis.emotions:
        return "Emot";
      case AssessmentAxis.stressAnxiety:
        return "Strs";
      case AssessmentAxis.sleepEnergy:
        return "Som";
      case AssessmentAxis.productivity:
        return "Prod";
      case AssessmentAxis.socialSupport:
        return "Soc";
      default:
        return axis.name.substring(0, 3);
    }
  }

  Color _getColor(double val) {
    if (val > 0.7) return Colors.redAccent.withOpacity(0.7);
    if (val > 0.4) return Colors.orangeAccent.withOpacity(0.7);
    return AppColors.oliveGreen.withOpacity(0.7);
  }
}
