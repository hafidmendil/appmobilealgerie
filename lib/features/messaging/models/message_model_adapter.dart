import 'package:hive/hive.dart';
import 'message_model.dart';

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 200;

  @override
  MessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final key = reader.readByte();
      fields[key] = reader.read();
    }
    return MessageModel(
      id: fields[0] as int,
      fromUserId: fields[1] as String,
      toUserId: fields[2] as String,
      content: fields[3] as String,
      createdAt: fields[4] as DateTime,
      status: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fromUserId)
      ..writeByte(2)
      ..write(obj.toUserId)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.status);
  }
}
