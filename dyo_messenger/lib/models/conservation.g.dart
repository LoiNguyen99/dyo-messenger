// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conservation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConservationAdapter extends TypeAdapter<Conservation> {
  @override
  final int typeId = 0;

  @override
  Conservation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Conservation(
      address: fields[0] as String,
      threadId: fields[1] as int,
      contact: fields[2] as Contact,
      messages: (fields[3] as List)?.cast<Sms>(),
    );
  }

  @override
  void write(BinaryWriter writer, Conservation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.threadId)
      ..writeByte(2)
      ..write(obj.contact)
      ..writeByte(3)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConservationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
