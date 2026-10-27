import 'package:hive/hive.dart';
import '../../models/admin/content_models.dart';
import '../../data/hive_config.dart';

abstract class ContentRepository {
  Future<List<QuranVerseModel>> getQuranVerses();
  Future<void> saveQuranVerse(QuranVerseModel verse);
  Future<void> deleteQuranVerse(String id);

  Future<List<HadithModel>> getHadiths();
  Future<void> saveHadith(HadithModel hadith);
  Future<void> deleteHadith(String id);
}

class HiveContentRepository implements ContentRepository {
  static const String quranBox = 'quran_box';
  static const String hadithBox = 'hadith_box';

  Box<QuranVerseModel> _getQuranBox() => Hive.box<QuranVerseModel>(quranBox);
  Box<HadithModel> _getHadithBox() => Hive.box<HadithModel>(hadithBox);

  @override
  Future<List<QuranVerseModel>> getQuranVerses() async {
    final box = _getQuranBox();
    return box.values.toList();
  }

  @override
  Future<void> saveQuranVerse(QuranVerseModel verse) async {
    final box = _getQuranBox();
    await box.put(verse.id, verse);
  }

  @override
  Future<void> deleteQuranVerse(String id) async {
    final box = _getQuranBox();
    await box.delete(id);
  }

  @override
  Future<List<HadithModel>> getHadiths() async {
    final box = _getHadithBox();
    return box.values.toList();
  }

  @override
  Future<void> saveHadith(HadithModel hadith) async {
    final box = _getHadithBox();
    await box.put(hadith.id, hadith);
  }

  @override
  Future<void> deleteHadith(String id) async {
    final box = _getHadithBox();
    await box.delete(id);
  }
}
