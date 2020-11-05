// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_notes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubNotesAdapter extends TypeAdapter<SubNotes> {
  @override
  final int typeId = 2;

  @override
  SubNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubNotes(
      fields[0] as String,
      fields[1] as DateTime,
      fields[2] as String,
      fields[3] as String,
      photos: (fields[4] as List)?.cast<Photo>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubNotes obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isDate)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.subTitle)
      ..writeByte(4)
      ..write(obj.photos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
