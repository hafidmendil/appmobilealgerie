import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/professional/models/chat_message.dart';
import 'logger_service.dart';

class ChatRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<List<ChatMessage>> getMessagesStream(String senderId, String receiverId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((data) {
          return data
              .map((map) => ChatMessage.fromJson(map))
              .where((m) => 
                (m.senderId == senderId && m.receiverId == receiverId) ||
                (m.senderId == receiverId && m.receiverId == senderId))
              .toList();
        });
  }

  Future<void> sendMessage(ChatMessage message) async {
    try {
      await _supabase.from('messages').insert(message.toJson());
    } catch (e) {
      logger.e('Error sending message: $e');
      rethrow;
    }
  }

  Future<void> markAsRead(String messageId) async {
    await _supabase
        .from('messages')
        .update({'is_read': true})
        .eq('id', messageId);
  }
}
