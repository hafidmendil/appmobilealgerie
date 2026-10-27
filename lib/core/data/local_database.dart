import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/services/logger_service.dart';

/// Centralized Local Database Abstraction wrapping Hive persistence.
/// All features and repositories access Hive storage through this unified interface.
class LocalDatabase {
  static LocalDatabase? _instance;

  LocalDatabase._();

  static LocalDatabase get instance {
    _instance ??= LocalDatabase._();
    return _instance!;
  }

  /// Retrieves an opened Hive box by name and type [T].
  Box<T> getBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw StateError(
        'Box "$boxName" is not opened. Ensure HiveConfig.init() was executed.',
      );
    }
    return Hive.box<T>(boxName);
  }

  /// Safely checks if a box exists and is currently open.
  bool isBoxOpen(String boxName) => Hive.isBoxOpen(boxName);

  /// Saves or updates a value in a specified box by key.
  Future<void> put<T>(String boxName, dynamic key, T value) async {
    final box = getBox<T>(boxName);
    await box.put(key, value);
  }

  /// Retrieves a value by key from a specified box with optional default fallback.
  T? get<T>(String boxName, dynamic key, {T? defaultValue}) {
    final box = getBox<T>(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  /// Retrieves all values stored in a specified box.
  List<T> getAll<T>(String boxName) {
    final box = getBox<T>(boxName);
    return box.values.toList();
  }

  /// Deletes an entry by key from a specified box.
  Future<void> delete<T>(String boxName, dynamic key) async {
    final box = getBox<T>(boxName);
    await box.delete(key);
  }

  /// Clears all entries from a specific box.
  Future<void> clearBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box(boxName);
      await box.clear();
      logger.i('Cleared box: $boxName');
    }
  }

  /// Compacts all open Hive boxes to optimize disk storage.
  Future<void> compactAllBoxes() async {
    logger.i('Starting Hive box compaction...');
    for (final boxName in [
      HiveConfig.usersBox,
      HiveConfig.assessmentResultsBox,
      HiveConfig.messagesBox,
      HiveConfig.syncQueueBox,
      HiveConfig.protectionReportsBox,
      HiveConfig.protectionRiskAssessmentsBox,
      HiveConfig.voiceNotesBox,
      HiveConfig.violenceCasesBox,
      HiveConfig.violenceAssessmentsBox,
      HiveConfig.riskAssessmentsBox,
      HiveConfig.specialistBox,
      HiveConfig.partnerBox,
      HiveConfig.referralBox,
      HiveConfig.legalArticlesBox,
      HiveConfig.legalAssessmentsBox,
      HiveConfig.consentBox,
      HiveConfig.reportsBox,
      HiveConfig.notificationsBox,
    ]) {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).compact();
      }
    }
    logger.i('Hive box compaction completed');
  }
}
