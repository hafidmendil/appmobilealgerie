import 'dart:async';
import '../../features/professional/models/chat_message.dart';
import 'logger_service.dart';
import 'package:hive/hive.dart';
import '../data/hive_config.dart';

class ChatRepository {
  static const String _boxName = 'chat_messages';

  Future<Box<ChatMessage>> _getBox() async {
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    return await Hive.openBox<ChatMessage>(
      _boxName,
      encryptionCipher: encryptionCipher,
    );
  }

  Stream<List<ChatMessage>> getMessagesStream(
    String senderId,
    String receiverId,
  ) async* {
    final box = await _getBox();

    // Initial data
    yield _filterMessages(box.values.toList(), senderId, receiverId);

    // Listen for changes
    await for (final _ in box.watch()) {
      yield _filterMessages(box.values.toList(), senderId, receiverId);
    }
  }

  List<ChatMessage> _filterMessages(
    List<ChatMessage> messages,
    String senderId,
    String receiverId,
  ) {
    final filtered = messages
        .where(
          (m) =>
              (m.senderId == senderId && m.receiverId == receiverId) ||
              (m.senderId == receiverId && m.receiverId == senderId),
        )
        .toList();
    filtered.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return filtered;
  }

  Future<void> sendMessage(ChatMessage message) async {
    try {
      final box = await _getBox();
      await box.put(message.id, message);
    } catch (e) {
      logger.e('Local Chat: Error sending message: $e');
      rethrow;
    }
  }

  Future<void> markAsRead(String messageId) async {
    final box = await _getBox();
    final message = box.get(messageId);
    if (message != null) {
      final updated = ChatMessage(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        timestamp: message.timestamp,
        isRead: true,
      );
      await box.put(messageId, updated);
    }
  }
}
