// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncItemAdapter extends TypeAdapter<SyncItem> {
  @override
  final int typeId = 6;

  @override
  SyncItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncItem(
      id: fields[0] as String,
      type: fields[1] as String,
      operation: fields[2] as SyncOperation,
      payload: (fields[3] as Map).cast<String, dynamic>(),
      createdAt: fields[4] as DateTime,
      retries: fields[5] as int,
      lastError: fields[6] as String?,
      entityId: fields[7] as String?,
      updatedAt: fields[8] as DateTime?,
      syncStatus: fields[9] as SyncStatus,
      priority: fields[10] as int,
      userId: fields[11] as String?,
      consentContext: fields[12] as String?,
      version: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SyncItem obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.operation)
      ..writeByte(3)
      ..write(obj.payload)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.retries)
      ..writeByte(6)
      ..write(obj.lastError)
      ..writeByte(7)
      ..write(obj.entityId)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.syncStatus)
      ..writeByte(10)
      ..write(obj.priority)
      ..writeByte(11)
      ..write(obj.userId)
      ..writeByte(12)
      ..write(obj.consentContext)
      ..writeByte(13)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncOperationAdapter extends TypeAdapter<SyncOperation> {
  @override
  final int typeId = 5;

  @override
  SyncOperation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncOperation.create;
      case 1:
        return SyncOperation.update;
      case 2:
        return SyncOperation.delete;
      default:
        return SyncOperation.create;
    }
  }

  @override
  void write(BinaryWriter writer, SyncOperation obj) {
    switch (obj) {
      case SyncOperation.create:
        writer.writeByte(0);
        break;
      case SyncOperation.update:
        writer.writeByte(1);
        break;
      case SyncOperation.delete:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncOperationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 7;

  @override
  SyncStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncStatus.pending;
      case 1:
        return SyncStatus.syncing;
      case 2:
        return SyncStatus.synced;
      case 3:
        return SyncStatus.failed;
      case 4:
        return SyncStatus.conflict;
      case 5:
        return SyncStatus.cancelled;
      default:
        return SyncStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, SyncStatus obj) {
    switch (obj) {
      case SyncStatus.pending:
        writer.writeByte(0);
        break;
      case SyncStatus.syncing:
        writer.writeByte(1);
        break;
      case SyncStatus.synced:
        writer.writeByte(2);
        break;
      case SyncStatus.failed:
        writer.writeByte(3);
        break;
      case SyncStatus.conflict:
        writer.writeByte(4);
        break;
      case SyncStatus.cancelled:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
