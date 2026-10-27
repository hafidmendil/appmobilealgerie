import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LocalizationUtils {
  static String formatNumber(num number, BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return NumberFormat.decimalPattern(locale).format(number);
  }

  static String formatPercent(num fraction, BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return NumberFormat.decimalPattern(
          locale,
        ).format((fraction * 100).toInt()) +
        '%';
  }
}
