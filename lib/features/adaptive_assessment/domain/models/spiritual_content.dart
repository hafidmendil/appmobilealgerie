enum SpiritualCategory {
  dua,
  dhikr,
  verse,
  tranquility,
  patience,
  hope,
  tawakkul,
  mercy
}

class SpiritualContent {
  final String id;
  final SpiritualCategory category;
  final String titleAr;
  final String contentAr;
  final String? translationFr;
  final String source;
  final String reference;
  final bool verified;

  const SpiritualContent({
    required this.id,
    required this.category,
    required this.titleAr,
    required this.contentAr,
    this.translationFr,
    required this.source,
    required this.reference,
    this.verified = false,
  });
}
