import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/services/secure_storage_service.dart';
import 'package:projetmascara/core/services/logger_service.dart';

class HiveConfig {
  static const String _encryptionKey = 'hive_encryption_key';
  
  static Future<HiveCipher?> getEncryptionCipher() async {
    final secureStorage = SecureStorageService();
    String? key = await secureStorage.read(_encryptionKey);
    
    if (key == null) {
      final newKey = Hive.generateSecureKey();
      await secureStorage.write(_encryptionKey, base64UrlEncode(newKey));
      key = base64UrlEncode(newKey);
      logger.i('Generated new encryption key for Hive');
    }

    return HiveAesCipher(base64Url.decode(key));
  }
}
