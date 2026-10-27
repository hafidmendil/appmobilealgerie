// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'awareness_core_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResourceAdapter extends TypeAdapter<Resource> {
  @override
  final int typeId = 115;

  @override
  Resource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Resource(
      id: fields[0] as String,
      titleFr: fields[1] as String,
      titleAr: fields[2] as String,
      descriptionFr: fields[3] as String,
      descriptionAr: fields[4] as String,
      category: fields[5] as String,
      contentFr: fields[6] as String,
      contentAr: fields[7] as String,
      source: fields[8] as String?,
      verified: fields[9] as bool,
      publishedAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Resource obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titleFr)
      ..writeByte(2)
      ..write(obj.titleAr)
      ..writeByte(3)
      ..write(obj.descriptionFr)
      ..writeByte(4)
      ..write(obj.descriptionAr)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.contentFr)
      ..writeByte(7)
      ..write(obj.contentAr)
      ..writeByte(8)
      ..write(obj.source)
      ..writeByte(9)
      ..write(obj.verified)
      ..writeByte(10)
      ..write(obj.publishedAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AwarenessPartnerAdapter extends TypeAdapter<AwarenessPartner> {
  @override
  final int typeId = 116;

  @override
  AwarenessPartner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AwarenessPartner(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      wilayaId: fields[3] as String,
      communeId: fields[4] as String,
      verified: fields[5] as bool,
      contactEmail: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AwarenessPartner obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.wilayaId)
      ..writeByte(4)
      ..write(obj.communeId)
      ..writeByte(5)
      ..write(obj.verified)
      ..writeByte(6)
      ..write(obj.contactEmail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AwarenessPartnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AwarenessCampaignAdapter extends TypeAdapter<AwarenessCampaign> {
  @override
  final int typeId = 117;

  @override
  AwarenessCampaign read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AwarenessCampaign(
      id: fields[0] as String,
      partnerId: fields[1] as String,
      titleFr: fields[2] as String,
      titleAr: fields[3] as String,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      resourceIds: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AwarenessCampaign obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.partnerId)
      ..writeByte(2)
      ..write(obj.titleFr)
      ..writeByte(3)
      ..write(obj.titleAr)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.resourceIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AwarenessCampaignAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationAdapter extends TypeAdapter<Notification> {
  @override
  final int typeId = 118;

  @override
  Notification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Notification(
      id: fields[0] as String,
      userId: fields[1] as String?,
      anonymousSessionId: fields[2] as String?,
      type: fields[3] as NotificationType,
      titleFr: fields[4] as String,
      titleAr: fields[5] as String,
      bodyFr: fields[6] as String,
      bodyAr: fields[7] as String,
      isRead: fields[8] as bool,
      createdAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Notification obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.anonymousSessionId)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.titleFr)
      ..writeByte(5)
      ..write(obj.titleAr)
      ..writeByte(6)
      ..write(obj.bodyFr)
      ..writeByte(7)
      ..write(obj.bodyAr)
      ..writeByte(8)
      ..write(obj.isRead)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SecurityLogAdapter extends TypeAdapter<SecurityLog> {
  @override
  final int typeId = 119;

  @override
  SecurityLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecurityLog(
      id: fields[0] as String,
      action: fields[1] as String,
      userId: fields[2] as String?,
      anonymousSessionId: fields[3] as String?,
      timestamp: fields[4] as DateTime,
      details: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SecurityLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.action)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.anonymousSessionId)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.details);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecurityLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
