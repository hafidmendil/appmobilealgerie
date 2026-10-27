import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/auth/user_role.dart';
import '../../core/data/hive_config.dart';
import '../../core/providers/backend_providers.dart';
import '../../core/models/user_model.dart';
import '../../core/localization/l10n_extension.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../features/professional/models/access_request.dart';
import 'models/message_model.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String otherId;
  final String otherName;

  const ChatPage({super.key, required this.otherId, required this.otherName});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final Box<MessageModel> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<MessageModel>(HiveConfig.messagesBox);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Stream<List<MessageModel>> _conversationStream(
    String me,
    String other,
  ) async* {
    final repository = ref.read(messageRepositoryProvider);
    yield await repository.getConversation(me, other);
    yield* _box.watch().asyncMap((_) => repository.getConversation(me, other));
  }

  Future<bool> _canCommunicate(String me) async {
    final user = ref.read(currentUserProvider);
    if (user == null || me.isEmpty) return false;

    // 1. Admin bypass
    if (user.role == UserRole.admin) return true;

    // 2. Check if other user is Admin
    final usersBox = Hive.box<UserModel>(HiveConfig.usersBox);
    final otherUser = usersBox.get(widget.otherId);
    if (otherUser?.role == UserRole.admin) return true;

    // 3. Normal access checks
    final repository = ref.read(professionalRepositoryProvider);
    if (user.role == UserRole.psychologist) {
      return await repository.getPatientById(me, widget.otherId) != null;
    }
    if (user.role == UserRole.user) {
      final requests = await repository.getRequestsForUser(me);
      return requests.any(
        (request) =>
            request.professionalId == widget.otherId &&
            request.status == AccessRequestStatus.accepted,
      );
    }
    return false;
  }

  Future<void> _sendMessage(String me) async {
    final text = _controller.text.trim();
    if (text.isEmpty || !await _canCommunicate(me)) return;

    final message = MessageModel(
      id: DateTime.now().microsecondsSinceEpoch,
      fromUserId: me,
      toUserId: widget.otherId,
      content: text,
      createdAt: DateTime.now(),
    );
    await ref.read(messageRepositoryProvider).sendMessage(message);
    _controller.clear();
  }

  String _getOtherSubtitle(BuildContext context) {
    final usersBox = Hive.box<UserModel>(HiveConfig.usersBox);
    final otherUser = usersBox.get(widget.otherId);
    if (otherUser != null) {
      switch (otherUser.role) {
        case UserRole.admin:
          return context.l10n.roleAdministrator;
        case UserRole.psychologist:
          return context.l10n.rolePsychologist;
        case UserRole.user:
          return context.l10n.rolePatient;
        case UserRole.guest:
          return context.l10n.roleGuest;
      }
    }
    return context.l10n.roleUser;
  }

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(currentUserProvider)?.id ?? '';
    final otherSubtitle = _getOtherSubtitle(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.otherName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              otherSubtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSecondary
                    : AppColors.textMuted,
              ),
            ),
          ],
        ),
        elevation: 0.5,
      ),
      body: FutureBuilder<bool>(
        future: _canCommunicate(me),
        builder: (context, accessSnapshot) {
          if (!accessSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (accessSnapshot.data != true) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: AppColors.textMuted.withAlpha(128),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.secureMessaging,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.messagingUnavailable,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                color: AppColors.skyBlue.withAlpha(24),
                child: Text(
                  context.l10n.localNotesNotice,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<MessageModel>>(
                  stream: _conversationStream(me, widget.otherId),
                  builder: (context, snapshot) {
                    final rawMessages = snapshot.data ?? const <MessageModel>[];
                    final messages = rawMessages.reversed.toList();

                    // Mark incoming messages as read
                    for (var msg in rawMessages) {
                      if (msg.fromUserId == widget.otherId &&
                          msg.status != 'read') {
                        ref.read(messageRepositoryProvider).markRead(msg.id);
                      }
                    }

                    if (messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: AppColors.textMuted.withAlpha(128),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.l10n.noMessages,
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.startConversation,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMine = message.fromUserId == me;

                        return _ChatBubble(message: message, isMine: isMine);
                      },
                    );
                  },
                ),
              ),
              _buildInputBar(me),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInputBar(String me) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background.withAlpha(100),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.textMuted.withAlpha(40)),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: context.l10n.writeLocalNoteHint,
                    hintStyle: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 15),
                  onSubmitted: (_) => _sendMessage(me),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: AppColors.oliveGreen,
              shape: const CircleBorder(),
              elevation: 1,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () => _sendMessage(me),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;

  const _ChatBubble({required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMine
        ? AppColors.oliveGreen
        : (Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkCard
              : Colors.grey.shade100);

    final textColor = isMine
        ? Colors.white
        : (Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkText
              : AppColors.textPrimary);

    final timeColor = isMine
        ? Colors.white70
        : (Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkSecondary
              : AppColors.textMuted);

    final hourMinute =
        "${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}";

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMine
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: isMine
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(color: textColor, fontSize: 15, height: 1.3),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hourMinute,
                  style: TextStyle(fontSize: 10, color: timeColor),
                ),
                if (isMine) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.status == 'read' ? Icons.done_all : Icons.done,
                    size: 14,
                    color: message.status == 'read'
                        ? AppColors.skyBlue
                        : Colors.white60,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
