import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 200)
class MessageModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String fromUserId;

  @HiveField(2)
  final String toUserId;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String status; // sent/delivered/read

  MessageModel({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.content,
    required this.createdAt,
    this.status = 'sent',
  });

  MessageModel copyWith({
    int? id,
    String? fromUserId,
    String? toUserId,
    String? content,
    DateTime? createdAt,
    String? status,
  }) {
    return MessageModel(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fromUserId': fromUserId,
    'toUserId': toUserId,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'status': status,
  };

  factory MessageModel.fromJson(Map<String, dynamic> j) => MessageModel(
    id: j['id'] as int,
    fromUserId: j['fromUserId'] as String,
    toUserId: j['toUserId'] as String,
    content: j['content'] as String,
    createdAt: DateTime.parse(j['createdAt'] as String),
    status: j['status'] as String? ?? 'sent',
  );
}
