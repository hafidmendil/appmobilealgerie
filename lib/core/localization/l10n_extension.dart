import 'package:flutter/material.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

/// Extension to easily access localizations in any widget.
/// Example: `context.l10n.helloWorld` instead of `AppLocalizations.of(context)!.helloWorld`
extension SindL10nExtension on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      throw Exception(
        'AppLocalizations not found in context. Make sure you have added AppLocalizations.delegate to your MaterialApp localizationsDelegates.',
      );
    }
    return localizations;
  }

  /// Returns true if the current locale is Arabic (Right-To-Left)
  bool get isRTL {
    return Directionality.of(this) == TextDirection.rtl;
  }
}
