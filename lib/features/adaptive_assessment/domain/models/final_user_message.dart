class FinalUserMessage {
  final String? mainEmotion;
  final String? freeText;
  final List<String> expressedNeeds; // Extracted themes
  final DateTime timestamp;

  const FinalUserMessage({
    this.mainEmotion,
    this.freeText,
    this.expressedNeeds = const [],
    required this.timestamp,
  });
}
