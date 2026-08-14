import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projetmascara/core/services/logger_service.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      logger.e('Error writing to secure storage', e);
      rethrow;
    }
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      logger.e('Error reading from secure storage', e);
      return null;
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      logger.e('Error deleting from secure storage', e);
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      logger.e('Error clearing secure storage', e);
    }
  }
}
