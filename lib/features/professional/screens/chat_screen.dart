import '../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/services/chat_repository.dart';
import 'package:projetmascara/features/professional/models/chat_message.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(),
);

class ChatScreen extends ConsumerStatefulWidget {
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null)
      return Scaffold(body: Center(child: Text(context.l10n.auto_non_connect)));

    final chatRepo = ref.watch(chatRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: chatRepo.getMessagesStream(
                currentUser.id,
                widget.otherUserId,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data ?? [];

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final m = messages[index];
                    final isMe = m.senderId == currentUser.id;
                    return _ChatBubble(message: m, isMe: isMe);
                  },
                );
              },
            ),
          ),
          _buildInput(currentUser.id),
        ],
      ),
    );
  }

  Widget _buildInput(String currentUserId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: context.l10n.writeMessageHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () => _sendMessage(currentUserId),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String currentUserId) {
    if (_messageController.text.trim().isEmpty) return;

    final message = ChatMessage(
      id: const Uuid().v4(),
      senderId: currentUserId,
      receiverId: widget.otherUserId,
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
    );

    ref.read(chatRepositoryProvider).sendMessage(message);
    _messageController.clear();
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _ChatBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12).copyWith(
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(12),
            bottomLeft: isMe
                ? const Radius.circular(12)
                : const Radius.circular(0),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 2),
            Text(
              "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
