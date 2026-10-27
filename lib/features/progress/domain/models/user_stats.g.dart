// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatsAdapter extends TypeAdapter<UserStats> {
  @override
  final int typeId = 27;

  @override
  UserStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStats(
      xp: fields[0] as int,
      level: fields[1] as int,
      streak: fields[2] as int,
      badgeIds: (fields[3] as List).cast<String>(),
      lastActionDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserStats obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.xp)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.streak)
      ..writeByte(3)
      ..write(obj.badgeIds)
      ..writeByte(4)
      ..write(obj.lastActionDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
