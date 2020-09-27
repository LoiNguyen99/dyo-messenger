// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SmsTypeAdapter extends TypeAdapter<SmsType> {
  @override
  final int typeId = 2;

  @override
  SmsType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SmsType.ALL;
      case 1:
        return SmsType.INBOX;
      case 2:
        return SmsType.SENT;
      case 3:
        return SmsType.DRAFT;
      case 4:
        return SmsType.OUTBOX;
      case 5:
        return SmsType.FAILED;
      case 6:
        return SmsType.QUEUE;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, SmsType obj) {
    switch (obj) {
      case SmsType.ALL:
        writer.writeByte(0);
        break;
      case SmsType.INBOX:
        writer.writeByte(1);
        break;
      case SmsType.SENT:
        writer.writeByte(2);
        break;
      case SmsType.DRAFT:
        writer.writeByte(3);
        break;
      case SmsType.OUTBOX:
        writer.writeByte(4);
        break;
      case SmsType.FAILED:
        writer.writeByte(5);
        break;
      case SmsType.QUEUE:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmsTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
