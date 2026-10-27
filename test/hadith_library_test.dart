import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/content/hadith_library.dart';

void main() {
  test('hadith library should have unique IDs and no disqualified entries', () {
    final ids = hadithLibrary.map((hadith) => hadith.id).toList();

    expect(ids.length, equals(ids.toSet().length));
    expect(hadithLibrary.any((hadith) => hadith.id == 'h_bukhari_1'), isTrue);
    expect(hadithLibrary.any((hadith) => hadith.id == 'h_muslim_2956'), isTrue);
    expect(hadithLibrary.any((hadith) => hadith.id == 'h_muslim_54a'), isTrue);
    expect(
      hadithLibrary.any((hadith) => hadith.id == 'h_muslim_2564b'),
      isTrue,
    );
    expect(
      hadithLibrary.where((hadith) => hadith.id == 'h_tirmidhi_1987').isEmpty,
      isTrue,
    );
    expect(
      hadithLibrary.where((hadith) => hadith.id == 'h_bukhari_6122').isEmpty,
      isTrue,
    );
    expect(
      hadithLibrary.where((hadith) => hadith.id == 'h_muslim_2581').isEmpty,
      isTrue,
    );
  });
}
