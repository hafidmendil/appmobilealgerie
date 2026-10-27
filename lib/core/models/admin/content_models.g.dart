// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranVerseModelAdapter extends TypeAdapter<QuranVerseModel> {
  @override
  final int typeId = 30;

  @override
  QuranVerseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranVerseModel(
      id: fields[0] as String,
      surahNumber: fields[1] as int,
      verseNumber: fields[2] as int,
      textAr: fields[3] as String,
      textFr: fields[4] as String,
      theme: fields[5] as String,
      context: fields[6] as String?,
      reflection: fields[7] as String?,
      associatedAxesIndices: (fields[8] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuranVerseModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.surahNumber)
      ..writeByte(2)
      ..write(obj.verseNumber)
      ..writeByte(3)
      ..write(obj.textAr)
      ..writeByte(4)
      ..write(obj.textFr)
      ..writeByte(5)
      ..write(obj.theme)
      ..writeByte(6)
      ..write(obj.context)
      ..writeByte(7)
      ..write(obj.reflection)
      ..writeByte(8)
      ..write(obj.associatedAxesIndices);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranVerseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HadithModelAdapter extends TypeAdapter<HadithModel> {
  @override
  final int typeId = 31;

  @override
  HadithModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HadithModel(
      id: fields[0] as String,
      collection: fields[1] as String,
      number: fields[2] as String,
      textAr: fields[3] as String,
      textFr: fields[4] as String,
      theme: fields[5] as String,
      source: fields[6] as String?,
      associatedAxesIndices: (fields[7] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, HadithModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.collection)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.textAr)
      ..writeByte(4)
      ..write(obj.textFr)
      ..writeByte(5)
      ..write(obj.theme)
      ..writeByte(6)
      ..write(obj.source)
      ..writeByte(7)
      ..write(obj.associatedAxesIndices);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HadithModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
