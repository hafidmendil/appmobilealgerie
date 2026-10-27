import '../../../../generated/l10n/app_localizations.dart';
import '../models/spiritual_content.dart';
import '../models/assessment_axis.dart';
import '../../../content/quran_library.dart';
import '../../../content/hadith_library.dart';
import '../../../content/hikma_library.dart';
import '../models/quran_verse.dart';
import '../models/hadith.dart';
import '../models/hikma.dart';

class SpiritualSupportEngine {
  List<SpiritualContent> getRelevantContent(
    Map<AssessmentAxis, double> needs,
    AppLocalizations l10n,
  ) {
    final List<SpiritualContent> results = [];

    // Convert current axis needs to a list of target axes
    final activeAxes = needs.entries
        .where((e) => e.value > 0.1)
        .map((e) => e.key)
        .toList();

    if (activeAxes.isEmpty) {
      // Default to peace-giving content if no specific needs
      activeAxes.add(AssessmentAxis.stressAnxiety);
    }

    // 1. Search Quran Library
    for (var verse in quranLibrary) {
      if (verse.associatedAxes.any((axis) => activeAxes.contains(axis))) {
        results.add(_mapQuranToSpiritual(verse, l10n));
      }
    }

    // 2. Search Hadith Library
    for (var hadith in hadithLibrary) {
      if (hadith.associatedAxes.any((axis) => activeAxes.contains(axis))) {
        results.add(_mapHadithToSpiritual(hadith, l10n));
      }
    }

    // 3. Search Hikma Library
    for (var hikma in hikmaLibrary) {
      if (hikma.associatedAxes.any((axis) => activeAxes.contains(axis))) {
        results.add(_mapHikmaToSpiritual(hikma, l10n));
      }
    }

    // Shuffle and limit to 10 items for richness but readability
    results.shuffle();
    return results.take(10).toList();
  }

  SpiritualContent _mapQuranToSpiritual(QuranVerse v, AppLocalizations l10n) {
    return SpiritualContent(
      id: v.id,
      category: SpiritualCategory.verse,
      titleAr: l10n.quran_verse_label(v.theme),
      contentAr: v.textAr,
      translationFr: v.textFr,
      source: "القرآن الكريم",
      reference: "سورة ${v.surahNumber}، الآية ${v.verseNumber}",
      verified: true,
    );
  }

  SpiritualContent _mapHadithToSpiritual(Hadith h, AppLocalizations l10n) {
    return SpiritualContent(
      id: h.id,
      category: SpiritualCategory.tranquility,
      titleAr: l10n.hadith_label(h.theme),
      contentAr: h.textAr,
      translationFr: h.textFr,
      source: h.collection,
      reference: "رقم ${h.number}",
      verified: true,
    );
  }

  SpiritualContent _mapHikmaToSpiritual(Hikma hk, AppLocalizations l10n) {
    return SpiritualContent(
      id: hk.id,
      category: SpiritualCategory.patience,
      titleAr: l10n.hikma_label(hk.authorAr ?? 'سلفنا الصالح'),
      contentAr: hk.textAr,
      translationFr: hk.textFr,
      source: "الحكمة والمأثورات",
      reference: hk.authorFr ?? "Sagesse",
      verified: true,
    );
  }
}
