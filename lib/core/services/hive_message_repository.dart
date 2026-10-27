import 'package:hive/hive.dart';
import 'package:projetmascara/features/messaging/models/message_model.dart';
import 'package:projetmascara/core/data/hive_config.dart';

class HiveMessageRepository {
  Box<MessageModel> _box() => Hive.box<MessageModel>(HiveConfig.messagesBox);

  Future<List<MessageModel>> getConversation(String userA, String userB) async {
    final box = _box();
    final items = box.values.where((m) {
      return (m.fromUserId == userA && m.toUserId == userB) ||
          (m.fromUserId == userB && m.toUserId == userA);
    }).toList();
    items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return items;
  }

  Future<void> sendMessage(MessageModel message) async {
    final box = _box();
    await box.put(message.id, message);
  }

  Future<List<MessageModel>> getAllForUser(String userId) async {
    final box = _box();
    final items = box.values
        .where((m) => m.fromUserId == userId || m.toUserId == userId)
        .toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> markRead(int messageId) async {
    final box = _box();
    final m = box.get(messageId);
    if (m != null) {
      await box.put(messageId, m.copyWith(status: 'read'));
    }
  }
}
