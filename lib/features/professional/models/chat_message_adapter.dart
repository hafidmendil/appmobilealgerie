import 'package:hive/hive.dart';
import 'chat_message.dart';

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 201;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      fields[key] = reader.read();
    }
    return ChatMessage(
      id: fields[0] as String,
      senderId: fields[1] as String,
      receiverId: fields[2] as String,
      content: fields[3] as String,
      timestamp: fields[4] as DateTime,
      isRead: fields[5] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.senderId)
      ..writeByte(2)
      ..write(obj.receiverId)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.isRead);
  }
}
