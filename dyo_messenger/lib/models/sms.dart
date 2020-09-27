import 'dart:convert';

import 'package:dyo_messenger/models/sms_type.dart';
import 'package:hive/hive.dart';
part 'sms.g.dart';

@HiveType(typeId: 3)
class Sms {
  @HiveField(0)
  String id;

  @HiveField(1)
  String address;

  @HiveField(2)
  String body;

  @HiveField(3)
  bool read;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  DateTime dateSent;

  @HiveField(6)
  SmsType type;

  @HiveField(7)
  String status;

  @HiveField(8)
  int threadId;

  Sms({
    this.id,
    this.address,
    this.body,
    this.read,
    this.date,
    this.dateSent,
    this.type,
    this.status,
    this.threadId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'body': body,
      'isRead': read,
      'date': date.millisecondsSinceEpoch,
      'dateSent': dateSent.millisecondsSinceEpoch,
      'type': type.toString().split('.').last,
      'status': status,
      'threadId': threadId,
    };
  }

  factory Sms.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Sms(
      id: map['id'],
      address: map['address'],
      body: map['body'],
      read: map['read'],
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.parse(map['date'].toString().trim()))
          : null,
      dateSent: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.parse(map['dateSent'].toString().trim()))
          : null,
      type: map['type'] != null ? SmsType.values.firstWhere((element) =>
          element.toString().split('.').last.toLowerCase() ==
          map['type'].toString().toLowerCase()) : null,
      status: map['status'],
      threadId: int.parse(map['threadId'].toString().trim()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Sms.fromJson(String source) => Sms.fromMap(json.decode(source));
}
