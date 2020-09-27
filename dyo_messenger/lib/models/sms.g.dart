// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SmsAdapter extends TypeAdapter<Sms> {
  @override
  final int typeId = 3;

  @override
  Sms read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sms(
      id: fields[0] as String,
      address: fields[1] as String,
      body: fields[2] as String,
      read: fields[3] as bool,
      date: fields[4] as DateTime,
      dateSent: fields[5] as DateTime,
      type: fields[6] as SmsType,
      status: fields[7] as String,
      threadId: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Sms obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.read)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.dateSent)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.threadId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
